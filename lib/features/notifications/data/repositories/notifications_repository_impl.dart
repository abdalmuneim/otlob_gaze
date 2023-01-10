import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/exception.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:otlob_gas/features/notifications/data/datasources/notifications_data_source.dart';
import 'package:otlob_gas/features/notifications/domain/entities/notification.dart';
import 'package:otlob_gas/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  final AuthLocalDataSource localDataSource;

  NotificationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, String>> deleteAllNotifications() async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }

      final result =
          await remoteDataSource.deleteAllNotifications(token: token);

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
  Future<Either<Failure, String>> deleteNotification(
      {required int notificationId}) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }

      final result = await remoteDataSource.deleteNotification(
          token: token, notificationId: notificationId);

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
  Future<Either<Failure, List<Notification>>> getAllNotifications() async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }

      final result = await remoteDataSource.getAllNotifications(token: token);

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
  Future<Either<Failure, List<Notification>>> getTodayNotifications() async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }

      final result = await remoteDataSource.getTodayNotifications(token: token);

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
