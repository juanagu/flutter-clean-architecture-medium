import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:app/src/abstractions/failures/failure.dart';

part 'sign_in_failure.freezed.dart';

@freezed
abstract class SignInFailure extends Failure with _$SignInFailure {
  const factory SignInFailure.unauthorized() = Unauthorized;
  const factory SignInFailure.unexpectedError() = UnexpectedError;
}
