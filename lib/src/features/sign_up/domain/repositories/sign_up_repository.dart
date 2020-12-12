import 'package:app/src/features/sign_up/domain/failures/sign_up_failure.dart';
import 'package:dartz/dartz.dart';

abstract class SignUpRepository {
  Future<Either<SignUpFailure, bool>> signUp(String email, String password);
}
