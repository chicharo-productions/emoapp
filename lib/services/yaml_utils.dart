import 'dart:convert';
import 'package:yaml/yaml.dart';

/// Utility class for YAML serialization/deserialization
class YamlUtils {
  /// Convert JSON map to YAML string
  static String toYaml(Map<String, dynamic> jsonMap) {
    return _mapToYaml(jsonMap);
  }

  /// Convert YAML string to JSON map
  static Map<String, dynamic> fromYaml(String yamlString) {
    try {
      final result =
          jsonDecode(jsonEncode(loadYaml(yamlString))) as Map<String, dynamic>;
      return result;
    } catch (_) {
      return {};
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
        } else if (value.isNotEmpty && value.first is Map<String, dynamic>) {
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

  /// Escape YAML values properly
  static String _escapeYamlValue(dynamic value) {
    if (value == null) return 'null';
    if (value is bool) return value ? 'true' : 'false';
    if (value is String) {
      if (value.isEmpty) return "''";
      if (value.contains('\n') ||
          value.contains(':') ||
          value.contains('#') ||
          value.startsWith(' ') ||
          value.startsWith('"')) {
        return '"${value.replaceAll('"', '\\"')}"';
      }
      return value;
    }
    if (value is num) return value.toString();
    return value.toString();
  }
}
