import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_gas/common/routes/route_strings.dart';
import 'package:otlob_gas/common/services/navigation_service.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user_location.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/get_current_user_use_case.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/log_out_use_case.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/save_user_use_case.dart';

class AuthProvider extends ChangeNotifier {
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final SaveUserUseCase _saveUserUseCase;
  final LogOutUseCase _logOutUseCase;
  AuthProvider(
      this._getCurrentUserUseCase, this._logOutUseCase, this._saveUserUseCase);

  User? _currentUser;
  User? get currentUser => _currentUser;

  // clear user
  resetUser() {
    _currentUser = null;
    notifyListeners();
  }

  BuildContext get context => NavigationService.context;

//logout
  Future<void> logout() async {
    Utils.showLoading();
    resetUser();
    final result = await _logOutUseCase();
    Utils.hideLoading();
    result.fold((failure) {
      Utils.handleFailures(failure);
    }, (r) => {Utils.clearDialogs(), context.goNamed(RouteStrings.loginPage)});
  }

// get user
  Future<void> getCurrentUser() async {
    final result = await _getCurrentUserUseCase();
    result.fold((failure) => Utils.handleFailures(failure), (user) {
      _currentUser = user;
      notifyListeners();
    });
  }

  //edit user Default location
  Future<void> editUser({UserLocation? userLocation, double? wallet}) async {
    _currentUser =
        currentUser!.copyWith(location: userLocation, wallet: wallet);
    notifyListeners();

    final result = await _saveUserUseCase(user: _currentUser!);
    result.fold((failure) => Utils.handleFailures(failure), (_) {});
  }
}
