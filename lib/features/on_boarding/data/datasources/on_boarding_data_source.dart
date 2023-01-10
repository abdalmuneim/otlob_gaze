import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:otlob_gas/common/constants/stored_keys.dart';
import 'package:otlob_gas/common/constants/strings.dart';
import 'package:otlob_gas/common/constants/urls.dart';
import 'package:otlob_gas/common/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnBoardingDataSource {
  Future<void> saveLanguage(String language);
  String get language;

  Future<String> getPrivacy();
  Future<String> getTerms();
  Future<String> getAboutApp();
}

class OnBoardingDataSourceImpl implements OnBoardingDataSource {
  final SharedPreferences sharedPreferences;
  final http.Client client;
  OnBoardingDataSourceImpl(
      {required this.sharedPreferences, required this.client});

  @override
  String get language =>
      sharedPreferences.getString(StoredKeys.language) ?? 'ar';

  @override
  Future<void> saveLanguage(String language) async =>
      await sharedPreferences.setString(StoredKeys.language, language);

  @override
  Future<String> getAboutApp() async {
    try {
      final response = await client.get(
        Uri.parse(Urls.about),
        headers: Urls.getHeaders(),
      );
      final responseBody = json.decode(response.body);

      if (response.statusCode == Strings.successStatusCode) {
        return responseBody['data'];
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<String>().timeOutMethod(() => getAboutApp());
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<String> getPrivacy() async {
    try {
      final response = await client.get(
        Uri.parse(Urls.privacy),
        headers: Urls.getHeaders(),
      );
      final responseBody = json.decode(response.body);

      if (response.statusCode == Strings.successStatusCode) {
        return responseBody['data'];
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<String>().timeOutMethod(() => getAboutApp());
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<String> getTerms() async {
    try {
      final response = await client.get(
        Uri.parse(Urls.terms),
        headers: Urls.getHeaders(),
      );
      final responseBody = json.decode(response.body);

      if (response.statusCode == Strings.successStatusCode) {
        return responseBody['data'];
      } else if (response.statusCode == Strings.unAuthorizedStatusCode) {
        throw UnAuthorizedException();
      } else {
        throw ServerException(message: responseBody['message']);
      }
    } on SocketException {
      return ServerService<String>().timeOutMethod(() => getAboutApp());
    } catch (error) {
      rethrow;
    }
  }
}
