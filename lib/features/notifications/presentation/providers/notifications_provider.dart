import 'package:flutter/foundation.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/notifications/domain/entities/notification.dart';
import 'package:otlob_gas/features/notifications/domain/usecases/delete_all_notifications_use_case.dart';
import 'package:otlob_gas/features/notifications/domain/usecases/delete_notification_use_case.dart';
import 'package:otlob_gas/features/notifications/domain/usecases/get_notifications_use_case.dart';
import 'package:otlob_gas/features/notifications/domain/usecases/get_today_notifications_use_case.dart';

class NotificationsProvider extends ChangeNotifier {
  final GetAllNotificationsUseCase _getAllNotificationsUseCase;
  final GetTodayNotificationsUseCase _getTodayNotificationsUseCase;
  final DeleteNotificationUseCase _deleteNotificationUseCase;
  final DeleteAllNotificationsUseCase _deleteAllNotificationsUseCase;

  NotificationsProvider(
    this._getAllNotificationsUseCase,
    this._getTodayNotificationsUseCase,
    this._deleteNotificationUseCase,
    this._deleteAllNotificationsUseCase,
  );

  List<Notification> todayNotifications = [];
  List<Notification> allNotifications = [];
  bool isLoading = true;

  Future initPage() async {
    if (!isLoading) return;
    await Future.wait(<Future>[getAllNotifications(), getTodayNotifications()]);
    isLoading = false;
    notifyListeners();
  }

  disposePage() {
    todayNotifications.clear();
    allNotifications.clear();
    isLoading = true;
  }

  /// get all notifications except today notifications
  getAllNotifications() async {
    final result = await _getAllNotificationsUseCase();
    result.fold((failure) => Utils.handleFailures(failure),
        (notifications) => allNotifications = notifications);
  }

  /// get today all notifications
  getTodayNotifications() async {
    final result = await _getTodayNotificationsUseCase();
    result.fold((failure) => Utils.handleFailures(failure),
        (notifications) => todayNotifications = notifications);
  }

  /// delete only one notification
  deleteNotification(int id, bool isTodayNotification) async {
    Utils.showLoading();
    final result = await _deleteNotificationUseCase(notificationId: id);
    Utils.hideLoading();
    result.fold((failure) => Utils.handleFailures(failure), (message) {
      if (isTodayNotification) {
        todayNotifications.removeWhere((element) => element.id == id);
      } else {
        allNotifications.removeWhere((element) => element.id == id);
      }
      notifyListeners();
      Utils.showToast(message);
    });
  }

  /// delete all notifications
  deleteAllNotifications() async {
    Utils.showLoading();
    final result = await _deleteAllNotificationsUseCase();
    Utils.hideLoading();
    result.fold((failure) => Utils.handleFailures(failure), (message) {
      todayNotifications.clear();
      allNotifications.clear();
      notifyListeners();
      Utils.showToast(message);
    });
  }
}
