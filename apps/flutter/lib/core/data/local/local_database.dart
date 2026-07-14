import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_database.g.dart';

typedef JsonMap = Map<String, dynamic>;

abstract interface class ILocalDatabase {
  Future<JsonMap?> read({required String boxName, required String key});

  Future<List<JsonMap>> readAll({required String boxName});

  Future<void> write({required String boxName, required String key, required JsonMap value});

  Future<void> writeAll({required String boxName, required Map<String, JsonMap> values});

  Future<void> delete({required String boxName, required String key});

  Future<void> close();
}

final class HiveLocalDatabase implements ILocalDatabase {
  final Map<String, Box<Map<dynamic, dynamic>>> _boxes = <String, Box<Map<dynamic, dynamic>>>{};

  @override
  Future<JsonMap?> read({required String boxName, required String key}) async {
    final box = await _openBox(boxName);
    final value = box.get(key);
    return value == null ? null : _toJsonMap(value);
  }

  @override
  Future<List<JsonMap>> readAll({required String boxName}) async {
    final box = await _openBox(boxName);
    return box.values.map(_toJsonMap).toList(growable: false);
  }

  @override
  Future<void> write({required String boxName, required String key, required JsonMap value}) async {
    final box = await _openBox(boxName);
    await box.put(key, Map<dynamic, dynamic>.from(value));
  }

  @override
  Future<void> writeAll({required String boxName, required Map<String, JsonMap> values}) async {
    if (values.isEmpty) return;

    final box = await _openBox(boxName);
    final hiveValues = <String, Map<dynamic, dynamic>>{};
    for (final entry in values.entries) {
      hiveValues[entry.key] = Map<dynamic, dynamic>.from(entry.value);
    }
    await box.putAll(hiveValues);
  }

  @override
  Future<void> delete({required String boxName, required String key}) async {
    final box = await _openBox(boxName);
    await box.delete(key);
  }

  @override
  Future<void> close() async {
    final boxes = _boxes.values.toSet();
    _boxes.clear();
    await Future.wait<void>(boxes.map((box) => box.close()));
  }

  Future<Box<Map<dynamic, dynamic>>> _openBox(String boxName) async {
    final cached = _boxes[boxName];
    if (cached != null && cached.isOpen) return cached;

    final box = await Hive.openBox<Map<dynamic, dynamic>>(boxName);
    _boxes[boxName] = box;
    return box;
  }

  JsonMap _toJsonMap(Map<dynamic, dynamic> value) {
    final result = <String, dynamic>{};
    for (final entry in value.entries) {
      final key = entry.key;
      if (key is! String) {
        throw const FormatException('A local record contains a non-string key.');
      }
      result[key] = entry.value;
    }
    return result;
  }
}

@Riverpod(keepAlive: true)
Future<ILocalDatabase> localDatabase(Ref ref) async {
  await Hive.initFlutter('momentum');
  final database = HiveLocalDatabase();
  ref.onDispose(database.close);
  return database;
}
