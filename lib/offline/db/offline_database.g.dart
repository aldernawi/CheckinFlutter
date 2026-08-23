// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_database.dart';

// ignore_for_file: type=lint
class $OfflineQueueEntriesTable extends OfflineQueueEntries
    with TableInfo<$OfflineQueueEntriesTable, OfflineQueueEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineQueueEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _featureMeta = const VerificationMeta(
    'feature',
  );
  @override
  late final GeneratedColumn<String> feature = GeneratedColumn<String>(
    'feature',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _nextRetryAtMeta = const VerificationMeta(
    'nextRetryAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextRetryAt = GeneratedColumn<DateTime>(
    'next_retry_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dedupeKeyMeta = const VerificationMeta(
    'dedupeKey',
  );
  @override
  late final GeneratedColumn<String> dedupeKey = GeneratedColumn<String>(
    'dedupe_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    feature,
    operation,
    payloadJson,
    createdAt,
    status,
    retryCount,
    nextRetryAt,
    dedupeKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_queue_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineQueueEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('feature')) {
      context.handle(
        _featureMeta,
        feature.isAcceptableOrUnknown(data['feature']!, _featureMeta),
      );
    } else if (isInserting) {
      context.missing(_featureMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('next_retry_at')) {
      context.handle(
        _nextRetryAtMeta,
        nextRetryAt.isAcceptableOrUnknown(
          data['next_retry_at']!,
          _nextRetryAtMeta,
        ),
      );
    }
    if (data.containsKey('dedupe_key')) {
      context.handle(
        _dedupeKeyMeta,
        dedupeKey.isAcceptableOrUnknown(data['dedupe_key']!, _dedupeKeyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineQueueEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineQueueEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      feature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      nextRetryAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_retry_at'],
      ),
      dedupeKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dedupe_key'],
      ),
    );
  }

  @override
  $OfflineQueueEntriesTable createAlias(String alias) {
    return $OfflineQueueEntriesTable(attachedDatabase, alias);
  }
}

class OfflineQueueEntry extends DataClass
    implements Insertable<OfflineQueueEntry> {
  final String id;
  final String feature;
  final String operation;
  final String payloadJson;
  final DateTime createdAt;
  final String status;
  final int retryCount;
  final DateTime? nextRetryAt;
  final String? dedupeKey;
  const OfflineQueueEntry({
    required this.id,
    required this.feature,
    required this.operation,
    required this.payloadJson,
    required this.createdAt,
    required this.status,
    required this.retryCount,
    this.nextRetryAt,
    this.dedupeKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['feature'] = Variable<String>(feature);
    map['operation'] = Variable<String>(operation);
    map['payload_json'] = Variable<String>(payloadJson);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || nextRetryAt != null) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt);
    }
    if (!nullToAbsent || dedupeKey != null) {
      map['dedupe_key'] = Variable<String>(dedupeKey);
    }
    return map;
  }

  OfflineQueueEntriesCompanion toCompanion(bool nullToAbsent) {
    return OfflineQueueEntriesCompanion(
      id: Value(id),
      feature: Value(feature),
      operation: Value(operation),
      payloadJson: Value(payloadJson),
      createdAt: Value(createdAt),
      status: Value(status),
      retryCount: Value(retryCount),
      nextRetryAt: nextRetryAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextRetryAt),
      dedupeKey: dedupeKey == null && nullToAbsent
          ? const Value.absent()
          : Value(dedupeKey),
    );
  }

  factory OfflineQueueEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineQueueEntry(
      id: serializer.fromJson<String>(json['id']),
      feature: serializer.fromJson<String>(json['feature']),
      operation: serializer.fromJson<String>(json['operation']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      nextRetryAt: serializer.fromJson<DateTime?>(json['nextRetryAt']),
      dedupeKey: serializer.fromJson<String?>(json['dedupeKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'feature': serializer.toJson<String>(feature),
      'operation': serializer.toJson<String>(operation),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'nextRetryAt': serializer.toJson<DateTime?>(nextRetryAt),
      'dedupeKey': serializer.toJson<String?>(dedupeKey),
    };
  }

  OfflineQueueEntry copyWith({
    String? id,
    String? feature,
    String? operation,
    String? payloadJson,
    DateTime? createdAt,
    String? status,
    int? retryCount,
    Value<DateTime?> nextRetryAt = const Value.absent(),
    Value<String?> dedupeKey = const Value.absent(),
  }) => OfflineQueueEntry(
    id: id ?? this.id,
    feature: feature ?? this.feature,
    operation: operation ?? this.operation,
    payloadJson: payloadJson ?? this.payloadJson,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    retryCount: retryCount ?? this.retryCount,
    nextRetryAt: nextRetryAt.present ? nextRetryAt.value : this.nextRetryAt,
    dedupeKey: dedupeKey.present ? dedupeKey.value : this.dedupeKey,
  );
  OfflineQueueEntry copyWithCompanion(OfflineQueueEntriesCompanion data) {
    return OfflineQueueEntry(
      id: data.id.present ? data.id.value : this.id,
      feature: data.feature.present ? data.feature.value : this.feature,
      operation: data.operation.present ? data.operation.value : this.operation,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      nextRetryAt: data.nextRetryAt.present
          ? data.nextRetryAt.value
          : this.nextRetryAt,
      dedupeKey: data.dedupeKey.present ? data.dedupeKey.value : this.dedupeKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineQueueEntry(')
          ..write('id: $id, ')
          ..write('feature: $feature, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('dedupeKey: $dedupeKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    feature,
    operation,
    payloadJson,
    createdAt,
    status,
    retryCount,
    nextRetryAt,
    dedupeKey,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineQueueEntry &&
          other.id == this.id &&
          other.feature == this.feature &&
          other.operation == this.operation &&
          other.payloadJson == this.payloadJson &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.nextRetryAt == this.nextRetryAt &&
          other.dedupeKey == this.dedupeKey);
}

class OfflineQueueEntriesCompanion extends UpdateCompanion<OfflineQueueEntry> {
  final Value<String> id;
  final Value<String> feature;
  final Value<String> operation;
  final Value<String> payloadJson;
  final Value<DateTime> createdAt;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<DateTime?> nextRetryAt;
  final Value<String?> dedupeKey;
  final Value<int> rowid;
  const OfflineQueueEntriesCompanion({
    this.id = const Value.absent(),
    this.feature = const Value.absent(),
    this.operation = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.dedupeKey = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfflineQueueEntriesCompanion.insert({
    required String id,
    required String feature,
    required String operation,
    required String payloadJson,
    required DateTime createdAt,
    required String status,
    this.retryCount = const Value.absent(),
    this.nextRetryAt = const Value.absent(),
    this.dedupeKey = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       feature = Value(feature),
       operation = Value(operation),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt),
       status = Value(status);
  static Insertable<OfflineQueueEntry> custom({
    Expression<String>? id,
    Expression<String>? feature,
    Expression<String>? operation,
    Expression<String>? payloadJson,
    Expression<DateTime>? createdAt,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<DateTime>? nextRetryAt,
    Expression<String>? dedupeKey,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (feature != null) 'feature': feature,
      if (operation != null) 'operation': operation,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (nextRetryAt != null) 'next_retry_at': nextRetryAt,
      if (dedupeKey != null) 'dedupe_key': dedupeKey,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfflineQueueEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? feature,
    Value<String>? operation,
    Value<String>? payloadJson,
    Value<DateTime>? createdAt,
    Value<String>? status,
    Value<int>? retryCount,
    Value<DateTime?>? nextRetryAt,
    Value<String?>? dedupeKey,
    Value<int>? rowid,
  }) {
    return OfflineQueueEntriesCompanion(
      id: id ?? this.id,
      feature: feature ?? this.feature,
      operation: operation ?? this.operation,
      payloadJson: payloadJson ?? this.payloadJson,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      nextRetryAt: nextRetryAt ?? this.nextRetryAt,
      dedupeKey: dedupeKey ?? this.dedupeKey,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (feature.present) {
      map['feature'] = Variable<String>(feature.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (nextRetryAt.present) {
      map['next_retry_at'] = Variable<DateTime>(nextRetryAt.value);
    }
    if (dedupeKey.present) {
      map['dedupe_key'] = Variable<String>(dedupeKey.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineQueueEntriesCompanion(')
          ..write('id: $id, ')
          ..write('feature: $feature, ')
          ..write('operation: $operation, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('nextRetryAt: $nextRetryAt, ')
          ..write('dedupeKey: $dedupeKey, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$OfflineDatabase extends GeneratedDatabase {
  _$OfflineDatabase(QueryExecutor e) : super(e);
  $OfflineDatabaseManager get managers => $OfflineDatabaseManager(this);
  late final $OfflineQueueEntriesTable offlineQueueEntries =
      $OfflineQueueEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [offlineQueueEntries];
}

typedef $$OfflineQueueEntriesTableCreateCompanionBuilder =
    OfflineQueueEntriesCompanion Function({
      required String id,
      required String feature,
      required String operation,
      required String payloadJson,
      required DateTime createdAt,
      required String status,
      Value<int> retryCount,
      Value<DateTime?> nextRetryAt,
      Value<String?> dedupeKey,
      Value<int> rowid,
    });
typedef $$OfflineQueueEntriesTableUpdateCompanionBuilder =
    OfflineQueueEntriesCompanion Function({
      Value<String> id,
      Value<String> feature,
      Value<String> operation,
      Value<String> payloadJson,
      Value<DateTime> createdAt,
      Value<String> status,
      Value<int> retryCount,
      Value<DateTime?> nextRetryAt,
      Value<String?> dedupeKey,
      Value<int> rowid,
    });

class $$OfflineQueueEntriesTableFilterComposer
    extends Composer<_$OfflineDatabase, $OfflineQueueEntriesTable> {
  $$OfflineQueueEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feature => $composableBuilder(
    column: $table.feature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dedupeKey => $composableBuilder(
    column: $table.dedupeKey,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfflineQueueEntriesTableOrderingComposer
    extends Composer<_$OfflineDatabase, $OfflineQueueEntriesTable> {
  $$OfflineQueueEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feature => $composableBuilder(
    column: $table.feature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dedupeKey => $composableBuilder(
    column: $table.dedupeKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfflineQueueEntriesTableAnnotationComposer
    extends Composer<_$OfflineDatabase, $OfflineQueueEntriesTable> {
  $$OfflineQueueEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get feature =>
      $composableBuilder(column: $table.feature, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextRetryAt => $composableBuilder(
    column: $table.nextRetryAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dedupeKey =>
      $composableBuilder(column: $table.dedupeKey, builder: (column) => column);
}

class $$OfflineQueueEntriesTableTableManager
    extends
        RootTableManager<
          _$OfflineDatabase,
          $OfflineQueueEntriesTable,
          OfflineQueueEntry,
          $$OfflineQueueEntriesTableFilterComposer,
          $$OfflineQueueEntriesTableOrderingComposer,
          $$OfflineQueueEntriesTableAnnotationComposer,
          $$OfflineQueueEntriesTableCreateCompanionBuilder,
          $$OfflineQueueEntriesTableUpdateCompanionBuilder,
          (
            OfflineQueueEntry,
            BaseReferences<
              _$OfflineDatabase,
              $OfflineQueueEntriesTable,
              OfflineQueueEntry
            >,
          ),
          OfflineQueueEntry,
          PrefetchHooks Function()
        > {
  $$OfflineQueueEntriesTableTableManager(
    _$OfflineDatabase db,
    $OfflineQueueEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineQueueEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineQueueEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OfflineQueueEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> feature = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<String?> dedupeKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfflineQueueEntriesCompanion(
                id: id,
                feature: feature,
                operation: operation,
                payloadJson: payloadJson,
                createdAt: createdAt,
                status: status,
                retryCount: retryCount,
                nextRetryAt: nextRetryAt,
                dedupeKey: dedupeKey,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String feature,
                required String operation,
                required String payloadJson,
                required DateTime createdAt,
                required String status,
                Value<int> retryCount = const Value.absent(),
                Value<DateTime?> nextRetryAt = const Value.absent(),
                Value<String?> dedupeKey = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfflineQueueEntriesCompanion.insert(
                id: id,
                feature: feature,
                operation: operation,
                payloadJson: payloadJson,
                createdAt: createdAt,
                status: status,
                retryCount: retryCount,
                nextRetryAt: nextRetryAt,
                dedupeKey: dedupeKey,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfflineQueueEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$OfflineDatabase,
      $OfflineQueueEntriesTable,
      OfflineQueueEntry,
      $$OfflineQueueEntriesTableFilterComposer,
      $$OfflineQueueEntriesTableOrderingComposer,
      $$OfflineQueueEntriesTableAnnotationComposer,
      $$OfflineQueueEntriesTableCreateCompanionBuilder,
      $$OfflineQueueEntriesTableUpdateCompanionBuilder,
      (
        OfflineQueueEntry,
        BaseReferences<
          _$OfflineDatabase,
          $OfflineQueueEntriesTable,
          OfflineQueueEntry
        >,
      ),
      OfflineQueueEntry,
      PrefetchHooks Function()
    >;

class $OfflineDatabaseManager {
  final _$OfflineDatabase _db;
  $OfflineDatabaseManager(this._db);
  $$OfflineQueueEntriesTableTableManager get offlineQueueEntries =>
      $$OfflineQueueEntriesTableTableManager(_db, _db.offlineQueueEntries);
}
