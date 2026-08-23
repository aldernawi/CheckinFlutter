import 'package:checkin_flutter/core/models/request_models.dart';
import 'package:checkin_flutter/features/requests/requests_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RequestDetailsPage extends ConsumerWidget {
  const RequestDetailsPage({required this.requestId, super.key});

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(requestsProvider);
    final request = state.items.where((r) => r.id == requestId).firstOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: request == null
          ? const Center(child: Text('الطلب غير موجود'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusBanner(request),
                  const SizedBox(height: 20),
                  _buildInfoRow('رقم الطلب', request.requestNumber),
                  _buildInfoRow('النوع', request.typeNameAr ?? request.typeName),
                  _buildInfoRow('الحالة', request.statusName),
                  _buildInfoRow('تاريخ البداية', request.effectiveDate),
                  if (request.endDate != null)
                    _buildInfoRow('تاريخ النهاية', request.endDate!),
                  _buildInfoRow('السبب', request.reason),
                  if (request.rejectionReason != null)
                    _buildInfoRow('سبب الرفض', request.rejectionReason!),
                  if (request.approverName != null)
                    _buildInfoRow('المعتمد', request.approverName!),
                  _buildInfoRow(
                    'تاريخ الإنشاء',
                    '${request.createdAt.day}/${request.createdAt.month}/${request.createdAt.year}',
                  ),
                  if (request.processedAt != null)
                    _buildInfoRow(
                      'تاريخ المعالجة',
                      '${request.processedAt!.day}/${request.processedAt!.month}/${request.processedAt!.year}',
                    ),
                  const SizedBox(height: 24),
                  if (request.status == RequestStatus.pending)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () async {
                          final success =
                              await ref.read(requestsProvider.notifier).cancelRequest(requestId);
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم إلغاء الطلب')),
                            );
                            context.go('/requests');
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFEF4444),
                          side: const BorderSide(color: Color(0xFFEF4444)),
                        ),
                        child: const Text('إلغاء الطلب'),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildStatusBanner(RequestDto request) {
    final color = _getStatusColor(request.status);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(_getStatusIcon(request.status), color: color, size: 28),
          const SizedBox(width: 12),
          Text(
            request.statusName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
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

  IconData _getStatusIcon(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Icons.hourglass_top;
      case RequestStatus.approved:
        return Icons.check_circle;
      case RequestStatus.rejected:
        return Icons.cancel;
      case RequestStatus.cancelled:
        return Icons.block;
    }
  }
}
