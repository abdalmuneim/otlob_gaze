import 'package:otlob_gas/features/on_boarding/domain/repositories/on_boarding_repository.dart';

class GetLanguageUseCase {
  final OnBoardingRepository repository;

  GetLanguageUseCase(this.repository);

  String call() {
    return repository.language;
  }
}
