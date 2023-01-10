import 'dart:convert';

import 'package:otlob_gas/features/communication_with_the_driver/domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    super.id,
    super.userId,
    super.message,
    super.date,
    super.type,
    super.messageStatus,
  });

  Map<String, String> toMap() {
    return <String, String>{
      if (message != null && message!.isNotEmpty) 'message': message!,
      if (type != null && type!.isNotEmpty) 'type': type!,
      if (id != null && id!.isNotEmpty) 'message_id': id!,
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      id: map['id'].toString(),
      userId: map['user_id'],
      type: map['type'],
      message: map['message'] ?? '',
      date: map['date'] != null ? DateTime.tryParse(map['date']) : null,
      messageStatus: 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessageModel.fromJson(String source) =>
      ChatMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
