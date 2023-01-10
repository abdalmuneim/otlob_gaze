import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/exception.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/common/hold_message_with.dart';
import 'package:otlob_gas/common/network_info.dart';
import 'package:otlob_gas/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:otlob_gas/features/authentication/data/models/user_location_model.dart';
import 'package:otlob_gas/features/home/data/datasources/home_data_source.dart';
import 'package:otlob_gas/features/home/data/models/ads_model.dart';
import 'package:otlob_gas/features/home/data/models/nearest_driver_model.dart';
import 'package:otlob_gas/features/home/data/models/order_status_model.dart';
import 'package:otlob_gas/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDataSource dataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl(
      {required this.networkInfo,
      required this.dataSource,
      required this.localDataSource});

  @override
  Future<Either<Failure, Unit>> changeUserActivity(
      {required bool isActive}) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      await dataSource.changeUserActivity(isActive: isActive, token: token);

      return const Right(unit);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } on DataBaseException {
      return const Left(DatabaseFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NearestDriverModel>>> getNearestDrivers(
      {required double lat, required double lng}) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final result =
          await dataSource.getNearestDrivers(token: token, lat: lat, lng: lng);

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } on DataBaseException {
      return const Left(DatabaseFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserLocationModel>>> getMyLocations() async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final result = await dataSource.getMyLocations(token: token);

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } on DataBaseException {
      return const Left(DatabaseFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, UserLocationModel>> addLocation(
      {required double lat,
      required double long,
      required String title,
      required String floorNumber,
      required String buildingNumber,
      required bool isDefault}) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final result = await dataSource.addLocation(
          token: token,
          lat: lat,
          long: long,
          title: title,
          floorNumber: floorNumber,
          buildingNumber: buildingNumber,
          isDefault: isDefault);

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } on DataBaseException {
      return const Left(DatabaseFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, UserLocationModel>> editLocation(
      {double? lat,
      double? long,
      bool? isDefault,
      String? title,
      String? floorNumber,
      String? buildingNumber,
      required int locationId}) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final result = await dataSource.editLocation(
          token: token,
          lat: lat,
          long: long,
          title: title,
          floorNumber: floorNumber,
          buildingNumber: buildingNumber,
          isDefault: isDefault,
          locationId: locationId);

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } on DataBaseException {
      return const Left(DatabaseFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AdsModel>>> getAds() async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final result = await dataSource.getAds(token: token);

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } on DataBaseException {
      return const Left(DatabaseFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderStatusModel>> getOrderStatus() async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final result = await dataSource.getOrderStatus(token: token);

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } on DataBaseException {
      return const Left(DatabaseFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, HoldMessageWith<double>>> chargeBalance(
      {required String cardNumber}) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final result =
          await dataSource.chargeBalance(token: token, cardNumber: cardNumber);

      return Right(result);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } on DataBaseException {
      return const Left(DatabaseFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }
}
