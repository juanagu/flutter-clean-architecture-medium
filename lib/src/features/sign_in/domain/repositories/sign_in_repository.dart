import 'package:app/src/features/sign_in/domain/failues/sign_in_failure.dart';
import 'package:dartz/dartz.dart';

abstract class SignInRepository {
  Future<Either<SignInFailure, bool>> signIn(String email, String password);
}
