import 'package:hive_ce_flutter/hive_flutter.dart';

abstract class BaseHiveService {
  // Abstract property that subclasses must define
  String get boxName;

  // Get the box instance
  Box<dynamic> get box => Hive.box<dynamic>(boxName);

  // Common CRUD operations
  void put(String key, dynamic value) {
    box.put(key, value);
  }

  T? get<T>(String key) {
    return box.get(key) as T?;
  }

  void delete(String key) {
    box.delete(key);
  }

  void deleteAll(List<String> keys) {
    box.deleteAll(keys);
  }

  void clear() {
    box.clear();
  }

  bool containsKey(String key) {
    return box.containsKey(key);
  }

  // Common utility methods
  void putWithExpiry(String key, dynamic value, Duration duration) {
    final expiryTime = DateTime.now().toUtc().add(duration).toIso8601String();
    box
      ..put('${key}_expiry', expiryTime)
      ..put(key, value);
  }

  T? getWithExpiry<T>(String key) {
    final expiryTime = box.get('${key}_expiry') as String?;
    if (expiryTime == null) return null;

    final expiry = DateTime.parse(expiryTime);
    if (DateTime.now().toUtc().isAfter(expiry)) {
      delete(key);
      delete('${key}_expiry');
      return null;
    }

    return box.get(key) as T?;
  }

  // Method for persisting collections with mission/group context
  void putCollection(String prefix, String contextId, dynamic value) {
    box.put('$prefix-$contextId', value);
  }

  T? getCollection<T>(String prefix, String contextId) {
    return box.get('$prefix-$contextId') as T?;
  }

  void deleteCollection(String prefix, String contextId) {
    box.delete('$prefix-$contextId');
  }

  // Method for adding items to existing collections
  void addToCollection<T>(
    String prefix,
    String contextId,
    T item,
    T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic> Function(T) toJson,
  ) {
    final existing = getCollection<Map<String, dynamic>>(prefix, contextId);
    if (existing == null) return;

    final data = existing['data'] as List<dynamic>?;
    if (data == null) return;

    final modified = List<Map<String, dynamic>>.from(data)..add(toJson(item));

    putCollection(prefix, contextId, {...existing, 'data': modified});
  }
}
