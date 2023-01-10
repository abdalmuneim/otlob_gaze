import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/exception.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/common/network_info.dart';
import 'package:otlob_gas/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:otlob_gas/features/rate_service/data/datasources/rate_service_data_source.dart';
import 'package:otlob_gas/features/rate_service/domain/repositories/rate_service_repository.dart';

class RateServiceRepositoryImpl implements RateServiceRepository {
  final RateServiceDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  RateServiceRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, String>> addRating(
      {required String comment,
      required String orderId,
      required String rating}) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final result = await remoteDataSource.addRating(
          comment: comment, orderId: orderId, token: token, rating: rating);

      return Right(result.message);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }
}
