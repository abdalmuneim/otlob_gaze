import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/checkout/domain/repositories/checkout_repository.dart';

class DeliveredCheckedUseCase {
  final CheckoutRepository repository;

  DeliveredCheckedUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required int orderId}) async {
    return await repository.deliveredCheck(orderId: orderId);
  }
}
