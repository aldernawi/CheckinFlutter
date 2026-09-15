import 'package:checkin_flutter/core/models/history_models.dart';
import 'package:checkin_flutter/features/history/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceDetailsPage extends ConsumerStatefulWidget {
  const AttendanceDetailsPage({
    super.key,
    required this.attendanceId,
    this.initialRecord,
  });

  final String attendanceId;
  final AttendanceRecordDto? initialRecord;

  @override
  ConsumerState<AttendanceDetailsPage> createState() =>
      _AttendanceDetailsPageState();
}

class _AttendanceDetailsPageState extends ConsumerState<AttendanceDetailsPage> {
  @override
  void initState() {
    super.initState();
    if (widget.initialRecord == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(historyProvider.notifier).loadHistory();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(historyProvider);
    final matches = history.items.where((r) => r.id == widget.attendanceId);
    final record =
        widget.initialRecord ?? (matches.isEmpty ? null : matches.first);

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الحضور')),
      body: record == null
          ? history.status == HistoryLoadStatus.loading
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        history.errorMessage ?? 'تعذر العثور على سجل الحضور',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatDate(record.date),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _row(
                          'الحالة',
                          _statusText(record),
                          _statusColor(record),
                        ),
                        _row('وقت الدخول', _formatTime(record.checkInTime)),
                        _row('وقت الخروج', _formatTime(record.checkOutTime)),
                        _row('مدة العمل', _minutes(record.workedMinutes)),
                        _row('التأخير', _minutes(record.lateMinutes)),
                        _row('الإضافي', _minutes(record.overtimeMinutes)),
                        _row(
                          'المغادرة المبكرة',
                          _minutes(record.earlyDepartureMinutes),
                        ),
                        _row(
                          'موقع الدخول',
                          record.checkInLocation?.nameAr ??
                              record.checkInLocation?.name ??
                              'غير مسجل',
                        ),
                        _row(
                          'موقع الخروج',
                          record.checkOutLocation?.nameAr ??
                              record.checkOutLocation?.name ??
                              'غير مسجل',
                        ),
                        if (record.notes?.trim().isNotEmpty == true)
                          _row('ملاحظات', record.notes!),
                        if (record.showReviewStatus)
                          _row(
                            'مراجعة التسجيل دون اتصال',
                            record.offlineReviewStatusText ?? '',
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _formatTime(DateTime? value) => value == null
      ? 'غير مسجل'
      : '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';

  String _minutes(int total) =>
      total < 60 ? '$total دقيقة' : '${total ~/ 60} س ${total % 60} د';

  String _statusText(AttendanceRecordDto record) {
    if (record.checkInTime == null) return 'غائب';
    if (record.lateMinutes > 0) return 'متأخر';
    return 'حاضر';
  }

  Color _statusColor(AttendanceRecordDto record) {
    if (record.checkInTime == null) return const Color(0xFFEF4444);
    if (record.lateMinutes > 0) return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }

  Widget _row(String label, String value, [Color? valueColor]) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Color(0xFF6B7280))),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(fontWeight: FontWeight.w600, color: valueColor),
          ),
        ),
      ],
    ),
  );
}
