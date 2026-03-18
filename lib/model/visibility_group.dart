import 'package:emoapp/model/entity_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'visibility_group.g.dart';

/// Represents a visibility group for sharing ideas with other users
@JsonSerializable()
class VisibilityGroup extends EntityBase<VisibilityGroup> {
  VisibilityGroup({
    required super.id,
    required this.name,
    this.description = '',
  });

  /// Name of the visibility group
  String name;

  /// Optional description of the group
  String description;

  @override
  factory VisibilityGroup.fromJson(Map<String, dynamic> json) {
    return _$VisibilityGroupFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$VisibilityGroupToJson(this);

  @override
  VisibilityGroup fromJson2(Map<String, dynamic> json) {
    return _$VisibilityGroupFromJson(json);
  }

  factory VisibilityGroup.empty() {
    return VisibilityGroup(
      id: EntityBase.generateId(),
      name: 'Default',
      description: '',
    );
  }
}
