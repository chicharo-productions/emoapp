import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  Tag({
    required this.name,
    this.color = '',
  });

  String name;
  String color;

  factory Tag.fromJson(Map<String, dynamic> json) {
    return _$TagFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TagToJson(this);
}
