import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

/// Represents a user in the system (optional for now)
@JsonSerializable()
class User {
  User({
    required this.id,
    required this.username,
  });

  /// Unique identifier for the user
  String id;

  /// Username for the user
  String username;

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
