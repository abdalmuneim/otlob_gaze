import 'package:otlob_gas/features/communication_with_the_driver/domain/entities/chat_message.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/repositories/communication_repository.dart';

class ListenToChatUseCase {
  final CommunicationRepository repository;

  ListenToChatUseCase(this.repository);

  Stream<ChatMessage> call() => repository.listenToChat();
}
