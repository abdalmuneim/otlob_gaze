import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:otlob_gas/common/network_info.dart';
import 'package:otlob_gas/common/routes/route_strings.dart';
import 'package:otlob_gas/common/services/navigation_service.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/usecases/is_logged_in_use_case.dart';
import 'package:otlob_gas/features/on_boarding/domain/usecases/get_language_use_case.dart';
import 'package:otlob_gas/features/on_boarding/domain/usecases/save_language_use_case.dart';

class SplashProvider extends ChangeNotifier {
  final IsLoggedInUseCase _isLoggedInUseCase;
  final GetLanguageUseCase _getLanguageUseCase;
  final SaveLanguageUseCase _saveLanguageUseCase;
  final NetworkInfo _networkInfo;

  SplashProvider(
    this._saveLanguageUseCase,
    this._getLanguageUseCase,
    this._isLoggedInUseCase,
    this._networkInfo,
  );

  late String _language = _getLanguageUseCase();

  String get language => _language;
  Future<bool> get isLoggedIn async => await _isLoggedInUseCase();

  Future<void> saveLanguage(String language) async {
    final result = await _saveLanguageUseCase(language: language);
    result.fold((failure) => Utils.handleFailures(failure), (r) {
      _language = _getLanguageUseCase();
      notifyListeners();
    });
  }

  Future<void> startTimer() async {
    _networkInfo.initializeNetworkStream();
    Timer(const Duration(seconds: 3), () async => await navigate());
  }

  navigate() async {
    final context = NavigationService.context;
    if (await isLoggedIn) {
      context.goNamed(RouteStrings.pagesHandler);
    } else {
      context.goNamed(RouteStrings.loginPage);
    }
  }
}
