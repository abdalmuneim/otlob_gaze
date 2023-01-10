class Strings {
  static const String googleMapApiKey =
      'AIzaSyAAOcn3r6DVavhuoPatQvNGg5kUuV1zAFo';

// pusher
  static const String pusherAppId = "1514903";
  static const String pusherAppKey = "4b7cbd9cbf9914a8e1d3";
  static const String pusherSecret = "bc4e8804c1eb8eb639c9";
  static const String pusherCluster = "ap2";
  static String getChatChannel(int orderId) => 'chat-$orderId';
  static String getDriverChannel({required int driverId}) => 'driver-$driverId';

// status code
  static const int unAuthorizedStatusCode = 401;
  static const int unVerifiedStatusCode = 403;
  static const int successStatusCode = 200;

  /// country code for otp
  static const String countryCode = "+2";
}
