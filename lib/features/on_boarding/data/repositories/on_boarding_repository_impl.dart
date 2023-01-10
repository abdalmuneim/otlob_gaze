import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/exception.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/on_boarding/data/datasources/on_boarding_data_source.dart';
import 'package:otlob_gas/features/on_boarding/domain/repositories/on_boarding_repository.dart';

class OnBoardingRepositoryImpl implements OnBoardingRepository {
  final OnBoardingDataSource dataSource;

  OnBoardingRepositoryImpl({required this.dataSource});
  @override
  String get language => dataSource.language;

  @override
  Future<Either<Failure, Unit>> saveLanguage(String language) async {
    try {
      await dataSource.saveLanguage(language);

      return const Right(unit);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getAboutApp() async {
    try {
      final result = await dataSource.getAboutApp();

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getTerms() async {
    try {
      final result = await dataSource.getTerms();

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getPrivacy() async {
    try {
      final result = await dataSource.getPrivacy();

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }
}
