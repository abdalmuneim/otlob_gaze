import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/checkout/domain/entities/order.dart';
import 'package:otlob_gas/features/checkout/domain/entities/real_time_order.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, Unit>> cancelOrder({required int orderId});
  Future<Either<Failure, OrderEntity>> createOrder({required int locationId});
  Future<Either<Failure, List<OrderEntity>>> getOrders();
  Future<Either<Failure, OrderEntity>> assignOrder({
    required String notes,
    required int paymentMethod,
    required int quantity,
    required int orderId,
  });
  Future<Either<Failure, Unit>> orderDelivered({
    required int orderId,
  });
  Future<Either<Failure, Unit>> deliveredCheck({
    required int orderId,
  });
  Future<Either<Failure, Unit>> deliveredUnCheck({
    required int orderId,
  });
  Future<Either<Failure, Unit>> initPusher({required int driverId});
  Stream<RealTimeOrder> listenToCheckout();
  Future<Either<Failure, Unit>> disconnectPusher();
}
