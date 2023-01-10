import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/on_boarding/domain/repositories/on_boarding_repository.dart';

class GetPrivacyUseCase {
  final OnBoardingRepository repository;

  GetPrivacyUseCase(this.repository);

  Future<Either<Failure, String>> call() {
    return repository.getPrivacy();
  }
}
