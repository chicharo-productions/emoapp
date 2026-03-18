import 'package:emoapp/model/json_serializable_interface.dart';
import 'package:uuid/uuid.dart';

///represents the basic common inherited type for all flutter hive instances
abstract class EntityBase<T> extends JsonSerializableInterface<T> {
  /// instantiates the base class containing basic information
  /// inside of hive db
  EntityBase({required this.id});

  /// internal identification of a class (mainly a guid)
  String id;

  /// Generates a new UUID for the entity
  static String generateId() {
    return const Uuid().v4();
  }

  // Map<String, dynamic> toJson();
  // factory T.fromJson(Map<String, dynamic> json) => _$TFromJson(json);
}
