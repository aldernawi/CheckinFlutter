import 'package:checkin_flutter/core/models/store_models.dart';
import 'package:checkin_flutter/features/stores/stores_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StoresPage extends ConsumerStatefulWidget {
  const StoresPage({super.key});

  @override
  ConsumerState<StoresPage> createState() => _StoresPageState();
}

class _StoresPageState extends ConsumerState<StoresPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(storesProvider.notifier).loadStores();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    setState(() => _searchQuery = query);
    ref.read(storesProvider.notifier).loadStores(search: query.isEmpty ? null : query);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(storesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('المحلات')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: 'بحث عن محل...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE5E7EB))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFDC2626))),
              ),
            ),
          ),
          Expanded(
            child: state.status == StoresLoadStatus.loading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFDC2626)))
                : state.status == StoresLoadStatus.error
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
                            const SizedBox(height: 8),
                            Text(state.errorMessage ?? 'حدث خطأ'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => ref.read(storesProvider.notifier).loadStores(search: _searchQuery.isEmpty ? null : _searchQuery),
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => ref.read(storesProvider.notifier).loadStores(search: _searchQuery.isEmpty ? null : _searchQuery),
                        child: state.stores.isEmpty
                            ? const Center(child: Text('لا توجد محلات'))
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: state.stores.length,
                                itemBuilder: (context, index) => _buildStoreCard(state.stores[index]),
                              ),
                      ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'map',
            mini: true,
            onPressed: () => context.go('/fieldrep/stores/map'),
            backgroundColor: const Color(0xFF3B82F6),
            child: const Icon(Icons.map, color: Colors.white),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'unvisited',
            mini: true,
            onPressed: () => context.go('/fieldrep/stores/unvisited'),
            backgroundColor: const Color(0xFFF59E0B),
            child: const Icon(Icons.storefront_outlined, color: Colors.white),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => context.go('/fieldrep/stores/add'),
            backgroundColor: const Color(0xFFDC2626),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(StoreListItemDto s) {
    final visited = s.visitsCount > 0;
    final statusColor = visited
        ? const Color(0xFF10B981)
        : (s.distanceInMeters != null ? const Color(0xFF3B82F6) : const Color(0xFF6B7280));
    final statusText = visited ? 'تمت الزيارة' : (s.distanceInMeters != null ? 'في النطاق' : 'خارج النطاق');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(backgroundColor: statusColor.withValues(alpha: 0.1), child: Icon(Icons.store, color: statusColor)),
        title: Text(s.displayName, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (s.city != null) Text(s.city!),
            if (s.distanceInMeters != null) Text('${s.distanceInMeters!.toStringAsFixed(0)} متر', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
          child: Text(statusText, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
        ),
        onTap: () => context.go('/fieldrep/stores/${s.id}'),
      ),
    );
  }
}
