import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:otlob_gas/common/constants/strings.dart';
import 'package:otlob_gas/common/constants/urls.dart';
import 'package:otlob_gas/common/exception.dart';
import 'package:otlob_gas/common/hold_message_with.dart';
import 'package:otlob_gas/features/authentication/data/models/user_location_model.dart';
import 'package:otlob_gas/features/authentication/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<String> signUp(
      {required String name,
      required String email,
      required String mobile,
      required double lat,
      required double long,
      required String image,
      required String address,
      required String password,
      required String confirmPassword,
      required String currentLanguage});
  Future<HoldMessageWith<UserModel>> editAccount({
    required String name,
    required String mobile,
    required double lat,
    required double long,
    String? image,
    required String address,
    required String password,
    required String confirmPassword,
    required String token,
  });
  Future<UserModel> signIn(
      {required String mobile,
      required String password,
      required String currentLanguage});
  Future<String> verifyAccount({required String mobile});

  Future<String> recoverAccount({required String mobile});
  Future<Unit> logOut({required String token});
  Future<String> changePassword({
    required String mobile,
    required String password,
    required String confirmPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> signIn(
      {required String mobile,
      required String password,
      required String currentLanguage}) async {
    try {
      final UserModel userModel = UserModel(
        email: mobile,
        password: password,
      );
      final response = await client.post(Uri.parse(Urls.signInUser),
          headers: Urls.getHeaders(),
          body: userModel.toMap()..addAll({'lang': currentLanguage}));
      final responseBody = json.decode(response.body);
      if (response.statusCode == Strings.successStatusCode) {
        return UserModel.fromMap(responseBody['data']);
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<UserModel>().timeOutMethod(() => signIn(
          mobile: mobile,
          password: password,
          currentLanguage: currentLanguage));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<String> signUp({
    required String name,
    required String email,
    required String mobile,
    required double lat,
    required double long,
    required String address,
    required String image,
    required String password,
    required String confirmPassword,
    required String currentLanguage,
  }) async {
    try {
      final UserModel userModel = UserModel(
        name: name,
        email: email,
        location: UserLocationModel(
          lat: lat.toString(),
          long: long.toString(),
        ),
        mobile: mobile,
        confirmPassword: confirmPassword,
        password: password,
        address: address,
      );

      var request = http.MultipartRequest('POST', Uri.parse(Urls.signUpUser));
      request.fields
          .addAll(userModel.toMap()..addAll({'lang': currentLanguage}));
      request.files.add(await http.MultipartFile.fromPath('image', image));
      request.headers.addAll(Urls.getHeaders());
      http.StreamedResponse response = await request.send();
      final responseBody = json.decode(await response.stream.bytesToString());
      if (response.statusCode == Strings.successStatusCode) {
        return responseBody['message'];
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<String>().timeOutMethod(() => signUp(
          name: name,
          email: email,
          mobile: mobile,
          lat: lat,
          long: long,
          address: address,
          image: image,
          password: password,
          confirmPassword: confirmPassword,
          currentLanguage: currentLanguage));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<HoldMessageWith<UserModel>> editAccount({
    required String name,
    required String mobile,
    required double lat,
    required double long,
    String? image,
    required String address,
    required String password,
    required String confirmPassword,
    required String token,
  }) async {
    try {
      final UserModel userModel = UserModel(
        name: name,
        mobile: mobile,
        image: image,
        location: UserLocationModel(
          lat: lat.toString(),
          long: long.toString(),
        ),
        confirmPassword: confirmPassword,
        password: password,
        address: address,
      );

      var request =
          http.MultipartRequest('POST', Uri.parse(Urls.updateAccount));
      request.fields.addAll(userModel.toMap());
      if (image != null) {
        request.files.add(await http.MultipartFile.fromPath('image', image));
      }
      request.headers.addAll(Urls.getHeaders(token: token));
      http.StreamedResponse response = await request.send();
      final responseBody = json.decode(await response.stream.bytesToString());
      if (response.statusCode == Strings.successStatusCode) {
        return HoldMessageWith<UserModel>(
          data: UserModel.fromMap(responseBody['data']),
          message: responseBody['message'],
        );
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<HoldMessageWith<UserModel>>().timeOutMethod(() =>
          editAccount(
              name: name,
              mobile: mobile,
              lat: lat,
              long: long,
              image: image,
              address: address,
              password: password,
              confirmPassword: confirmPassword,
              token: token));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<String> recoverAccount({required String mobile}) async {
    try {
      final response = await client.post(Uri.parse(Urls.recoverAccount),
          headers: Urls.getHeaders(), body: {'mobile': mobile});
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
          .timeOutMethod(() => recoverAccount(mobile: mobile));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<Unit> logOut({required String token}) async {
    try {
      final response = await client.post(
        Uri.parse(Urls.logOutUser),
        headers: Urls.getHeaders(token: token),
      );
      final responseBody = json.decode(response.body);

      if (response.statusCode == Strings.successStatusCode) {
        return unit;
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<Unit>().timeOutMethod(() => logOut(token: token));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<String> changePassword(
      {required String mobile,
      required String password,
      required String confirmPassword}) async {
    try {
      final response = await client.post(Uri.parse(Urls.changePassword),
          headers: Urls.getHeaders(),
          body: {
            'mobile': mobile,
            'password': password,
            'password_confirmation': confirmPassword,
          });
      final responseBody = json.decode(response.body);

      if (response.statusCode == Strings.successStatusCode) {
        return responseBody['message'];
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<String>().timeOutMethod(() => changePassword(
          mobile: mobile,
          password: password,
          confirmPassword: confirmPassword));
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<String> verifyAccount({required String mobile}) async {
    try {
      final response = await client.post(Uri.parse(Urls.verifyAccount),
          headers: Urls.getHeaders(),
          body: {
            'mobile': mobile,
          });
      final responseBody = json.decode(response.body);

      if (response.statusCode == Strings.successStatusCode) {
        return responseBody['message'];
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<String>().timeOutMethod(
        () => verifyAccount(
          mobile: mobile,
        ),
      );
    } catch (error) {
      rethrow;
    }
  }
}
