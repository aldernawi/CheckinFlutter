import 'dart:convert';
import 'dart:io';

import 'package:checkin_flutter/offline/queue/offline_queue_item.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'offline_database.g.dart';

class OfflineQueueEntries extends Table {
  TextColumn get id => text()();
  TextColumn get feature => text()();
  TextColumn get operation => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get status => text()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get nextRetryAt => dateTime().nullable()();
  TextColumn get dedupeKey => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [OfflineQueueEntries])
class OfflineDatabase extends _$OfflineDatabase {
  OfflineDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> enqueue(OfflineQueueItem item) async {
    await into(offlineQueueEntries).insert(
      OfflineQueueEntriesCompanion.insert(
        id: item.id,
        feature: item.feature,
        operation: item.operation,
        payloadJson: jsonEncode(item.payload),
        createdAt: item.createdAt,
        status: item.status.name,
        retryCount: Value(item.retryCount),
        nextRetryAt: Value(item.nextRetryAt),
        dedupeKey: Value(item.dedupeKey),
      ),
      mode: InsertMode.replace,
    );
  }

  Future<void> updateItem(OfflineQueueItem item) async {
    await (update(offlineQueueEntries)..where((t) => t.id.equals(item.id))).write(
      OfflineQueueEntriesCompanion(
        status: Value(item.status.name),
        retryCount: Value(item.retryCount),
        nextRetryAt: Value(item.nextRetryAt),
      ),
    );
  }

  Future<void> deleteItem(String id) async {
    await (delete(offlineQueueEntries)..where((t) => t.id.equals(id))).go();
  }

  Future<List<OfflineQueueItem>> pendingItems() async {
    final rows = await (select(offlineQueueEntries)
          ..where((t) => t.status.equals(OfflineQueueStatus.pending.name))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();

    return rows.map(_toItem).toList();
  }

  Future<int> pendingCount() async {
    final count = offlineQueueEntries.id.count();
    final query = selectOnly(offlineQueueEntries)
      ..addColumns([count])
      ..where(offlineQueueEntries.status.equals(OfflineQueueStatus.pending.name));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  OfflineQueueItem _toItem(OfflineQueueEntry row) {
    return OfflineQueueItem(
      id: row.id,
      feature: row.feature,
      operation: row.operation,
      payload: jsonDecode(row.payloadJson) as Map<String, dynamic>,
      createdAt: row.createdAt,
      status: OfflineQueueStatus.values.firstWhere(
        (e) => e.name == row.status,
        orElse: () => OfflineQueueStatus.pending,
      ),
      retryCount: row.retryCount,
      nextRetryAt: row.nextRetryAt,
      dedupeKey: row.dedupeKey,
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = p.join(dir.path, 'offline_queue.sqlite');
    return NativeDatabase.createInBackground(File(file));
  });
}
