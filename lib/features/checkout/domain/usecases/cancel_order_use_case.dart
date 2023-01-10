import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/checkout/domain/repositories/checkout_repository.dart';

class CancelOrderUseCase {
  final CheckoutRepository repository;

  CancelOrderUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required int orderId,
  }) async =>
      await repository.cancelOrder(orderId: orderId);
}
