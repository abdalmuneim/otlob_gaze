import 'package:flutter/cupertino.dart';
import 'package:otlob_gas/common/utils.dart';
import 'package:otlob_gas/features/checkout/domain/entities/order.dart';
import 'package:otlob_gas/features/checkout/domain/usecases/get_orders_use_case.dart';

class OrdersListProvider extends ChangeNotifier {
  final GetOrdersUseCase _getOrdersUseCase;

  OrdersListProvider(this._getOrdersUseCase);
  bool isLoading = true;
  init() async {
    isLoading = true;
    if (isLoading) {
      await getOrders().then((_) {
        isLoading = false;
        notifyListeners();
      });
    }
  }

  final List<OrderEntity> _orders = [];
  List<OrderEntity> get orders => _orders;
  Future<void> getOrders() async {
    final result = await _getOrdersUseCase();
    result.fold((failure) => Utils.handleFailures(failure), (orders) {
      _orders.clear();
      _orders.addAll(orders);
    });
  }
}
