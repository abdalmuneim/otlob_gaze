import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';

abstract class OnBoardingRepository {
  String get language;
  Future<Either<Failure, Unit>> saveLanguage(String language);

  Future<Either<Failure, String>> getPrivacy();
  Future<Either<Failure, String>> getTerms();
  Future<Either<Failure, String>> getAboutApp();
}
