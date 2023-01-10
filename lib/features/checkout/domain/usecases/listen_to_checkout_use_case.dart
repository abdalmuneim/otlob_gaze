import 'package:otlob_gas/features/checkout/domain/entities/real_time_order.dart';
import 'package:otlob_gas/features/checkout/domain/repositories/checkout_repository.dart';

class ListenToCheckoutUseCase {
  final CheckoutRepository repository;

  ListenToCheckoutUseCase(this.repository);

  Stream<RealTimeOrder> call() => repository.listenToCheckout();
}
