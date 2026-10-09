import 'package:app/src/features/sign_in/domain/failures/sign_in_failure.dart';
import 'package:dartz/dartz.dart';

abstract class SignInRepository {
  Future<Either<SignInFailure, Unit>> signIn(String email, String password);
}
