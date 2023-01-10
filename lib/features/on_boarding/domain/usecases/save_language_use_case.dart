import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/on_boarding/domain/repositories/on_boarding_repository.dart';

class SaveLanguageUseCase {
  final OnBoardingRepository repository;

  SaveLanguageUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String language,
  }) async {
    return await repository.saveLanguage(language);
  }
}
