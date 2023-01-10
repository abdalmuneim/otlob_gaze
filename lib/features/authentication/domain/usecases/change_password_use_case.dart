import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/authentication/domain/repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String mobile,
    required String password,
    required String confirmPassword,
  }) async {
    return await repository.changePassword(
        mobile: mobile, password: password, confirmPassword: confirmPassword);
  }
}
