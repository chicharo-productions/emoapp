import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
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
        // Native: write to file
        final file = await _getEntityFile(key);
        await file.writeAsString(jsonEncode(jsonData));
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
        // Native: delete file
        final file = await _getEntityFile(key);
        if (await file.exists()) {
          await file.delete();
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
            if (file is File && file.path.endsWith('.json')) {
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
}
