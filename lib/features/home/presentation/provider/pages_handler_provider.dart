import 'package:flutter/material.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/failure.dart';
import 'package:otlob_gas/common/network_info.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/home/domain/usecases/change_user_activity_use_case.dart';

class PagesHandlerProvider extends ChangeNotifier {
  final ChangeUserActivityUseCase _changeUserActivityUseCase;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final NetworkInfo _networkInfo;

  PagesHandlerProvider(this._changeUserActivityUseCase, this._networkInfo);
  int _selectedIndex = 0;
  set setIndex(int value) {
    if (value == 2) {
      return;
    }
    if (scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState!.closeDrawer();
    }
    if (_selectedIndex != value) {
      _selectedIndex = value;
      notifyListeners();
    }
  }

  int get currentIndex => _selectedIndex;

  Color getCurrentColor(int itemIndex) =>
      itemIndex == currentIndex ? AppColors.mainApp : Colors.grey;

  changeUserActivity({required bool isActive}) async {
    await _changeUserActivityUseCase(isActive: isActive);
  }

  void handleAppLifeCycleChanges(AppLifecycleState state) {
    switch (state) {
      //When the app in background
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        changeUserActivity(isActive: false);
        break;

      //When the app in closed
      case AppLifecycleState.detached:
        changeUserActivity(isActive: false);
        break;

      //When the app come back
      case AppLifecycleState.resumed:
        changeUserActivity(isActive: true);
        break;
    }
  }

  listenToNetwork() async {
    _networkInfo.listenToNetworkStream.onData((bool isConnected) {
      if (isConnected) {
        Utils.removeEnhancedDialog(
            dialogName: Utils.localization?.networkFailure ?? '');
      } else {
        Utils.handleFailures(const ConnectionFailure());
      }
    });
  }

  Future<void> disposePage() async {
    await _networkInfo.listenToNetworkStream.cancel();
  }
}
