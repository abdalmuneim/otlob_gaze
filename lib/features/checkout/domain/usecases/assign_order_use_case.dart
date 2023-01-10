import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/checkout/domain/entities/order.dart';
import 'package:otlob_gas/features/checkout/domain/repositories/checkout_repository.dart';

class AssignOrderUseCase {
  final CheckoutRepository repository;

  AssignOrderUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call({
    required String notes,
    required int paymentMethod,
    required int quantity,
    required int orderId,
  }) async {
    return await repository.assignOrder(
      notes: notes,
      paymentMethod: paymentMethod,
      quantity: quantity,
      orderId: orderId,
    );
  }
}
