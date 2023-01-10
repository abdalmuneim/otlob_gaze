import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/checkout/domain/entities/order.dart';
import 'package:otlob_gas/features/checkout/domain/repositories/checkout_repository.dart';

class CreateOrderUseCase {
  final CheckoutRepository repository;

  CreateOrderUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call({required int locationId}) async {
    return await repository.createOrder(locationId: locationId);
  }
}
