import 'package:checkin_flutter/offline/db/offline_database.dart';
import 'package:checkin_flutter/offline/queue/offline_queue_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfflineQueueRepository {
  OfflineQueueRepository(this._db);

  final OfflineDatabase _db;

  Future<void> enqueue(OfflineQueueItem item) => _db.enqueue(item);

  Future<void> update(OfflineQueueItem item) => _db.updateItem(item);

  Future<void> delete(String id) => _db.deleteItem(id);

  Future<List<OfflineQueueItem>> pending() => _db.pendingItems();

  Future<int> pendingCount() => _db.pendingCount();
}

final offlineDatabaseProvider = Provider<OfflineDatabase>(
  (ref) => OfflineDatabase(),
);

final offlineQueueRepositoryProvider = Provider<OfflineQueueRepository>(
  (ref) => OfflineQueueRepository(ref.watch(offlineDatabaseProvider)),
);
