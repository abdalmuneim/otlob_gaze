import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/repositories/communication_repository.dart';

class DisconnectChatPusherUseCase {
  final CommunicationRepository repository;

  DisconnectChatPusherUseCase(this.repository);

  Future<Either<Failure, Unit>> call() async =>
      await repository.disconnectPusher();
}
