import 'package:app/src/features/sign_up/domain/repositories/sign_up_repository.dart';
import 'package:app/src/features/sign_up/presentation/cubits/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
export 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit({
    @required SignUpRepository signUpRepository,
  })  : _signUpRepository = signUpRepository,
        super(const SignUpState.initial());
  final SignUpRepository _signUpRepository;

  Future<void> signUp(String email, String password) async {
    emit(const SignUpState.creating());
    var either = await _signUpRepository.signUp(email, password);
    either.fold(
      (error) => error.when(
        emailAlreadyInUse: () => emit(const SignUpState.emailAlreadyInUse()),
        unexpectedError: () => emit(const SignUpState.unexpectedError()),
      ),
      (success) => emit(const SignUpState.registered()),
    );
  }
}
