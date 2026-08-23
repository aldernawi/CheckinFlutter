import 'package:checkin_flutter/core/models/store_models.dart';
import 'package:checkin_flutter/features/stores/stores_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UnvisitedStoresPage extends ConsumerStatefulWidget {
  const UnvisitedStoresPage({super.key});

  @override
  ConsumerState<UnvisitedStoresPage> createState() => _UnvisitedStoresPageState();
}

class _UnvisitedStoresPageState extends ConsumerState<UnvisitedStoresPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(unvisitedStoresProvider.notifier).loadUnvisited();
    });
  }

  String _formatDate(DateTime? d) {
    if (d == null) return '--';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(unvisitedStoresProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('محلات غير متابعة')),
      body: state.status == UnvisitedLoadStatus.loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFDC2626)))
          : state.status == UnvisitedLoadStatus.error
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
                      const SizedBox(height: 8),
                      Text(state.errorMessage ?? 'حدث خطأ'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.read(unvisitedStoresProvider.notifier).loadUnvisited(),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref.read(unvisitedStoresProvider.notifier).loadUnvisited(),
                  child: state.items.isEmpty
                      ? const Center(child: Text('جميع المحلات تمت زيارتها'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: state.items.length,
                          itemBuilder: (context, index) => _buildCard(state.items[index]),
                        ),
                ),
    );
  }

  Widget _buildCard(UnvisitedStoreDto s) {
    final urgencyColor = s.daysSinceLastVisit > 20 ? const Color(0xFFEF4444) : (s.daysSinceLastVisit > 10 ? const Color(0xFFF59E0B) : const Color(0xFF3B82F6));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(backgroundColor: urgencyColor.withValues(alpha: 0.1), child: Icon(Icons.storefront, color: urgencyColor)),
        title: Text(s.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (s.city != null) Text(s.city!),
            Text('آخر زيارة: ${_formatDate(s.lastVisitDate)}', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: urgencyColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Text(
            '${s.daysSinceLastVisit} يوم',
            style: TextStyle(color: urgencyColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () => context.go('/fieldrep/stores/${s.id}'),
      ),
    );
  }
}
