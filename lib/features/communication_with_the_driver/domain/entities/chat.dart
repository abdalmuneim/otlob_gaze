import 'package:flutter/foundation.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user.dart';
import 'package:otlob_gas/features/communication_with_the_driver/domain/entities/chat_message.dart';

class Chat {
  int? id;
  int? orderId;
  int? customerId;
  int? driverId;
  List<ChatMessage> messages = [];
  String? voiceUrl;
  String? createdAt;
  String? updatedAt;
  User? driver;

  Chat(
      {this.id,
      this.orderId,
      this.customerId,
      this.driverId,
      required this.messages,
      this.createdAt,
      this.updatedAt,
      this.voiceUrl,
      this.driver});

  Chat copyWith({
    String? voiceUrl,
    int? id,
    int? orderId,
    int? customerId,
    int? driverId,
    List<ChatMessage>? messages,
    String? createdAt,
    String? updatedAt,
    User? driver,
  }) {
    return Chat(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      customerId: customerId ?? this.customerId,
      driverId: driverId ?? this.driverId,
      voiceUrl: voiceUrl ?? this.voiceUrl,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      driver: driver ?? this.driver,
    );
  }

  @override
  String toString() {
    return 'Chat(id: $id, orderId: $orderId, customerId: $customerId, driverId: $driverId, messages: $messages, createdAt: $createdAt, updatedAt: $updatedAt, driver: $driver)';
  }

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.orderId == orderId &&
        other.customerId == customerId &&
        other.driverId == driverId &&
        listEquals(other.messages, messages) &&
        other.createdAt == createdAt &&
        other.voiceUrl == voiceUrl &&
        other.updatedAt == updatedAt &&
        other.driver == driver;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        orderId.hashCode ^
        customerId.hashCode ^
        driverId.hashCode ^
        messages.hashCode ^
        createdAt.hashCode ^
        voiceUrl.hashCode ^
        updatedAt.hashCode ^
        driver.hashCode;
  }
}
