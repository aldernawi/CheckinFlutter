import 'package:checkin_flutter/core/models/field_visit_models.dart';
import 'package:checkin_flutter/features/field_visits/field_visits_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FieldVisitsPage extends ConsumerStatefulWidget {
  const FieldVisitsPage({super.key});

  @override
  ConsumerState<FieldVisitsPage> createState() => _FieldVisitsPageState();
}

class _FieldVisitsPageState extends ConsumerState<FieldVisitsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fieldVisitsProvider.notifier).loadTodayVisits();
    });
  }

  String _formatTime(DateTime t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  Color _statusColor(FieldVisitListItemDto v) {
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

  String _statusText(FieldVisitListItemDto v) {
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
    final state = ref.watch(fieldVisitsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('زيارات اليوم')),
      body: state.status == FieldVisitsLoadStatus.loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFDC2626)))
          : state.status == FieldVisitsLoadStatus.error
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
                      const SizedBox(height: 8),
                      Text(state.errorMessage ?? 'حدث خطأ'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(fieldVisitsProvider.notifier).loadTodayVisits(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref.read(fieldVisitsProvider.notifier).loadTodayVisits(),
                  child: Column(
                    children: [
                      if (state.summary != null) _buildSummaryCard(state.summary!),
                      Expanded(
                        child: state.summary == null || state.summary!.visits.isEmpty
                            ? const Center(child: Text('لا توجد زيارات اليوم'))
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: state.summary!.visits.length,
                                itemBuilder: (context, index) => _buildVisitCard(state.summary!.visits[index]),
                              ),
                      ),
                    ],
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/fieldrep/stores'),
        backgroundColor: const Color(0xFFDC2626),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSummaryCard(TodayVisitsSummaryDto s) {
    final met = s.metMinimum;
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('ملخص اليوم', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: met ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    met ? 'تحقق الحد الأدنى' : 'متبقي ${s.remainingVisits} زيارة',
                    style: TextStyle(color: met ? const Color(0xFF10B981) : const Color(0xFFF59E0B), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStat('إجمالي الزيارات', '${s.totalVisits}', const Color(0xFFDC2626)),
                _buildStat('الحد الأدنى', '${s.minRequiredVisits}', const Color(0xFF3B82F6)),
                _buildStat('المتبقي', '${s.remainingVisits}', const Color(0xFFF59E0B)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
        ],
      ),
    );
  }

  Widget _buildVisitCard(FieldVisitListItemDto v) {
    final color = _statusColor(v);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(Icons.store, color: color),
        ),
        title: Row(
          children: [
            Text(v.storeDisplayName, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (v.isFirstVisitOfDay) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(4)),
                child: const Text('أول زيارة', style: TextStyle(color: Color(0xFF10B981), fontSize: 10)),
              ),
            ],
          ],
        ),
        subtitle: Text('الوقت: ${_formatTime(v.checkInTime)} - المدة: ${v.durationMinutes ?? 0} د - المسافة: ${v.distanceFromStore}م'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
          child: Text(_statusText(v), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
