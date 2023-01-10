import 'package:otlob_gas/features/home/domain/entities/order_status.dart';

class OrderStatusModel extends OrderStatus {
  OrderStatusModel({super.totalOrder, super.orderToday});

  OrderStatusModel.fromMap(Map<String, dynamic> json) {
    totalOrder = json['totalOrder'];
    orderToday = json['orderToday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalOrder'] = totalOrder;
    data['orderToday'] = orderToday;
    return data;
  }
}
