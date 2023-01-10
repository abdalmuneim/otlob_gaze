import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/checkout/domain/entities/order.dart';
import 'package:otlob_gas/features/checkout/domain/repositories/checkout_repository.dart';

class GetOrdersUseCase {
  final CheckoutRepository repository;

  GetOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call() async =>
      await repository.getOrders();
}
