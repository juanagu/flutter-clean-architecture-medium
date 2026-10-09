import 'package:app/src/features/sign_in/domain/failures/sign_in_failure.dart'
    as failures;
import 'package:app/src/features/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:app/src/features/sign_in/presentation/cubits/sign_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

export 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({required this._signInRepository}) : super(const SignInInitial());

  final SignInRepository _signInRepository;

  Future<void> signIn(String email, String password) async {
    emit(const SignInAuthenticating());
    final result = await _signInRepository.signIn(email, password);
    emit(result.fold(_stateFromFailure, (_) => const SignInAuthorized()));
  }

  SignInState _stateFromFailure(failures.SignInFailure failure) {
    return switch (failure) {
      failures.SignInUnauthorized() => const SignInUnauthorized(),
      failures.SignInUnexpectedError() => const SignInUnexpectedError(),
    };
  }
}
