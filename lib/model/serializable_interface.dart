import 'dart:convert';
import 'package:yaml/yaml.dart';

/// Interface for serializable models with JSON and YAML support
abstract class SerializableInterface<TThisType> {
  /// Convert to JSON map
  Map<String, dynamic> toJson();

  /// Convert from JSON map
  TThisType fromJson2(Map<String, dynamic> json);

  /// Convert to YAML string
  String toYaml() {
    return _mapToYaml(toJson());
  }

  /// Convert from YAML string
  static Map<String, dynamic> fromYamlString(String yamlString) {
    final yamlData = loadYaml(yamlString) as Map<dynamic, dynamic>;
    final jsonData = jsonDecode(jsonEncode(yamlData)) as Map<String, dynamic>;
    return jsonData;
  }

  /// Helper method to convert a map to YAML string
  static String _mapToYaml(Map<dynamic, dynamic> map,
      [String indent = '', bool isFirst = true]) {
    final buffer = StringBuffer();

    map.forEach((key, value) {
      if (!isFirst) {
        buffer.write('\n');
      }
      isFirst = false;

      buffer.write('$indent$key: ');

      if (value is Map) {
        buffer.write('\n');
        buffer.write(_mapToYaml(value, '$indent  ', true));
      } else if (value is List) {
        if (value.isEmpty) {
          buffer.write('[]');
        } else if (value.first is Map) {
          buffer.write('\n');
          for (final item in value) {
            buffer.write('$indent  - ');
            if (item is Map) {
              final mapYaml = _mapToYaml(item, '$indent    ', true);
              buffer.write(mapYaml.substring('$indent    '.length));
              buffer.write('\n');
            } else {
              buffer.write(item);
              buffer.write('\n');
            }
          }
          buffer.write(indent);
        } else {
          buffer.write('[${value.join(', ')}]');
        }
      } else if (value is String) {
        // Escape strings if needed
        if (value.contains('\n') || value.contains(':')) {
          buffer.write("'${value.replaceAll("'", "''")}'");
        } else {
          buffer.write(value);
        }
      } else if (value is DateTime) {
        buffer.write(value.toIso8601String());
      } else {
        buffer.write(value);
      }
    });

    return buffer.toString();
  }
}
