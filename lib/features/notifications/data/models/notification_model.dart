import 'dart:convert';

import 'package:otlob_gas/features/notifications/domain/entities/notification.dart';

class NotificationModel extends Notification {
  NotificationModel({
    super.id,
    super.userId,
    super.message,
    super.date,
    super.status,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      userId: map['user_id'],
      message: map['message'],
      date: map['date'],
      status: map['status'],
    );
  }

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
