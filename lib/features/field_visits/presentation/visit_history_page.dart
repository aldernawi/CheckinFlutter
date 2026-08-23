import 'package:checkin_flutter/core/models/field_visit_models.dart';
import 'package:checkin_flutter/features/field_visits/field_visits_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VisitHistoryPage extends ConsumerStatefulWidget {
  const VisitHistoryPage({super.key});

  @override
  ConsumerState<VisitHistoryPage> createState() => _VisitHistoryPageState();
}

class _VisitHistoryPageState extends ConsumerState<VisitHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(visitHistoryProvider.notifier).loadHistory();
    });
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  Color _statusColor(FieldVisitDto v) {
    switch (v.status) {
      case 1:
        return const Color(0xFF10B981);
      case 2:
        return const Color(0xFFF59E0B);
      case 3:
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _statusText(FieldVisitDto v) {
    switch (v.status) {
      case 1:
        return 'مكتملة';
      case 2:
        return 'جزئية';
      case 3:
        return 'خارج النطاق';
      default:
        return 'غير معروف';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(visitHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('سجل الزيارات')),
      body: state.status == VisitHistoryLoadStatus.loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFDC2626)))
          : state.status == VisitHistoryLoadStatus.error
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
                      const SizedBox(height: 8),
                      Text(state.errorMessage ?? 'حدث خطأ'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(visitHistoryProvider.notifier).loadHistory(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref.read(visitHistoryProvider.notifier).loadHistory(),
                  child: state.items.isEmpty
                      ? const Center(child: Text('لا توجد زيارات'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.items.length,
                          itemBuilder: (context, index) => _buildVisitCard(state.items[index]),
                        ),
                ),
    );
  }

  Widget _buildVisitCard(FieldVisitDto v) {
    final color = _statusColor(v);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDate(v.visitDate), style: const TextStyle(fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text(_statusText(v), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Icon(Icons.store, size: 20, color: Color(0xFF6B7280)),
                const SizedBox(width: 4),
                Text(v.store.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 20, color: Color(0xFF6B7280)),
                const SizedBox(width: 4),
                Text('الدخول: ${_formatTime(v.checkInTime)}'),
                const Spacer(),
                Text('المدة: ${v.durationMinutes ?? 0} د', style: const TextStyle(color: Color(0xFF6B7280))),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.straighten, size: 20, color: Color(0xFF6B7280)),
                const SizedBox(width: 4),
                Text('المسافة: ${v.distanceFromStore} متر'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
