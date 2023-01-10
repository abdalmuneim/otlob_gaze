import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' show Client;
import 'package:otlob_gas/common/constants/strings.dart';
import 'package:otlob_gas/common/constants/urls.dart';
import 'package:otlob_gas/common/exception.dart';
import 'package:otlob_gas/common/hold_message_with.dart';
import 'package:otlob_gas/features/authentication/data/models/user_location_model.dart';
import 'package:otlob_gas/features/home/data/models/ads_model.dart';
import 'package:otlob_gas/features/home/data/models/nearest_driver_model.dart';
import 'package:otlob_gas/features/home/data/models/order_status_model.dart';

abstract class HomeDataSource {
  Future<Unit> changeUserActivity(
      {required String token, required bool isActive});
  Future<List<NearestDriverModel>> getNearestDrivers(
      {required String token, required double lat, required double lng});
  Future<List<UserLocationModel>> getMyLocations({required String token});
  Future<List<AdsModel>> getAds({required String token});
  Future<OrderStatusModel> getOrderStatus({required String token});
  Future<UserLocationModel> addLocation(
      {required String token,
      required double lat,
      required double long,
      required String title,
      required String floorNumber,
      required String buildingNumber,
      required bool isDefault});

  Future<UserLocationModel> editLocation(
      {required String token,
      double? lat,
      double? long,
      String? title,
      String? floorNumber,
      String? buildingNumber,
      bool? isDefault,
      required int locationId});
  Future<HoldMessageWith<double>> chargeBalance(
      {required String token, required String cardNumber});
}

class HomeDataSourceImpl implements HomeDataSource {
  final Client client;
  HomeDataSourceImpl({required this.client});

  @override
  Future<Unit> changeUserActivity(
      {required String token, required bool isActive}) async {
    try {
      final response = await client.post(Uri.parse(Urls.changeUserActivity),
          headers: Urls.getHeaders(token: token),
          body: {'is_active': isActive ? '1' : '0'});
      final responseBody = json.decode(response.body);

      if (response.statusCode == Strings.successStatusCode) {
        return unit;
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<Unit>().timeOutMethod(
          () => changeUserActivity(token: token, isActive: isActive));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<NearestDriverModel>> getNearestDrivers(
      {required String token, required double lat, required double lng}) async {
    try {
      final response = await client.post(Uri.parse(Urls.getNearestDriver),
          headers: Urls.getHeaders(token: token),
          body: {'lat': lat.toString(), 'long': lng.toString()});
      final responseBody = json.decode(response.body);

      if (response.statusCode == Strings.successStatusCode) {
        List<NearestDriverModel> nearestDrivers = [];
        for (var nearestDriver in responseBody['data']) {
          nearestDrivers.add(NearestDriverModel.fromMap(nearestDriver));
        }
        return nearestDrivers;
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<List<NearestDriverModel>>().timeOutMethod(
          () => getNearestDrivers(token: token, lat: lat, lng: lng));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<UserLocationModel>> getMyLocations(
      {required String token}) async {
    try {
      final response = await client.get(
        Uri.parse(Urls.location),
        headers: Urls.getHeaders(token: token),
      );
      final responseBody = json.decode(response.body);

      if (response.statusCode == Strings.successStatusCode) {
        List<UserLocationModel> myLocations = [];
        for (var myLocation in responseBody['data']) {
          myLocations.add(UserLocationModel.fromMap(myLocation));
        }
        return myLocations;
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<List<UserLocationModel>>()
          .timeOutMethod(() => getMyLocations(token: token));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<UserLocationModel> addLocation(
      {required String token,
      required double lat,
      required double long,
      required String title,
      required String floorNumber,
      required String buildingNumber,
      required bool isDefault}) async {
    try {
      final response = await client.post(
        Uri.parse(Urls.location),
        headers: Urls.getHeaders(token: token),
        body: UserLocationModel(
          lat: lat.toString(),
          long: long.toString(),
          title: title,
          floorNumber: floorNumber,
          buildingNumber: buildingNumber,
          defaultLocation: isDefault,
        ).toMap(),
      );
      final responseBody = json.decode(response.body);

      if (response.statusCode == Strings.successStatusCode) {
        return UserLocationModel.fromMap(responseBody['data']);
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<UserLocationModel>().timeOutMethod(() => addLocation(
          token: token,
          lat: lat,
          long: long,
          title: title,
          floorNumber: floorNumber,
          buildingNumber: buildingNumber,
          isDefault: isDefault));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<UserLocationModel> editLocation(
      {required String token,
      double? lat,
      String? title,
      String? floorNumber,
      String? buildingNumber,
      double? long,
      bool? isDefault,
      required int locationId}) async {
    try {
      final response = await client.post(
        Uri.parse(Urls.editLocation(locationId)),
        headers: Urls.getHeaders(token: token),
        body: UserLocationModel(
          lat: lat.toString(),
          long: long.toString(),
          title: title,
          floorNumber: floorNumber,
          buildingNumber: buildingNumber,
          defaultLocation: isDefault,
        ).toMap()
          ..addAll({'_method': 'put'}),
      );
      final responseBody = json.decode(response.body);

      if (response.statusCode == Strings.successStatusCode) {
        return UserLocationModel.fromMap(responseBody['data']);
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<UserLocationModel>()
          .timeOutMethod(() => editLocation(
                locationId: locationId,
                buildingNumber: buildingNumber,
                floorNumber: floorNumber,
                isDefault: isDefault,
                lat: lat,
                long: long,
                title: title,
                token: token,
              ));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<List<AdsModel>> getAds({required String token}) async {
    try {
      final response = await client.get(
        Uri.parse(Urls.ads),
        headers: Urls.getHeaders(token: token),
      );
      final responseBody = json.decode(response.body);

      if (response.statusCode == Strings.successStatusCode) {
        List<AdsModel> ads = [];
        for (var myLocation in responseBody['data']) {
          ads.add(AdsModel.fromMap(myLocation));
        }
        return ads;
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<List<AdsModel>>()
          .timeOutMethod(() => getAds(token: token));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<HoldMessageWith<double>> chargeBalance(
      {required String token, required String cardNumber}) async {
    try {
      final response = await client.post(Uri.parse(Urls.charging),
          headers: Urls.getHeaders(token: token),
          body: {'card_number': cardNumber});
      final responseBody = json.decode(response.body);
      final message = responseBody['message'];
      if (response.statusCode == Strings.successStatusCode) {
        return HoldMessageWith<double>(
            message: message,
            data: double.parse(responseBody['data'].toString()));
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: message);
      }
    } on SocketException {
      return ServerService<HoldMessageWith<double>>().timeOutMethod(
          () => chargeBalance(token: token, cardNumber: cardNumber));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<OrderStatusModel> getOrderStatus({required String token}) async {
    try {
      final response = await client.post(
        Uri.parse(Urls.orderStatus),
        headers: Urls.getHeaders(token: token),
      );
      final responseBody = json.decode(response.body);

      if (response.statusCode == Strings.successStatusCode) {
        return OrderStatusModel.fromMap(responseBody['data']);
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<OrderStatusModel>()
          .timeOutMethod(() => getOrderStatus(token: token));
    } catch (error) {
      rethrow;
    }
  }
}
