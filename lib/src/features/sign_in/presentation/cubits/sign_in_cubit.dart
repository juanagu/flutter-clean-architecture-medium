import 'package:app/src/features/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:app/src/features/sign_in/presentation/cubits/sign_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

export 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final SignInRepository _signInRepository;

  SignInCubit({
    @required SignInRepository signInRepository,
  })  : _signInRepository = signInRepository,
        super(SignInState.initial());

  Future<void> signIn(String email, String password) async {
    emit(SignInState.authenticating());
    var either = await _signInRepository.signIn(email, password);
    either.fold(
      (error) => error.when(
        unauthorized: () => emit(SignInState.unauthorized()),
        unexpectedError: () => emit(SignInState.unexpectedError()),
      ),
      (authorized) => emit(SignInState.authorized()),
    );
  }
}
