import 'package:flutter/material.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/authentication/domain/entities/user.dart';
import 'package:otlob_gas/features/home/domain/entities/order_status.dart';
import 'package:otlob_gas/features/home/domain/usecases/get_order_status_use_case.dart';

class ProfilePageProvider extends ChangeNotifier {
  final GetOrderStatusUseCase _getOrderStatusUseCase;
  ProfilePageProvider(this._getOrderStatusUseCase);

  User? currentUser;

  set setUser(User? value) {
    currentUser = value;
    notifyListeners();
  }

  int currentIndex = 0;
  static const Color activeColor = AppColors.mainApp;
  static const Color unActiveColor = Colors.grey;
  Color getColor(int index) =>
      index == currentIndex ? activeColor : unActiveColor;
  void setIndex(int value) {
    currentIndex = value;
    notifyListeners();
  }

  bool isLoading = true;

  OrderStatus orderStatus = OrderStatus();
  getOrderStatus() async {
    isLoading = true;
    final result = await _getOrderStatusUseCase();
    isLoading = false;
    notifyListeners();
    result.fold((failure) => Utils.handleFailures(failure),
        (orderStatus) => this.orderStatus = orderStatus);
  }
}
