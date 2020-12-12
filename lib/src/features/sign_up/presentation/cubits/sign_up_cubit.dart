import 'package:app/src/features/sign_up/domain/repositories/sign_up_repository.dart';
import 'package:app/src/features/sign_up/presentation/cubits/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
export 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final SignUpRepository _signUpRepository;

  SignUpCubit({
    @required SignUpRepository signUpRepository,
  })  : _signUpRepository = signUpRepository,
        super(SignUpState.initial());

  Future<void> signUp(String email, String password) async {
    emit(SignUpState.creating());
    var either = await _signUpRepository.signUp(email, password);
    either.fold(
      (error) => error.when(
        emailAlreadyInUse: () => emit(SignUpState.emailAlreadyInUse()),
        unexpectedError: () => emit(SignUpState.unexpectedError()),
      ),
      (success) => emit(SignUpState.unexpectedError()),
    );
  }
}
