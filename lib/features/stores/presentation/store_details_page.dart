import 'package:checkin_flutter/core/models/store_models.dart';
import 'package:checkin_flutter/features/stores/stores_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoreDetailsPage extends ConsumerStatefulWidget {
  const StoreDetailsPage({super.key, required this.storeId});

  final String storeId;

  @override
  ConsumerState<StoreDetailsPage> createState() => _StoreDetailsPageState();
}

class _StoreDetailsPageState extends ConsumerState<StoreDetailsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(storeDetailsProvider.notifier).loadStore(widget.storeId);
    });
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime t) {
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }

  Color _visitStatusColor(StoreVisitDto v) {
    switch (v.status) {
      case VisitStatus.completed:
        return const Color(0xFF10B981);
      case VisitStatus.outOfRange:
        return const Color(0xFFEF4444);
      case VisitStatus.partial:
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _visitStatusText(StoreVisitDto v) {
    switch (v.status) {
      case VisitStatus.completed:
        return 'مكتملة';
      case VisitStatus.outOfRange:
        return 'خارج النطاق';
      case VisitStatus.partial:
        return 'جزئية';
      case VisitStatus.cancelled:
        return 'ملغاة';
      case VisitStatus.pendingReview:
        return 'قيد المراجعة';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storeDetailsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المحل')),
      body: state.status == StoreDetailsLoadStatus.loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFDC2626)))
          : state.status == StoreDetailsLoadStatus.error
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
                      const SizedBox(height: 8),
                      Text(state.errorMessage ?? 'حدث خطأ'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(storeDetailsProvider.notifier).loadStore(widget.storeId),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : state.store == null
                  ? const Center(child: Text('لا توجد بيانات'))
                  : RefreshIndicator(
                      onRefresh: () => ref.read(storeDetailsProvider.notifier).loadStore(widget.storeId),
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(state.store!.displayName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 12),
                                  _buildRow('الرمز', state.store!.storeCode),
                                  if (state.store!.city != null) _buildRow('المدينة', state.store!.city!),
                                  if (state.store!.district != null) _buildRow('الحي', state.store!.district!),
                                  if (state.store!.ownerName != null) _buildRow('المالك', state.store!.ownerName!),
                                  if (state.store!.ownerPhone1 != null) _buildRow('الهاتف', state.store!.ownerPhone1!),
                                  _buildRow('إجمالي الزيارات', '${state.store!.totalVisits} زيارة'),
                                  if (state.store!.lastVisitDate != null) _buildRow('آخر زيارة', _formatDate(state.store!.lastVisitDate!)),
                                  if (state.store!.distanceInMeters != null) _buildRow('المسافة', '${state.store!.distanceInMeters!.toStringAsFixed(0)} متر'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text('سجل الزيارات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...state.visits.map((v) {
                            final color = _visitStatusColor(v);
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(backgroundColor: color.withValues(alpha: 0.1), child: Icon(Icons.history, color: color, size: 20)),
                                title: Text(_formatDate(v.visitDate), style: const TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: Text('الوقت: ${_formatTime(v.checkInTime)} - المدة: ${v.durationMinutes ?? 0} د - المسافة: ${v.distanceFromStore}م'),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                                  child: Text(_visitStatusText(v), style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/fieldrep/stores/${widget.storeId}/record-visit'),
        backgroundColor: const Color(0xFF10B981),
        icon: const Icon(Icons.check_circle, color: Colors.white),
        label: const Text('تسجيل زيارة', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF6B7280))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
