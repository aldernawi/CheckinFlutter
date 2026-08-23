import 'package:checkin_flutter/core/models/history_models.dart';
import 'package:checkin_flutter/features/history/history_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(historyProvider.notifier).loadHistory();
    });
  }

  Color _statusColor(AttendanceRecordDto r) {
    if (r.checkInTime == null) return const Color(0xFFEF4444);
    if (r.lateMinutes > 0) return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }

  String _statusText(AttendanceRecordDto r) {
    if (r.checkInTime == null) return 'غائب';
    if (r.lateMinutes > 0) return 'متأخر';
    return 'حاضر';
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '--:--';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('سجل الحضور')),
      body: state.status == HistoryLoadStatus.loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFDC2626)))
          : state.status == HistoryLoadStatus.error
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
                      const SizedBox(height: 8),
                      Text(state.errorMessage ?? 'حدث خطأ'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(historyProvider.notifier).loadHistory(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref.read(historyProvider.notifier).loadHistory(),
                  child: state.items.isEmpty
                      ? const Center(child: Text('لا توجد سجلات'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            final r = state.items[index];
                            final color = _statusColor(r);
                            final statusText = _statusText(r);
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: CircleAvatar(
                                  backgroundColor: color.withValues(alpha: 0.1),
                                  child: Icon(Icons.calendar_today, color: color),
                                ),
                                title: Text(_formatDate(r.date), style: const TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: Text('دخول: ${_formatTime(r.checkInTime)} - خروج: ${_formatTime(r.checkOutTime)}'),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                  child: Text(statusText, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
                                ),
                                onTap: () => context.go('/attendance/$index'),
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}
