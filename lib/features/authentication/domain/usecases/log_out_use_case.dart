import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/authentication/domain/repositories/auth_repository.dart';

class LogOutUseCase {
  final AuthRepository repository;

  LogOutUseCase(this.repository);

  Future<Either<Failure, Unit>> call() async {
    return await repository.logOut();
  }
}
