import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/notifications/domain/entities/notification.dart';
import 'package:otlob_gas/features/notifications/domain/repositories/notifications_repository.dart';

class GetTodayNotificationsUseCase {
  final NotificationRepository repository;

  GetTodayNotificationsUseCase(this.repository);

  Future<Either<Failure, List<Notification>>> call() async =>
      await repository.getTodayNotifications();
}
