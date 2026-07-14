// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => _TaskModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  category: json['category'] as String,
  priority: json['priority'] as String,
  scheduledDate: DateTime.parse(json['scheduledDate'] as String),
  scheduledTimeMicroseconds: (json['scheduledTimeMicroseconds'] as num?)?.toInt(),
  completedAt: json['completedAt'] == null ? null : DateTime.parse(json['completedAt'] as String),
);

Map<String, dynamic> _$TaskModelToJson(_TaskModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'category': instance.category,
  'priority': instance.priority,
  'scheduledDate': instance.scheduledDate.toIso8601String(),
  'scheduledTimeMicroseconds': instance.scheduledTimeMicroseconds,
  'completedAt': instance.completedAt?.toIso8601String(),
};
