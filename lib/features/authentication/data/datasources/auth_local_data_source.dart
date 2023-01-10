import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:otlob_gas/common/constants/stored_keys.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/features/authentication/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<UserModel> getCurrentUser();
  Future<Unit> saveCurrentUser({
    required UserModel userModel,
  });
  Future<bool> isLoggedIn();
  Future<Unit> logOut();
  Future<String?> get getUserToken;
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage flutterSecureStorage;
  final SharedPreferences sharedPreferences;
  AuthLocalDataSourceImpl(
      {required this.flutterSecureStorage, required this.sharedPreferences});

  @override
  Future<UserModel> getCurrentUser() async {
    final String? userModel =
        sharedPreferences.getString(StoredKeys.currentUser);
    if (userModel == null) {
      throw const DatabaseFailure();
    }

    return UserModel.fromJson(userModel);
  }

  @override
  Future<Unit> saveCurrentUser({required UserModel userModel}) async {
    try {
      await sharedPreferences.setString(
          StoredKeys.currentUser, userModel.toJson());
      if (userModel.token != null) {
        await flutterSecureStorage.write(
            key: StoredKeys.token, value: userModel.token);
      }

      return unit;
    } catch (error) {
      throw const DatabaseFailure();
    }
  }

  @override
  Future<bool> isLoggedIn() async => await getUserToken != null;

  @override
  Future<String?> get getUserToken async =>
      await flutterSecureStorage.read(key: StoredKeys.token);

  @override
  Future<Unit> logOut() async {
    try {
      await sharedPreferences.remove(StoredKeys.currentUser);
      await flutterSecureStorage.delete(key: StoredKeys.token);

      return unit;
    } catch (error) {
      throw const DatabaseFailure();
    }
  }
}
