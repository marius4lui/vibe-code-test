// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppError {

 Object get cause;
/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppErrorCopyWith<AppError> get copyWith => _$AppErrorCopyWithImpl<AppError>(this as AppError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppError&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'AppError(cause: $cause)';
}


}

/// @nodoc
abstract mixin class $AppErrorCopyWith<$Res>  {
  factory $AppErrorCopyWith(AppError value, $Res Function(AppError) _then) = _$AppErrorCopyWithImpl;
@useResult
$Res call({
 Object cause
});




}
/// @nodoc
class _$AppErrorCopyWithImpl<$Res>
    implements $AppErrorCopyWith<$Res> {
  _$AppErrorCopyWithImpl(this._self, this._then);

  final AppError _self;
  final $Res Function(AppError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? cause = null,}) {
  return _then(_self.copyWith(
cause: null == cause ? _self.cause : cause ,
  ));
}

}


/// Adds pattern-matching-related methods to [AppError].
extension AppErrorPatterns on AppError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StorageAppError value)?  storage,TResult Function( UnexpectedAppError value)?  unexpected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StorageAppError() when storage != null:
return storage(_that);case UnexpectedAppError() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StorageAppError value)  storage,required TResult Function( UnexpectedAppError value)  unexpected,}){
final _that = this;
switch (_that) {
case StorageAppError():
return storage(_that);case UnexpectedAppError():
return unexpected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StorageAppError value)?  storage,TResult? Function( UnexpectedAppError value)?  unexpected,}){
final _that = this;
switch (_that) {
case StorageAppError() when storage != null:
return storage(_that);case UnexpectedAppError() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Object cause)?  storage,TResult Function( Object cause)?  unexpected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StorageAppError() when storage != null:
return storage(_that.cause);case UnexpectedAppError() when unexpected != null:
return unexpected(_that.cause);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Object cause)  storage,required TResult Function( Object cause)  unexpected,}) {final _that = this;
switch (_that) {
case StorageAppError():
return storage(_that.cause);case UnexpectedAppError():
return unexpected(_that.cause);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Object cause)?  storage,TResult? Function( Object cause)?  unexpected,}) {final _that = this;
switch (_that) {
case StorageAppError() when storage != null:
return storage(_that.cause);case UnexpectedAppError() when unexpected != null:
return unexpected(_that.cause);case _:
  return null;

}
}

}

/// @nodoc


class StorageAppError implements AppError {
  const StorageAppError(this.cause);
  

@override final  Object cause;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageAppErrorCopyWith<StorageAppError> get copyWith => _$StorageAppErrorCopyWithImpl<StorageAppError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageAppError&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'AppError.storage(cause: $cause)';
}


}

/// @nodoc
abstract mixin class $StorageAppErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $StorageAppErrorCopyWith(StorageAppError value, $Res Function(StorageAppError) _then) = _$StorageAppErrorCopyWithImpl;
@override @useResult
$Res call({
 Object cause
});




}
/// @nodoc
class _$StorageAppErrorCopyWithImpl<$Res>
    implements $StorageAppErrorCopyWith<$Res> {
  _$StorageAppErrorCopyWithImpl(this._self, this._then);

  final StorageAppError _self;
  final $Res Function(StorageAppError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cause = null,}) {
  return _then(StorageAppError(
null == cause ? _self.cause : cause ,
  ));
}


}

/// @nodoc


class UnexpectedAppError implements AppError {
  const UnexpectedAppError(this.cause);
  

@override final  Object cause;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnexpectedAppErrorCopyWith<UnexpectedAppError> get copyWith => _$UnexpectedAppErrorCopyWithImpl<UnexpectedAppError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedAppError&&const DeepCollectionEquality().equals(other.cause, cause));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(cause));

@override
String toString() {
  return 'AppError.unexpected(cause: $cause)';
}


}

/// @nodoc
abstract mixin class $UnexpectedAppErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $UnexpectedAppErrorCopyWith(UnexpectedAppError value, $Res Function(UnexpectedAppError) _then) = _$UnexpectedAppErrorCopyWithImpl;
@override @useResult
$Res call({
 Object cause
});




}
/// @nodoc
class _$UnexpectedAppErrorCopyWithImpl<$Res>
    implements $UnexpectedAppErrorCopyWith<$Res> {
  _$UnexpectedAppErrorCopyWithImpl(this._self, this._then);

  final UnexpectedAppError _self;
  final $Res Function(UnexpectedAppError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? cause = null,}) {
  return _then(UnexpectedAppError(
null == cause ? _self.cause : cause ,
  ));
}


}

// dart format on
