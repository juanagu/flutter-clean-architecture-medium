import 'package:app/src/abstractions/utils/logger.dart';
import 'package:app/src/features/sign_up/domain/failures/sign_up_failure.dart';
import 'package:app/src/features/sign_up/domain/repositories/sign_up_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class SignUpFirebaseRepository implements SignUpRepository {
  SignUpFirebaseRepository({
    @required Logger logger,
  }) : _logger = logger;
  final Logger _logger;
  static const String firebaseCodeEmailAlreadyInUse = 'email-already-in-use';

  @override
  Future<Either<SignUpFailure, bool>> signUp(
    String email,
    String password,
  ) async {
    try {
      var userCredential = await _createUserWithEmailAndPassword(
        email,
        password,
      );

      if (userCredential != null) {
        return right(true);
      }

      return left(const SignUpFailure.unexpectedError());
    } catch (error, stackTrace) {
      if (error is FirebaseAuthException &&
          error.code == firebaseCodeEmailAlreadyInUse) {
        return left(const SignUpFailure.emailAlreadyInUse());
      } else {
        await _logger.recordError(error, stackTrace);
        return left(const SignUpFailure.unexpectedError());
      }
    }
  }

  Future<UserCredential> _createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
