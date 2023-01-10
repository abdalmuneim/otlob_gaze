import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/exception.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/common/network_info.dart';
import 'package:otlob_gas/features/authentication/data/datasources/auth_local_data_source.dart';
import 'package:otlob_gas/features/checkout/data/datasources/checkout_remote_data_source.dart';
import 'package:otlob_gas/features/checkout/data/models/order_model.dart';
import 'package:otlob_gas/features/checkout/data/models/real_time_order_model.dart';
import 'package:otlob_gas/features/checkout/domain/repositories/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;

  final AuthLocalDataSource localDataSource;

  final NetworkInfo networkInfo;

  CheckoutRepositoryImpl({
    required this.networkInfo,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, Unit>> cancelOrder({required int orderId}) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      await remoteDataSource.cancelOrder(orderId: orderId, token: token);

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
  Future<Either<Failure, OrderModel>> createOrder({
    required int locationId,
  }) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final result = await remoteDataSource.createOrder(
          token: token, locationId: locationId);
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
  Future<Either<Failure, OrderModel>> assignOrder({
    required String notes,
    required int paymentMethod,
    required int quantity,
    required int orderId,
  }) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final result = await remoteDataSource.assignOrder(
        token: token,
        notes: notes,
        paymentMethod: paymentMethod,
        quantity: quantity,
        orderId: orderId,
      );
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
  Future<Either<Failure, List<OrderModel>>> getOrders() async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final orders = await remoteDataSource.getOrders(token: token);

      return Right(orders);
    } on ServerException catch (error) {
      return Left(ServerFailure(message: error.message));
    } on UnAuthorizedException {
      return const Left(UnAuthorizedFailure());
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> disconnectPusher() async {
    try {
      await remoteDataSource.disconnectPusher();

      return const Right(unit);
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> initPusher({required int driverId}) async {
    try {
      final int? customerId = (await localDataSource.getCurrentUser()).id;
      await remoteDataSource.initPusher(
          driverId: driverId, customerId: customerId!);

      return const Right(unit);
    } catch (error) {
      return Left(ExceptionFailure(message: error.toString()));
    }
  }

  @override
  Stream<RealTimeOrderModel> listenToCheckout() {
    return remoteDataSource.listenToCheckout();
  }

  @override
  Future<Either<Failure, Unit>> deliveredCheck({required int orderId}) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final result =
          await remoteDataSource.deliveredCheck(token: token, orderId: orderId);
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
  Future<Either<Failure, Unit>> deliveredUnCheck({required int orderId}) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final result = await remoteDataSource.deliveredUnCheck(
          token: token, orderId: orderId);
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
  Future<Either<Failure, Unit>> orderDelivered({required int orderId}) async {
    try {
      final String? token = await localDataSource.getUserToken;
      if (token == null) {
        throw UnAuthorizedException();
      }
      final result =
          await remoteDataSource.orderDelivered(token: token, orderId: orderId);
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
