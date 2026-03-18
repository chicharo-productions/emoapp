import 'package:json_annotation/json_annotation.dart';

part 'reference.g.dart';

/// Represents a reference from one idea to another
@JsonSerializable()
class Reference {
  Reference({
    required this.id,
    required this.text,
    required this.ideaUuid,
  });

  /// Unique identifier for this reference
  String id;

  /// Display text for this reference
  String text;

  /// UUID of the idea being referenced
  String ideaUuid;

  factory Reference.fromJson(Map<String, dynamic> json) {
    return _$ReferenceFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ReferenceToJson(this);
}
