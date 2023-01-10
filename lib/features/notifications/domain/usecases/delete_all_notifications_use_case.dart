import 'package:dartz/dartz.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/notifications/domain/repositories/notifications_repository.dart';

class DeleteAllNotificationsUseCase {
  final NotificationRepository repository;

  DeleteAllNotificationsUseCase(this.repository);

  Future<Either<Failure, String>> call() async =>
      await repository.deleteAllNotifications();
}
