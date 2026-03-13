part of 'journal_entry_extended.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalEntryExtended _$JournalEntryExtendedFromJson(
        Map<String, dynamic> json) =>
    JournalEntryExtended(
      id: json['id'] as String,
      text: json['text'] as String,
      timeStamp: DateTime.parse(json['timeStamp'] as String),
      emotionalLevel: (json['emotionalLevel'] as num).toInt(),
      type: (json['type'] as num).toInt(),
      discussionId: json['discussionId'] as String,
      topicId: json['topicId'] as String? ?? '',
      calendarEntryId: json['calendarEntryId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
    );

Map<String, dynamic> _$JournalEntryExtendedToJson(
        JournalEntryExtended instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'title': instance.title,
      'tags': instance.tags,
      'timeStamp': instance.timeStamp.toIso8601String(),
      'emotionalLevel': instance.emotionalLevel,
      'type': instance.type,
      'calendarEntryId': instance.calendarEntryId,
      'discussionId': instance.discussionId,
      'topicId': instance.topicId,
    };
