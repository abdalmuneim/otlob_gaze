import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/checkout/domain/repositories/checkout_repository.dart';

class DisconnectCheckoutPusherUseCase {
  final CheckoutRepository repository;

  DisconnectCheckoutPusherUseCase(this.repository);

  Future<Either<Failure, Unit>> call() async =>
      await repository.disconnectPusher();
}
