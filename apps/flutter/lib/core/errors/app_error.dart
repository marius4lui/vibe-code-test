import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

@freezed
sealed class AppError with _$AppError {
  const factory AppError.storage(Object cause) = StorageAppError;

  const factory AppError.unexpected(Object cause) = UnexpectedAppError;
}
