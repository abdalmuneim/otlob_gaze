import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/home/domain/repositories/home_repository.dart';

class ChangeUserActivityUseCase {
  final HomeRepository repository;

  ChangeUserActivityUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required bool isActive}) async {
    return await repository.changeUserActivity(isActive: isActive);
  }
}
