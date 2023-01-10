import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/authentication/domain/repositories/auth_repository.dart';

class SignInUserUseCase {
  final AuthRepository repository;

  SignInUserUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String mobile,
    required String password,
  }) async {
    return await repository.signIn(mobile: mobile, password: password);
  }
}
