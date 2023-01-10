import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/notifications/domain/entities/notification.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<Notification>>> getAllNotifications();
  Future<Either<Failure, List<Notification>>> getTodayNotifications();
  Future<Either<Failure, String>> deleteAllNotifications();
  Future<Either<Failure, String>> deleteNotification({
    required int notificationId,
  });
}
