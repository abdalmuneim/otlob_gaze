import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:otlob_gas/common/constants/strings.dart';
import 'package:otlob_gas/common/constants/urls.dart';
import 'package:otlob_gas/common/exception.dart';
import 'package:otlob_gas/features/notifications/data/models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getAllNotifications({required String token});
  Future<List<NotificationModel>> getTodayNotifications(
      {required String token});
  Future<String> deleteAllNotifications({required String token});
  Future<String> deleteNotification({
    required int notificationId,
    required String token,
  });
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final http.Client client;
  NotificationsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<NotificationModel>> getAllNotifications({
    required String token,
  }) async {
    try {
      final response = await client.get(
        Uri.parse(Urls.notification),
        headers: Urls.getHeaders(token: token),
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode == Strings.successStatusCode) {
        List<NotificationModel> notifications = [];
        for (var notification in responseBody['data']) {
          notifications.add(NotificationModel.fromMap(notification));
        }
        return notifications;
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<List<NotificationModel>>()
          .timeOutMethod(() => getAllNotifications(token: token));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<NotificationModel>> getTodayNotifications({
    required String token,
  }) async {
    try {
      final response = await client.get(
        Uri.parse(Urls.todayNotifications),
        headers: Urls.getHeaders(token: token),
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode == Strings.successStatusCode) {
        List<NotificationModel> notifications = [];
        for (var notification in responseBody['data']) {
          notifications.add(NotificationModel.fromMap(notification));
        }
        return notifications;
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<List<NotificationModel>>()
          .timeOutMethod(() => getTodayNotifications(token: token));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<String> deleteAllNotifications({required String token}) async {
    try {
      final response = await client.post(
        Uri.parse(Urls.deleteAllNotifications),
        headers: Urls.getHeaders(token: token),
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode == Strings.successStatusCode) {
        return responseBody['message'];
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<String>()
          .timeOutMethod(() => deleteAllNotifications(token: token));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<String> deleteNotification(
      {required int notificationId, required String token}) async {
    try {
      final response = await client.post(
        Uri.parse(Urls.deleteNotification(notificationId: notificationId)),
        headers: Urls.getHeaders(token: token),
        body: {'_method': 'delete'},
      );
      final responseBody = json.decode(response.body);
      if (response.statusCode == Strings.successStatusCode) {
        return responseBody['message'];
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<String>()
          .timeOutMethod(() => deleteAllNotifications(token: token));
    } catch (error) {
      rethrow;
    }
  }
}
