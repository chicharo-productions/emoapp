// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Emotion _$EmotionFromJson(Map<String, dynamic> json) => Emotion(
      id: json['id'] as String,
      emoji: json['emoji'] as String,
      name: json['name'] as String,
      clusterGroup: json['clusterGroup'] as String,
      value: (json['value'] as num).toInt(),
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$EmotionToJson(Emotion instance) => <String, dynamic>{
      'id': instance.id,
      'emoji': instance.emoji,
      'name': instance.name,
      'clusterGroup': instance.clusterGroup,
      'value': instance.value,
      'description': instance.description,
    };
