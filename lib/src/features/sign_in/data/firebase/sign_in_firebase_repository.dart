import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/features/sign_in/domain/failues/sign_in_failure.dart';
import 'package:app/src/features/sign_in/domain/repositories/sign_in_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class SignInFirebaseRepository implements SignInRepository {
  SignInFirebaseRepository({
    @required Logger logger,
  }) : _logger = logger;

  final Logger _logger;

  @override
  Future<Either<SignInFailure, bool>> signIn(
    String email,
    String password,
  ) async {
    try {
      var isAuthorized = await _signInWithEmailAndPassword(email, password);

      if (isAuthorized != null) {
        return right(true);
      }

      return left(const SignInFailure.unexpectedError());
    } catch (error, stackTrace) {
      if (error is FirebaseAuthException) {
        return left(const SignInFailure.unauthorized());
      } else {
        await _logger.recordError(error, stackTrace);
        return left(const SignInFailure.unexpectedError());
      }
    }
  }

  Future<UserCredential> _signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
