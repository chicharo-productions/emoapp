import 'package:emoapp/model/entity_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'emotion.g.dart';

/// Represents an emotion with emoji, cluster name, and value
@JsonSerializable()
class Emotion extends EntityBase<Emotion> {
  Emotion({
    required super.id,
    required this.emoji,
    required this.name,
    required this.clusterGroup,
    required this.value,
    this.description = '',
  });

  /// Unicode emoji representation of the emotion
  String emoji;

  /// Name of the emotion (e.g., "Angry", "Joyful")
  String name;

  /// Cluster group/category this emotion belongs to
  /// Examples: "anger", "joy", "sadness", "fear", "disgust", etc.
  String clusterGroup;

  /// Intensity or value of the emotion (0-10)
  int value;

  /// Optional description of the emotion
  String description;

  @override
  factory Emotion.fromJson(Map<String, dynamic> json) {
    return _$EmotionFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$EmotionToJson(this);

  @override
  Emotion fromJson2(Map<String, dynamic> json) {
    return _$EmotionFromJson(json);
  }

  /// Creates an empty emotion for fallback display
  factory Emotion.empty() {
    return Emotion(
      id: '',
      emoji: '❓',
      name: 'Unknown Emotion',
      clusterGroup: 'unknown',
      value: 0,
      description: '',
    );
  }
}
