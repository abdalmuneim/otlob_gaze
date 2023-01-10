import 'package:otlob_gas/features/checkout/data/models/order_model.dart';
import 'package:otlob_gas/features/checkout/domain/entities/real_time_order.dart';

class RealTimeOrderModel extends RealTimeOrder {
  RealTimeOrderModel({
    super.status,
    super.lat,
    super.long,
    super.time,
    super.message,
    super.order,
  });

  RealTimeOrderModel.fromMap(Map<String, dynamic> json) {
    status = json['status'] is bool ? json['status'] : null;
    lat = json['lat'];
    long = json['long'];
    time =
        json['time'] == null ? null : (json['time'] as String).split(' ').first;
    message = json['message'];
    order = json['order'] != null ? OrderModel.fromMap(json['order']) : null;
  }
}
