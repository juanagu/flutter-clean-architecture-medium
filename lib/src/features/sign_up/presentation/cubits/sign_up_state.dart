import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

@freezed
abstract class SignUpState with _$SignUpState {
  const factory SignUpState.initial() = Initial;

  const factory SignUpState.creating() = Creating;

  const factory SignUpState.registered() = Registered;

  const factory SignUpState.emailAlreadyInUse() = EmailAlreadyInUse;

  const factory SignUpState.unexpectedError() = UnexpectedError;
}
