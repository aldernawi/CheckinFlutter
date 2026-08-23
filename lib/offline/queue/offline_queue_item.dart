enum OfflineQueueStatus { pending, syncing, synced, failed }

class OfflineQueueItem {
  OfflineQueueItem({
    required this.id,
    required this.feature,
    required this.operation,
    required this.payload,
    required this.createdAt,
    required this.status,
    this.retryCount = 0,
    this.nextRetryAt,
    this.dedupeKey,
  });

  final String id;
  final String feature;
  final String operation;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final OfflineQueueStatus status;
  final int retryCount;
  final DateTime? nextRetryAt;
  final String? dedupeKey;

  OfflineQueueItem copyWith({
    OfflineQueueStatus? status,
    int? retryCount,
    DateTime? nextRetryAt,
  }) {
    return OfflineQueueItem(
      id: id,
      feature: feature,
      operation: operation,
      payload: payload,
      createdAt: createdAt,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      dedupeKey: dedupeKey,
    );
  }
}
