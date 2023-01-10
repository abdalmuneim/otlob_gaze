import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/on_boarding/domain/repositories/on_boarding_repository.dart';

class GetAboutAppUseCase {
  final OnBoardingRepository repository;

  GetAboutAppUseCase(this.repository);

  Future<Either<Failure, String>> call() {
    return repository.getAboutApp();
  }
}
