import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:app/src/abstractions/failures/failure.dart';

part 'auth_session_failure.freezed.dart';

@freezed
abstract class AuthSessionFailure extends Failure with _$AuthSessionFailure {
  const factory AuthSessionFailure.unauthorized() = Unauthorized;
  const factory AuthSessionFailure.unexpectedError() = UnexpectedError;
}
