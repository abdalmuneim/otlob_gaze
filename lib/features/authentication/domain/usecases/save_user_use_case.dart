import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user.dart';
import 'package:otlob_gas/features/authentication/domain/repositories/auth_repository.dart';

class SaveUserUseCase {
  final AuthRepository repository;

  SaveUserUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required User user,
  }) async =>
      await repository.saveUser(user: user);
}
