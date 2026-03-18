// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visibility_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VisibilityGroup _$VisibilityGroupFromJson(Map<String, dynamic> json) =>
    VisibilityGroup(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$VisibilityGroupToJson(VisibilityGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
