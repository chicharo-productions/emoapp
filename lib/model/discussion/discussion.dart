import 'package:emoapp/model/entity_base.dart';
import 'package:emoapp/model/entity_base_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discussion.g.dart';

@JsonSerializable()
class Discussion extends EntityBase<Discussion> {
  Discussion({
    required super.id,
    required this.name,
    required this.imageKey,
    required this.description,
    List<EntityBaseType>? children1,
  }) : children1 = children1 ?? [];

  String name;
  String imageKey;
  String description;
  List<EntityBaseType> children1;

  @override
  factory Discussion.fromJson(Map<String, dynamic> json) {
    return _$DiscussionFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$DiscussionToJson(this);

  @override
  Discussion fromJson2(Map<String, dynamic> json) {
    return _$DiscussionFromJson(json);
  }
}
