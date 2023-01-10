import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/entities/chat.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/repositories/communication_repository.dart';

class GetChatUseCase {
  final CommunicationRepository repository;

  GetChatUseCase(this.repository);

  Future<Either<Failure, Chat>> call({required String orderId}) async =>
      await repository.getChat(orderId: orderId);
}
