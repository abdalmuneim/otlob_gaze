import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/repositories/communication_repository.dart';

class InitChatPusherUseCase {
  final CommunicationRepository repository;

  InitChatPusherUseCase(this.repository);

  Future<Either<Failure, Unit>> call({required int orderId}) async =>
      await repository.initPusher(orderId: orderId);
}
