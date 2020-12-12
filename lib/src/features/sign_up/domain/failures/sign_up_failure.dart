import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:app/src/abstractions/failures/failure.dart';

part 'sign_up_failure.freezed.dart';

@freezed
abstract class SignUpFailure extends Failure with _$SignUpFailure {
  const factory SignUpFailure.emailAlreadyInUse() = EmailAlreadyInUse;
  const factory SignUpFailure.unexpectedError() = UnexpectedError;
}
