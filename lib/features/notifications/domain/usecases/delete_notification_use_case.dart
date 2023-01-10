import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/notifications/domain/repositories/notifications_repository.dart';

class DeleteNotificationUseCase {
  final NotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  Future<Either<Failure, String>> call({required int notificationId}) async =>
      await repository.deleteNotification(notificationId: notificationId);
}
