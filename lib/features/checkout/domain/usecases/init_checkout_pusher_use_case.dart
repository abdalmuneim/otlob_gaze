import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/checkout/domain/repositories/checkout_repository.dart';

class InitCheckoutPusherUseCase {
  final CheckoutRepository repository;

  InitCheckoutPusherUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required int driverId}) async =>
      await repository.initPusher(driverId: driverId);
}
