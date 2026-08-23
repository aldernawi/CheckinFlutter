import 'package:checkin_flutter/core/models/request_models.dart';
import 'package:checkin_flutter/features/requests/requests_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RequestsPage extends ConsumerStatefulWidget {
  const RequestsPage({super.key});

  @override
  ConsumerState<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends ConsumerState<RequestsPage> {
  RequestStatus? _filter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(requestsProvider.notifier).loadRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(requestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('طلباتي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/new-request'),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(child: _buildBody(state)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFDC2626),
        foregroundColor: Colors.white,
        onPressed: () => context.go('/new-request'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildChip('الكل', null),
          const SizedBox(width: 8),
          _buildChip('قيد الانتظار', RequestStatus.pending),
          const SizedBox(width: 8),
          _buildChip('موافق عليها', RequestStatus.approved),
          const SizedBox(width: 8),
          _buildChip('مرفوضة', RequestStatus.rejected),
          const SizedBox(width: 8),
          _buildChip('ملغاة', RequestStatus.cancelled),
        ],
      ),
    );
  }

  Widget _buildChip(String label, RequestStatus? status) {
    final isSelected = _filter == status;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _filter = status);
        ref.read(requestsProvider.notifier).loadRequests(statusFilter: status);
      },
      selectedColor: const Color(0xFFDC2626),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : const Color(0xFF6B7280),
      ),
    );
  }

  Widget _buildBody(RequestsState state) {
    if (state.status == RequestsLoadStatus.loading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFDC2626)));
    }

    if (state.status == RequestsLoadStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFFEF4444)),
            const SizedBox(height: 16),
            Text(state.errorMessage ?? 'حدث خطأ'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(requestsProvider.notifier).loadRequests(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 64, color: Color(0xFFD1D5DB)),
            const SizedBox(height: 16),
            const Text('لا توجد طلبات', style: TextStyle(color: Color(0xFF6B7280))),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go('/new-request'),
              child: const Text('إنشاء طلب جديد'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFDC2626),
      onRefresh: () => ref.read(requestsProvider.notifier).loadRequests(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.items.length,
        itemBuilder: (context, index) => _buildRequestCard(state.items[index]),
      ),
    );
  }

  Widget _buildRequestCard(RequestDto request) {
    final statusColor = _getStatusColor(request.status);
    final typeLabel = request.typeNameAr ?? request.typeName;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/request/${request.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      typeLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      request.statusName,
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                request.requestNumber,
                style: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
              ),
              const SizedBox(height: 4),
              Text(
                request.reason,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 4),
                  Text(
                    request.effectiveDate,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return const Color(0xFFF59E0B);
      case RequestStatus.approved:
        return const Color(0xFF10B981);
      case RequestStatus.rejected:
        return const Color(0xFFEF4444);
      case RequestStatus.cancelled:
        return const Color(0xFF9CA3AF);
    }
  }
}
