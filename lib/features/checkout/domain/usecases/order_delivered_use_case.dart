import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/checkout/domain/repositories/checkout_repository.dart';

class OrderDeliveredUseCase {
  final CheckoutRepository repository;

  OrderDeliveredUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required int orderId}) async {
    return await repository.orderDelivered(orderId: orderId);
  }
}
