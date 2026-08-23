import 'package:checkin_flutter/core/models/team_models.dart';
import 'package:checkin_flutter/features/team/team_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingRequestsPage extends ConsumerStatefulWidget {
  const PendingRequestsPage({super.key});

  @override
  ConsumerState<PendingRequestsPage> createState() => _PendingRequestsPageState();
}

class _PendingRequestsPageState extends ConsumerState<PendingRequestsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pendingRequestsProvider.notifier).loadRequests();
    });
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pendingRequestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('الطلبات المعلقة')),
      body: state.status == PendingRequestsLoadStatus.loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFDC2626)))
          : state.status == PendingRequestsLoadStatus.error
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
                      const SizedBox(height: 8),
                      Text(state.errorMessage ?? 'حدث خطأ'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(pendingRequestsProvider.notifier).loadRequests(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref.read(pendingRequestsProvider.notifier).loadRequests(),
                  child: state.items.isEmpty
                      ? const Center(child: Text('لا توجد طلبات معلقة'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.items.length,
                          itemBuilder: (context, index) => _buildRequestCard(state.items[index]),
                        ),
                ),
    );
  }

  Widget _buildRequestCard(PendingRequestDto r) {
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
                Text(r.requestNumber, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFDC2626))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(4)),
                  child: const Text('معلق', style: TextStyle(color: Color(0xFFF59E0B), fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 20, color: Color(0xFF6B7280)),
                const SizedBox(width: 4),
                Text(r.employeeDisplayName, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.category_outlined, size: 20, color: Color(0xFF6B7280)),
                const SizedBox(width: 4),
                Text(r.typeNameAr ?? r.typeName),
                const Spacer(),
                Text('${r.daysCount} يوم', style: const TextStyle(color: Color(0xFF6B7280))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 20, color: Color(0xFF6B7280)),
                const SizedBox(width: 4),
                Text(_formatDate(r.effectiveDate)),
              ],
            ),
            const SizedBox(height: 8),
            Text('السبب: ${r.reason}', style: const TextStyle(color: Color(0xFF6B7280))),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _reject(r),
                    style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFEF4444), side: const BorderSide(color: Color(0xFFEF4444))),
                    child: const Text('رفض'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _approve(r),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                    child: const Text('موافقة'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _approve(PendingRequestDto r) async {
    final success = await ref.read(pendingRequestsProvider.notifier).approveRequest(r.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'تمت الموافقة على ${r.requestNumber}' : 'فشلت الموافقة')),
      );
    }
  }

  void _reject(PendingRequestDto r) async {
    final success = await ref.read(pendingRequestsProvider.notifier).rejectRequest(r.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'تم رفض ${r.requestNumber}' : 'فشل الرفض')),
      );
    }
  }
}
