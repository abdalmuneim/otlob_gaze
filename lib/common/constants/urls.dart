import 'package:otlob_gas/common/constants/strings.dart';

class Urls<T> {
  static const String baseUrl = 'http://otlobgas.codeella.com/api';

  // static const String baseUrl = 'http://192.168.1.14/OtlobGas/public/api';
  static String get signInUser => '$baseUrl/auth/signIn/email';
  static String get signUpUser => '$baseUrl/auth/register';
  static String get recoverAccount => '$baseUrl/auth/recover';
  static String get verifyAccount => '$baseUrl/auth/verifyAccount';
  static String get changePassword => '$baseUrl/auth/changePassword';
  static String get logOutUser => '$baseUrl/logout';
  static String get updateAccount => '$baseUrl/update_user';
  static String get changeUserActivity => '$baseUrl/is_active';
  static String get getNearestDriver => '$baseUrl/get_nearest_driver';
  static String get location => '$baseUrl/location';
  static String get ads => '$baseUrl/ads';
  static String get createOrder => '$baseUrl/createOrder';
  static String get orderStatus => '$baseUrl/orderStatus';
  static String get notification => '$baseUrl/notification';
  static String get deleteAllNotifications => '$baseUrl/destroyAll';
  static String get todayNotifications => '$baseUrl/AllTodyNotif';
  static String get privacy => '$baseUrl/privacy';
  static String get terms => '$baseUrl/terms';
  static String get about => '$baseUrl/about';
  static String deleteNotification({required int notificationId}) =>
      '$baseUrl/notification/$notificationId';

  static String orderDelivered({required int orderId}) =>
      '$baseUrl/OrderDelivered/$orderId';
  static String deliveredCheck({required int orderId}) =>
      '$baseUrl/DeliveredCheck/$orderId';
  static String deliveredUnCheck({required int orderId}) =>
      '$baseUrl/DeliveredUnCheck/$orderId';
  static String assignOrder({required int orderId}) =>
      '$baseUrl/OrderAssign/$orderId';
  static String get addRating => '$baseUrl/rating';
  static String get charging => '$baseUrl/Charging';
  static String get order => '$baseUrl/Order';
  static String editLocation(int locationId) => '$baseUrl/location/$locationId';
  static String cancelOrder(int orderId) => '$baseUrl/cancelOrder/$orderId';

  static String chat({String? orderId}) =>
      '$baseUrl/chat${orderId == null ? '' : '/$orderId'}';

  static String mapSearch({input, language}) =>
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=${Strings.googleMapApiKey}&language=$language';

  static Map<String, String> getHeaders({String? token}) => {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        'Accept': 'application/json'
      };
}

class ServerService<T> {
  //timeout duration
  Future<T> timeOutMethod(Future<T> Function() function) async {
    return await Future.delayed(const Duration(seconds: 10), () async {
      return await function();
    });
  }
}
