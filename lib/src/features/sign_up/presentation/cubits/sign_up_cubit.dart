import 'package:app/src/features/sign_up/domain/failures/sign_up_failure.dart'
    as failures;
import 'package:app/src/features/sign_up/domain/repositories/sign_up_repository.dart';
import 'package:app/src/features/sign_up/presentation/cubits/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({required this._signUpRepository}) : super(const SignUpInitial());

  final SignUpRepository _signUpRepository;

  Future<void> signUp(String email, String password) async {
    emit(const SignUpCreating());
    final result = await _signUpRepository.signUp(email, password);
    emit(result.fold(_stateFromFailure, (_) => const SignUpRegistered()));
  }

  SignUpState _stateFromFailure(failures.SignUpFailure failure) {
    return switch (failure) {
      failures.SignUpEmailAlreadyInUse() => const SignUpEmailAlreadyInUse(),
      failures.SignUpWeakPassword() => const SignUpWeakPassword(),
      failures.SignUpUnexpectedError() => const SignUpUnexpectedError(),
    };
  }
}
