import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/home/domain/entities/order_status.dart';
import 'package:otlob_gas/features/home/domain/repositories/home_repository.dart';

class GetOrderStatusUseCase {
  final HomeRepository repository;

  GetOrderStatusUseCase(this.repository);

  Future<Either<Failure, OrderStatus>> call() async {
    return await repository.getOrderStatus();
  }
}
