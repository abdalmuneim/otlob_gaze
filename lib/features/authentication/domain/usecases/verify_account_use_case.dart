import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/authentication/domain/repositories/auth_repository.dart';

class VerifyAccountUseCase {
  final AuthRepository repository;

  VerifyAccountUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String mobile,
  }) {
    return repository.verifyAccount(mobile: mobile);
  }
}
