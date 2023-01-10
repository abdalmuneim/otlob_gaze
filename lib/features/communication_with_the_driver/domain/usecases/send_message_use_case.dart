import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/entities/chat_message.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/repositories/communication_repository.dart';

class SendMessageUseCase {
  final CommunicationRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, ChatMessage>> call(
          {required String message,
          required String type,
          required String messageId,
          required String orderId}) async =>
      await repository.sendMessage(
          messageId: messageId, orderId: orderId, message: message, type: type);
}
