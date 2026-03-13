import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()
class Todo {
  Todo({
    required this.id,
    required this.title,
    this.isDone = false,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String title;
  bool isDone;
  DateTime createdAt;
  DateTime updatedAt;

  factory Todo.fromJson(Map<String, dynamic> json) {
    return _$TodoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  factory Todo.create(String title) {
    return Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isDone: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
