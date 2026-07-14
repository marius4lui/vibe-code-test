// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'momentum_task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MomentumTask {

 TaskId get id; TaskTitle get title; String? get description; TaskCategory get category; TaskPriority get priority; DateTime get scheduledDate; Duration? get scheduledTime; DateTime? get completedAt;
/// Create a copy of MomentumTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MomentumTaskCopyWith<MomentumTask> get copyWith => _$MomentumTaskCopyWithImpl<MomentumTask>(this as MomentumTask, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MomentumTask&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,priority,scheduledDate,scheduledTime,completedAt);

@override
String toString() {
  return 'MomentumTask(id: $id, title: $title, description: $description, category: $category, priority: $priority, scheduledDate: $scheduledDate, scheduledTime: $scheduledTime, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $MomentumTaskCopyWith<$Res>  {
  factory $MomentumTaskCopyWith(MomentumTask value, $Res Function(MomentumTask) _then) = _$MomentumTaskCopyWithImpl;
@useResult
$Res call({
 TaskId id, TaskTitle title, String? description, TaskCategory category, TaskPriority priority, DateTime scheduledDate, Duration? scheduledTime, DateTime? completedAt
});




}
/// @nodoc
class _$MomentumTaskCopyWithImpl<$Res>
    implements $MomentumTaskCopyWith<$Res> {
  _$MomentumTaskCopyWithImpl(this._self, this._then);

  final MomentumTask _self;
  final $Res Function(MomentumTask) _then;

/// Create a copy of MomentumTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? category = null,Object? priority = null,Object? scheduledDate = null,Object? scheduledTime = freezed,Object? completedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as TaskId,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as TaskTitle,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskCategory,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,scheduledDate: null == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as DateTime,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as Duration?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MomentumTask].
extension MomentumTaskPatterns on MomentumTask {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MomentumTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MomentumTask() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MomentumTask value)  $default,){
final _that = this;
switch (_that) {
case _MomentumTask():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MomentumTask value)?  $default,){
final _that = this;
switch (_that) {
case _MomentumTask() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskId id,  TaskTitle title,  String? description,  TaskCategory category,  TaskPriority priority,  DateTime scheduledDate,  Duration? scheduledTime,  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MomentumTask() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.category,_that.priority,_that.scheduledDate,_that.scheduledTime,_that.completedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskId id,  TaskTitle title,  String? description,  TaskCategory category,  TaskPriority priority,  DateTime scheduledDate,  Duration? scheduledTime,  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _MomentumTask():
return $default(_that.id,_that.title,_that.description,_that.category,_that.priority,_that.scheduledDate,_that.scheduledTime,_that.completedAt);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskId id,  TaskTitle title,  String? description,  TaskCategory category,  TaskPriority priority,  DateTime scheduledDate,  Duration? scheduledTime,  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _MomentumTask() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.category,_that.priority,_that.scheduledDate,_that.scheduledTime,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc


class _MomentumTask extends MomentumTask {
  const _MomentumTask({required this.id, required this.title, this.description, required this.category, required this.priority, required this.scheduledDate, this.scheduledTime, this.completedAt}): super._();
  

@override final  TaskId id;
@override final  TaskTitle title;
@override final  String? description;
@override final  TaskCategory category;
@override final  TaskPriority priority;
@override final  DateTime scheduledDate;
@override final  Duration? scheduledTime;
@override final  DateTime? completedAt;

/// Create a copy of MomentumTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MomentumTaskCopyWith<_MomentumTask> get copyWith => __$MomentumTaskCopyWithImpl<_MomentumTask>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MomentumTask&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.scheduledTime, scheduledTime) || other.scheduledTime == scheduledTime)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,description,category,priority,scheduledDate,scheduledTime,completedAt);

@override
String toString() {
  return 'MomentumTask(id: $id, title: $title, description: $description, category: $category, priority: $priority, scheduledDate: $scheduledDate, scheduledTime: $scheduledTime, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$MomentumTaskCopyWith<$Res> implements $MomentumTaskCopyWith<$Res> {
  factory _$MomentumTaskCopyWith(_MomentumTask value, $Res Function(_MomentumTask) _then) = __$MomentumTaskCopyWithImpl;
@override @useResult
$Res call({
 TaskId id, TaskTitle title, String? description, TaskCategory category, TaskPriority priority, DateTime scheduledDate, Duration? scheduledTime, DateTime? completedAt
});




}
/// @nodoc
class __$MomentumTaskCopyWithImpl<$Res>
    implements _$MomentumTaskCopyWith<$Res> {
  __$MomentumTaskCopyWithImpl(this._self, this._then);

  final _MomentumTask _self;
  final $Res Function(_MomentumTask) _then;

/// Create a copy of MomentumTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? category = null,Object? priority = null,Object? scheduledDate = null,Object? scheduledTime = freezed,Object? completedAt = freezed,}) {
  return _then(_MomentumTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as TaskId,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as TaskTitle,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TaskCategory,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,scheduledDate: null == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as DateTime,scheduledTime: freezed == scheduledTime ? _self.scheduledTime : scheduledTime // ignore: cast_nullable_to_non_nullable
as Duration?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
