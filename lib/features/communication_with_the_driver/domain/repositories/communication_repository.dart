import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/entities/chat.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/entities/chat_message.dart';

abstract class CommunicationRepository {
  Future<Either<Failure, ChatMessage>> sendMessage({
    required String message,
    required String type,
    required String orderId,
    required String messageId,
  });

  Future<Either<Failure, Chat>> getChat({required String orderId});

  Future<Either<Failure, Unit>> initPusher({required int orderId});
  Stream<ChatMessage> listenToChat();
  Future<Either<Failure, Unit>> disconnectPusher();
}
