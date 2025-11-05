import 'dart:async';

import 'package:collection/collection.dart' as col;
import 'package:isar_community/isar.dart';

abstract class BaseLocalDBService<TRemote, TLocal> {
  BaseLocalDBService({required Isar prfDBInstance}) {
    _prfDBInstance = prfDBInstance;
  }

  late final Isar _prfDBInstance;

  // Access to the database instance
  Isar get dbInstance => _prfDBInstance;

  /// Convert remote model to local model
  TLocal remoteToLocal(TRemote remote);

  /// Get the Isar collection for this entity type
  IsarCollection<TLocal> get collection;

  StreamController<List<TLocal>>? _streamController;
  Stream<List<TLocal>> get stream {
    _streamController ??= StreamController<List<TLocal>>.broadcast();
    return _streamController!.stream;
  }

  Future<void> refreshStream() async {
    _streamController ??= StreamController<List<TLocal>>.broadcast();
    final entities = await list();
    _streamController!.add(entities);
  }

  Future<void> closeStream() async {
    await _streamController?.close();
    _streamController = null;
  }

  StreamController<TLocal?>? _itemStreamController;
  Stream<TLocal?> get itemStream {
    _itemStreamController ??= StreamController<TLocal?>.broadcast();
    return _itemStreamController!.stream;
  }

  Future<void> refreshItemStream(String itemKey) async {
    _itemStreamController ??= StreamController<TLocal?>.broadcast();
    final entity = await get(itemKey);
    _itemStreamController!.add(entity);
  }

  Future<void> closeItemStream() async {
    await _itemStreamController?.close();
    _itemStreamController = null;
  }

  Future<TLocal?> get(String key) async {
    throw UnimplementedError('get must be implemented in subclasses');
  }

  // Common database operations

  /// Persist a list of remote entities to local database
  Future<void> persistEntities(List<TRemote> remoteEntities) async {
    await dbInstance.writeTxn(() async {
      final localEntities = remoteEntities.map(remoteToLocal).toList();
      await collection.putAll(localEntities);
    });
  }

  /// Persist a single remote entity to local database
  Future<void> persistEntity(TRemote remoteEntity) async {
    await dbInstance.writeTxn(() async {
      final localEntity = remoteToLocal(remoteEntity);
      await collection.put(localEntity);
    });
  }

  /// Get all entities as a future
  Future<List<TLocal>> list() async {
    return collection.where().findAll();
  }

  /// Get entity by primary key (usually ulid) - Example implementation.
  /// You should override this in your subclass with the correct entity query.
  /// Example:
  /// ```dart
  /// @override
  /// Stream<MyLocalEntity?> getByKey(String key) {
  ///   return collection
  ///     .where()
  ///     .ulidEqualTo(key) // Replace with your actual field
  ///     .watch(fireImmediately: true)
  ///     .map((results) => results.isEmpty ? null : results.first);
  /// }
  /// ```
  // Stream<TLocal?> getByKey(String key) {
  //   throw UnimplementedError(
  //     'getByKey must be implemented in subclasses',
  //   );
  // }

  /// Get entity by primary key as a future - Example implementation.
  /// You should override this in your subclass with the correct entity query.
  /// Example:
  /// ```dart
  /// @override
  /// Future<MyLocalEntity?> getByKeyFuture(String key) async {
  ///  final results = await collection.where().ulidEqualTo(key).findAll();
  /// return results.isEmpty ? null : results.first;
  /// }
  /// ```
  // Future<TLocal?> getByKeyFuture(String key) async {
  //   throw UnimplementedError(
  //     'getByKeyFuture must be implemented in subclasses',
  //   );
  // }

  /// Delete entity by primary key - Example implementation.
  /// You should override this in your subclass with the correct entity query.
  /// Example:
  /// ```dart
  /// @override
  /// Future<void> deleteByKey(String key) async {
  ///   await dbInstance.writeTxn(() async {
  ///     await collection.where().ulidEqualTo(key).deleteFirst(); // Replace with your actual field
  ///   });
  /// }
  /// ```
  Future<void> deleteByKey(String key) async {
    throw UnimplementedError('deleteByKey must be implemented in subclasses');
  }

  /// Check if entity exists by key - Example implementation.
  /// You should override this in your subclass with the correct entity query.
  /// Example:
  /// ```dart
  /// @override
  /// Future<bool> exists(String key) async {
  ///   final count = await collection.where().ulidEqualTo(key).count(); // Replace with your actual field
  ///   return count > 0;
  /// }
  /// ```
  Future<bool> exists(String key) async {
    throw UnimplementedError(
      'exists must be implemented in subclasses with the correct entity query',
    );
  }

  /// Clear all entities of this type
  Future<void> clearAll() async {
    await dbInstance.writeTxn(() => collection.clear());
  }

  /// Get count of entities
  Future<int> count() async {
    return collection.count();
  }

  /// Build custom query - can be overridden for complex queries
  QueryBuilder<TLocal, TLocal, QWhere> buildQuery() {
    return collection.where();
  }

  /// Execute custom filter query
  Future<List<TLocal>> executeQuery(
    Query<List<TLocal>> Function(QueryBuilder<TLocal, TLocal, QWhere> q)
    queryFn,
  ) async {
    final query = queryFn(collection.where());
    return (await query.findAll()).first;
  }

  /// Execute custom filter query as stream
  Stream<List<TLocal>> executeQueryStream(
    Query<List<TLocal>> Function(QueryBuilder<TLocal, TLocal, QWhere>)
    queryBuilder,
  ) {
    final query = queryBuilder(collection.where());
    return query
        .watch(fireImmediately: true)
        .asBroadcastStream()
        .map((results) => results.isEmpty ? <TLocal>[] : results.first);
  }

  /// Group entities by a field and return as a stream.
  /// Example usage:
  ///   getGroupedBy&lt;DateTime&gt;((entity) => entity.publishedAt)
  Stream<Map<K, List<TLocal>>> getGroupedBy<K>(
    K Function(TLocal entity) groupByField,
  ) {
    return stream.map((entities) {
      return col.groupBy(entities, groupByField);
    });
  }
}
