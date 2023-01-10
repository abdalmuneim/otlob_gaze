import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/common/hold_message_with.dart';
import 'package:otlob_gas/features/home/domain/repositories/home_repository.dart';

class ChargeBalanceUseCase {
  final HomeRepository repository;

  ChargeBalanceUseCase(this.repository);

  Future<Either<Failure, HoldMessageWith<double>>> call(
      {required String cardNumber}) async {
    return await repository.chargeBalance(cardNumber: cardNumber);
  }
}
