import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yaml/yaml.dart';
import 'package:emoapp/model/json_serializable_interface.dart';
import 'package:get_it/get_it.dart';

/// Stupid database
/// Stores everything as files on native platforms (in-memory on web)
class Sdb<T extends JsonSerializableInterface<T>> {
  // In-memory storage for web and fallback
  static final Map<String, Map<String, dynamic>> _memoryStore = {};

  bool _opened = false;
  late String _storageKey;
  late String _entityType;

  Future<void> openBox() async {
    if (_opened) return;
    _entityType = T.toString();
    _storageKey = 'sdb_$_entityType';

    if (!kIsWeb) {
      // Create directory for native platforms
      try {
        await _getEntityDirectory();
      } catch (e) {
        print('Failed to create directory: $e');
      }
    } else {
      // Initialize memory store for web
      _memoryStore.putIfAbsent(_storageKey, () => {});
    }
    _opened = true;
  }

  Future<bool> boxExists() async => _opened;

  Future<Directory> _getEntityDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final entityDir = Directory('${appDir.path}/$_entityType');
    if (!await entityDir.exists()) {
      await entityDir.create(recursive: true);
    }
    return entityDir;
  }

  Future<File> _getEntityFile(String key) async {
    final dir = await _getEntityDirectory();
    return File('${dir.path}/$key.json');
  }

  Future<T?> get(String key) async {
    if (!_opened) {
      throw Exception('Database ${T.runtimeType.toString()} not opened');
    }

    try {
      Map<String, dynamic>? data;

      if (kIsWeb) {
        // Web: use in-memory storage
        data = _memoryStore[_storageKey]?[key];
      } else {
        // Native: read from file
        final file = await _getEntityFile(key);
        if (await file.exists()) {
          final content = await file.readAsString();
          data = jsonDecode(content) as Map<String, dynamic>;
        }
      }

      if (data == null) return null;

      return GetIt.instance.get<T>(
        instanceName: "${T.toString()}Json",
        param1: data,
        param2: null,
      );
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, T>> getAll() async {
    if (!_opened) {
      throw Exception('Database ${T.runtimeType.toString()} not opened');
    }

    try {
      final result = <String, T>{};

      if (kIsWeb) {
        // Web: use in-memory storage
        final store = _memoryStore[_storageKey] ?? {};
        for (final entry in store.entries) {
          try {
            result[entry.key] = GetIt.instance.get<T>(
              instanceName: "${T.toString()}Json",
              param1: entry.value,
              param2: null,
            );
          } catch (_) {}
        }
      } else {
        // Native: read from all files in directory
        final dir = await _getEntityDirectory();
        if (await dir.exists()) {
          final files = dir.listSync();
          for (final file in files) {
            if (file is File && file.path.endsWith('.json')) {
              try {
                final content = await file.readAsString();
                final data = jsonDecode(content) as Map<String, dynamic>;
                final key = file.path.split('/').last.replaceAll('.json', '');
                result[key] = GetIt.instance.get<T>(
                  instanceName: "${T.toString()}Json",
                  param1: data,
                  param2: null,
                );
              } catch (_) {}
            }
          }
        }
      }

      return result;
    } catch (_) {
      return {};
    }
  }

  Future<void> put(String key, T entity) async {
    if (!_opened) {
      throw Exception('Database ${T.runtimeType.toString()} not opened');
    }

    try {
      final jsonData = entity.toJson();

      if (kIsWeb) {
        // Web: use in-memory storage
        _memoryStore[_storageKey]?[key] = jsonData;
      } else {
        // Native: write to both JSON and YAML files
        final file = await _getEntityFile(key);
        await file.writeAsString(jsonEncode(jsonData));

        // Also write YAML file
        final dir = await _getEntityDirectory();
        final yamlFile = File('${dir.path}/$key.yaml');
        await yamlFile.writeAsString(_mapToYaml(jsonData));
      }
    } catch (_) {}
  }

  Future<void> delete(String key) async {
    if (!_opened) {
      throw Exception('Database ${T.runtimeType.toString()} not opened');
    }

    try {
      if (kIsWeb) {
        // Web: use in-memory storage
        _memoryStore[_storageKey]?.remove(key);
      } else {
        // Native: delete both JSON and YAML files
        final file = await _getEntityFile(key);
        if (await file.exists()) {
          await file.delete();
        }

        final dir = await _getEntityDirectory();
        final yamlFile = File('${dir.path}/$key.yaml');
        if (await yamlFile.exists()) {
          await yamlFile.delete();
        }
      }
    } catch (_) {}
  }

  Future<int> deleteAll() async {
    if (!_opened) {
      throw Exception('Database ${T.runtimeType.toString()} not opened');
    }

    try {
      int count = 0;

      if (kIsWeb) {
        // Web: use in-memory storage
        count = _memoryStore[_storageKey]?.length ?? 0;
        _memoryStore[_storageKey]?.clear();
      } else {
        // Native: delete all files in directory
        final dir = await _getEntityDirectory();
        if (await dir.exists()) {
          final files = dir.listSync();
          for (final file in files) {
            if (file is File &&
                (file.path.endsWith('.json') || file.path.endsWith('.yaml'))) {
              await file.delete();
              count++;
            }
          }
        }
      }

      return count;
    } catch (_) {
      return 0;
    }
  }

  /// Export a single entity to YAML string
  Future<String> getAsYaml(String key) async {
    try {
      final entity = await get(key);
      if (entity == null) return '';
      return _mapToYaml(entity.toJson());
    } catch (_) {
      return '';
    }
  }

  /// Export all entities to YAML string
  Future<String> getAllAsYaml() async {
    try {
      final allEntities = await getAll();
      final yamlMap = <String, dynamic>{};

      for (final entry in allEntities.entries) {
        yamlMap[entry.key] = entry.value.toJson();
      }

      return _mapToYaml(yamlMap);
    } catch (_) {
      return '';
    }
  }

  /// Import entity from YAML string
  Future<T?> fromYaml(String yamlString) async {
    try {
      final jsonData =
          jsonDecode(jsonEncode(loadYaml(yamlString))) as Map<String, dynamic>;
      return GetIt.instance.get<T>(
        instanceName: "${T.toString()}Json",
        param1: jsonData,
        param2: null,
      );
    } catch (_) {
      return null;
    }
  }

  /// Export entity to YAML file
  Future<void> exportToYamlFile(String key, String filePath) async {
    try {
      final entity = await get(key);
      if (entity == null) return;

      final file = File(filePath);
      final yamlString = _mapToYaml(entity.toJson());
      await file.writeAsString(yamlString);
    } catch (_) {}
  }

  /// Import entity from YAML file
  Future<T?> importFromYamlFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;

      final content = await file.readAsString();
      return await fromYaml(content);
    } catch (_) {
      return null;
    }
  }

  /// Helper method to convert a map to YAML string
  static String _mapToYaml(Map<String, dynamic> map,
      [String indent = '', bool isRoot = true]) {
    final buffer = StringBuffer();
    final entries = map.entries.toList();

    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final key = entry.key;
      final value = entry.value;

      buffer.write('$indent$key: ');

      if (value is Map<String, dynamic>) {
        buffer.write('\n');
        buffer.write(_mapToYaml(value, '$indent  ', false));
      } else if (value is List) {
        if (value.isEmpty) {
          buffer.write('[]');
        } else if (value.first is Map<String, dynamic>) {
          buffer.write('\n');
          for (int j = 0; j < value.length; j++) {
            final item = value[j];
            buffer.write('$indent  - ');
            if (item is Map<String, dynamic>) {
              final mapEntries = item.entries.toList();
              for (int k = 0; k < mapEntries.length; k++) {
                final mapEntry = mapEntries[k];
                buffer.write('${mapEntry.key}: ');
                if (mapEntry.value is DateTime) {
                  buffer.write((mapEntry.value as DateTime).toIso8601String());
                } else {
                  buffer.write(_escapeYamlValue(mapEntry.value));
                }
                if (k < mapEntries.length - 1) {
                  buffer.write('\n$indent    ');
                }
              }
            } else {
              buffer.write(_escapeYamlValue(item));
            }
            if (j < value.length - 1) {
              buffer.write('\n');
            }
          }
        } else {
          buffer.write('[${value.map(_escapeYamlValue).join(', ')}]');
        }
      } else if (value is DateTime) {
        buffer.write(value.toIso8601String());
      } else {
        buffer.write(_escapeYamlValue(value));
      }

      if (i < entries.length - 1) {
        buffer.write('\n');
      }
    }

    return buffer.toString();
  }

  /// Escape YAML values
  static String _escapeYamlValue(dynamic value) {
    if (value == null) return 'null';
    if (value is String) {
      if (value.isEmpty) return "''";
      if (value.contains('\n') ||
          value.contains(':') ||
          value.contains('#') ||
          value.startsWith(' ')) {
        return '"${value.replaceAll('"', '\\"')}"';
      }
      return value;
    }
    return value.toString();
  }
}
