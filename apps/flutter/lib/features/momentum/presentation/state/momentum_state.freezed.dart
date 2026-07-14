// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'momentum_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MomentumState {

 AppPreferences get preferences; List<MomentumTask> get tasks; bool get isLoading; AppOperation? get activeOperation; AppOperation? get failedOperation; AppError? get error; String get searchQuery; TaskStatusFilter get statusFilter; TaskCategory? get categoryFilter; TaskPriority? get priorityFilter; int get successSerial;
/// Create a copy of MomentumState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MomentumStateCopyWith<MomentumState> get copyWith => _$MomentumStateCopyWithImpl<MomentumState>(this as MomentumState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MomentumState&&(identical(other.preferences, preferences) || other.preferences == preferences)&&const DeepCollectionEquality().equals(other.tasks, tasks)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.activeOperation, activeOperation) || other.activeOperation == activeOperation)&&(identical(other.failedOperation, failedOperation) || other.failedOperation == failedOperation)&&(identical(other.error, error) || other.error == error)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&(identical(other.categoryFilter, categoryFilter) || other.categoryFilter == categoryFilter)&&(identical(other.priorityFilter, priorityFilter) || other.priorityFilter == priorityFilter)&&(identical(other.successSerial, successSerial) || other.successSerial == successSerial));
}


@override
int get hashCode => Object.hash(runtimeType,preferences,const DeepCollectionEquality().hash(tasks),isLoading,activeOperation,failedOperation,error,searchQuery,statusFilter,categoryFilter,priorityFilter,successSerial);

@override
String toString() {
  return 'MomentumState(preferences: $preferences, tasks: $tasks, isLoading: $isLoading, activeOperation: $activeOperation, failedOperation: $failedOperation, error: $error, searchQuery: $searchQuery, statusFilter: $statusFilter, categoryFilter: $categoryFilter, priorityFilter: $priorityFilter, successSerial: $successSerial)';
}


}

/// @nodoc
abstract mixin class $MomentumStateCopyWith<$Res>  {
  factory $MomentumStateCopyWith(MomentumState value, $Res Function(MomentumState) _then) = _$MomentumStateCopyWithImpl;
@useResult
$Res call({
 AppPreferences preferences, List<MomentumTask> tasks, bool isLoading, AppOperation? activeOperation, AppOperation? failedOperation, AppError? error, String searchQuery, TaskStatusFilter statusFilter, TaskCategory? categoryFilter, TaskPriority? priorityFilter, int successSerial
});


$AppPreferencesCopyWith<$Res> get preferences;$AppErrorCopyWith<$Res>? get error;

}
/// @nodoc
class _$MomentumStateCopyWithImpl<$Res>
    implements $MomentumStateCopyWith<$Res> {
  _$MomentumStateCopyWithImpl(this._self, this._then);

  final MomentumState _self;
  final $Res Function(MomentumState) _then;

/// Create a copy of MomentumState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? preferences = null,Object? tasks = null,Object? isLoading = null,Object? activeOperation = freezed,Object? failedOperation = freezed,Object? error = freezed,Object? searchQuery = null,Object? statusFilter = null,Object? categoryFilter = freezed,Object? priorityFilter = freezed,Object? successSerial = null,}) {
  return _then(_self.copyWith(
preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as AppPreferences,tasks: null == tasks ? _self.tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<MomentumTask>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,activeOperation: freezed == activeOperation ? _self.activeOperation : activeOperation // ignore: cast_nullable_to_non_nullable
as AppOperation?,failedOperation: freezed == failedOperation ? _self.failedOperation : failedOperation // ignore: cast_nullable_to_non_nullable
as AppOperation?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppError?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,statusFilter: null == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as TaskStatusFilter,categoryFilter: freezed == categoryFilter ? _self.categoryFilter : categoryFilter // ignore: cast_nullable_to_non_nullable
as TaskCategory?,priorityFilter: freezed == priorityFilter ? _self.priorityFilter : priorityFilter // ignore: cast_nullable_to_non_nullable
as TaskPriority?,successSerial: null == successSerial ? _self.successSerial : successSerial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of MomentumState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppPreferencesCopyWith<$Res> get preferences {
  
  return $AppPreferencesCopyWith<$Res>(_self.preferences, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}/// Create a copy of MomentumState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppErrorCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $AppErrorCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// Adds pattern-matching-related methods to [MomentumState].
extension MomentumStatePatterns on MomentumState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MomentumState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MomentumState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MomentumState value)  $default,){
final _that = this;
switch (_that) {
case _MomentumState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MomentumState value)?  $default,){
final _that = this;
switch (_that) {
case _MomentumState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppPreferences preferences,  List<MomentumTask> tasks,  bool isLoading,  AppOperation? activeOperation,  AppOperation? failedOperation,  AppError? error,  String searchQuery,  TaskStatusFilter statusFilter,  TaskCategory? categoryFilter,  TaskPriority? priorityFilter,  int successSerial)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MomentumState() when $default != null:
return $default(_that.preferences,_that.tasks,_that.isLoading,_that.activeOperation,_that.failedOperation,_that.error,_that.searchQuery,_that.statusFilter,_that.categoryFilter,_that.priorityFilter,_that.successSerial);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppPreferences preferences,  List<MomentumTask> tasks,  bool isLoading,  AppOperation? activeOperation,  AppOperation? failedOperation,  AppError? error,  String searchQuery,  TaskStatusFilter statusFilter,  TaskCategory? categoryFilter,  TaskPriority? priorityFilter,  int successSerial)  $default,) {final _that = this;
switch (_that) {
case _MomentumState():
return $default(_that.preferences,_that.tasks,_that.isLoading,_that.activeOperation,_that.failedOperation,_that.error,_that.searchQuery,_that.statusFilter,_that.categoryFilter,_that.priorityFilter,_that.successSerial);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppPreferences preferences,  List<MomentumTask> tasks,  bool isLoading,  AppOperation? activeOperation,  AppOperation? failedOperation,  AppError? error,  String searchQuery,  TaskStatusFilter statusFilter,  TaskCategory? categoryFilter,  TaskPriority? priorityFilter,  int successSerial)?  $default,) {final _that = this;
switch (_that) {
case _MomentumState() when $default != null:
return $default(_that.preferences,_that.tasks,_that.isLoading,_that.activeOperation,_that.failedOperation,_that.error,_that.searchQuery,_that.statusFilter,_that.categoryFilter,_that.priorityFilter,_that.successSerial);case _:
  return null;

}
}

}

/// @nodoc


class _MomentumState extends MomentumState {
  const _MomentumState({required this.preferences, final  List<MomentumTask> tasks = const <MomentumTask>[], this.isLoading = true, this.activeOperation, this.failedOperation, this.error, this.searchQuery = '', this.statusFilter = TaskStatusFilter.all, this.categoryFilter, this.priorityFilter, this.successSerial = 0}): _tasks = tasks,super._();
  

@override final  AppPreferences preferences;
 final  List<MomentumTask> _tasks;
@override@JsonKey() List<MomentumTask> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

@override@JsonKey() final  bool isLoading;
@override final  AppOperation? activeOperation;
@override final  AppOperation? failedOperation;
@override final  AppError? error;
@override@JsonKey() final  String searchQuery;
@override@JsonKey() final  TaskStatusFilter statusFilter;
@override final  TaskCategory? categoryFilter;
@override final  TaskPriority? priorityFilter;
@override@JsonKey() final  int successSerial;

/// Create a copy of MomentumState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MomentumStateCopyWith<_MomentumState> get copyWith => __$MomentumStateCopyWithImpl<_MomentumState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MomentumState&&(identical(other.preferences, preferences) || other.preferences == preferences)&&const DeepCollectionEquality().equals(other._tasks, _tasks)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.activeOperation, activeOperation) || other.activeOperation == activeOperation)&&(identical(other.failedOperation, failedOperation) || other.failedOperation == failedOperation)&&(identical(other.error, error) || other.error == error)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.statusFilter, statusFilter) || other.statusFilter == statusFilter)&&(identical(other.categoryFilter, categoryFilter) || other.categoryFilter == categoryFilter)&&(identical(other.priorityFilter, priorityFilter) || other.priorityFilter == priorityFilter)&&(identical(other.successSerial, successSerial) || other.successSerial == successSerial));
}


@override
int get hashCode => Object.hash(runtimeType,preferences,const DeepCollectionEquality().hash(_tasks),isLoading,activeOperation,failedOperation,error,searchQuery,statusFilter,categoryFilter,priorityFilter,successSerial);

@override
String toString() {
  return 'MomentumState(preferences: $preferences, tasks: $tasks, isLoading: $isLoading, activeOperation: $activeOperation, failedOperation: $failedOperation, error: $error, searchQuery: $searchQuery, statusFilter: $statusFilter, categoryFilter: $categoryFilter, priorityFilter: $priorityFilter, successSerial: $successSerial)';
}


}

/// @nodoc
abstract mixin class _$MomentumStateCopyWith<$Res> implements $MomentumStateCopyWith<$Res> {
  factory _$MomentumStateCopyWith(_MomentumState value, $Res Function(_MomentumState) _then) = __$MomentumStateCopyWithImpl;
@override @useResult
$Res call({
 AppPreferences preferences, List<MomentumTask> tasks, bool isLoading, AppOperation? activeOperation, AppOperation? failedOperation, AppError? error, String searchQuery, TaskStatusFilter statusFilter, TaskCategory? categoryFilter, TaskPriority? priorityFilter, int successSerial
});


@override $AppPreferencesCopyWith<$Res> get preferences;@override $AppErrorCopyWith<$Res>? get error;

}
/// @nodoc
class __$MomentumStateCopyWithImpl<$Res>
    implements _$MomentumStateCopyWith<$Res> {
  __$MomentumStateCopyWithImpl(this._self, this._then);

  final _MomentumState _self;
  final $Res Function(_MomentumState) _then;

/// Create a copy of MomentumState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? preferences = null,Object? tasks = null,Object? isLoading = null,Object? activeOperation = freezed,Object? failedOperation = freezed,Object? error = freezed,Object? searchQuery = null,Object? statusFilter = null,Object? categoryFilter = freezed,Object? priorityFilter = freezed,Object? successSerial = null,}) {
  return _then(_MomentumState(
preferences: null == preferences ? _self.preferences : preferences // ignore: cast_nullable_to_non_nullable
as AppPreferences,tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<MomentumTask>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,activeOperation: freezed == activeOperation ? _self.activeOperation : activeOperation // ignore: cast_nullable_to_non_nullable
as AppOperation?,failedOperation: freezed == failedOperation ? _self.failedOperation : failedOperation // ignore: cast_nullable_to_non_nullable
as AppOperation?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppError?,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,statusFilter: null == statusFilter ? _self.statusFilter : statusFilter // ignore: cast_nullable_to_non_nullable
as TaskStatusFilter,categoryFilter: freezed == categoryFilter ? _self.categoryFilter : categoryFilter // ignore: cast_nullable_to_non_nullable
as TaskCategory?,priorityFilter: freezed == priorityFilter ? _self.priorityFilter : priorityFilter // ignore: cast_nullable_to_non_nullable
as TaskPriority?,successSerial: null == successSerial ? _self.successSerial : successSerial // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of MomentumState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppPreferencesCopyWith<$Res> get preferences {
  
  return $AppPreferencesCopyWith<$Res>(_self.preferences, (value) {
    return _then(_self.copyWith(preferences: value));
  });
}/// Create a copy of MomentumState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppErrorCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $AppErrorCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

// dart format on
