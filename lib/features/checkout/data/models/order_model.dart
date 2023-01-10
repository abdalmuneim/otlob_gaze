import 'dart:convert';

import 'package:otlob_gas/features/checkout/data/models/driver_data_model.dart';
import 'package:otlob_gas/features/checkout/domain/entities/order.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    super.customerId,
    super.driverId,
    super.dropOffLat,
    super.dropOffLong,
    super.pickupLat,
    super.pickupLong,
    super.unitPrice,
    super.distancePrice,
    super.quantity,
    super.tax,
    super.delivery,
    super.totalPrice,
    super.date,
    super.updatedAt,
    super.createdAt,
    super.id,
    super.driverData,
    super.paymentMethod,
    super.distance,
    super.statusName,
    super.time,
    super.status,
    super.userEndTrip,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      customerId: map['customer_id'],
      driverId: map['driver_id'],
      dropOffLat: map['dropoff_lat'],
      status: map['status'],
      statusName: map['status_name'],
      dropOffLong: map['dropoff_long'],
      pickupLat: map['pickup_lat'],
      pickupLong: map['pickup_long'],
      unitPrice: double.tryParse(map['unit_price'].toString()),
      distancePrice: double.tryParse(map['distance_price'].toString()),
      quantity: int.tryParse(map['quantity'].toString()),
      tax: double.tryParse(map['tax'].toString()),
      delivery: double.tryParse(map['delivery'].toString()),
      totalPrice: double.tryParse(map['total_price'].toString()),
      date: DateTime.tryParse(map['date']),
      updatedAt: map['updated_at'],
      createdAt: map['created_at'],
      paymentMethod: int.tryParse(map['payment_method'].toString()),
      userEndTrip: int.tryParse(map['userendtrip'].toString()),
      id: map['id'],
      driverData: map['driver_data'] != null
          ? DriverDataModel.fromMap(map['driver_data'])
          : null,
      distance: map['distance'],
      time:
          map['time'] == null ? null : (map['time'] as String).split(' ').first,
    );
  }
  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
