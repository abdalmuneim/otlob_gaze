import 'dart:convert';

import 'package:otlob_gas/features/authentication/data/models/user_model.dart';
import 'package:otlob_gas/features/communication_with_the_driver/data/models/chat_message_model.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/entities/chat.dart';

class ChatModel extends Chat {
  ChatModel(
      {super.id,
      super.orderId,
      super.customerId,
      super.driverId,
      required super.messages,
      super.createdAt,
      super.updatedAt,
      super.voiceUrl,
      super.driver});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'order_id': orderId,
      'customer_id': customerId,
      'driver_id': driverId,
      'messages': messages.map((x) => (x as ChatMessageModel).toMap()).toList(),
      'created_at': createdAt,
      'updated_at': updatedAt,
      'driver': driver != null ? (driver as UserModel).toMap() : null,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      orderId: map['order_id'],
      customerId: map['customer_id'],
      voiceUrl: map['voice_url'],
      driverId: map['driver_id'],
      messages: map['messages'] != null
          ? List<ChatMessageModel>.from(
              (map['messages'] as List<dynamic>).map<ChatMessageModel?>(
                (x) => ChatMessageModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
      driver: map['driver'] != null
          ? UserModel.fromMap(map['driver'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
