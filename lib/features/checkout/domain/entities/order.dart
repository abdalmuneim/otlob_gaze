import 'package:otlob_gas/features/checkout/domain/entities/driver_data.dart';

class OrderEntity {
  int? customerId;
  int? driverId;
  String? dropOffLat;
  String? dropOffLong;
  String? pickupLat;
  String? pickupLong;
  double? unitPrice;
  double? distancePrice;
  int? quantity;
  double? tax;
  double? delivery;
  int? paymentMethod;
  double? totalPrice;
  DateTime? date;
  String? updatedAt;
  String? createdAt;
  int? id;
  int? status;
  String? statusName;
  DriverData? driverData;
  String? distance;
  String? time;
  int? userEndTrip;

  OrderEntity({
    this.customerId,
    this.driverId,
    this.dropOffLat,
    this.dropOffLong,
    this.pickupLat,
    this.pickupLong,
    this.paymentMethod,
    this.unitPrice,
    this.distancePrice,
    this.quantity,
    this.tax,
    this.delivery,
    this.totalPrice,
    this.date,
    this.status,
    this.statusName,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.driverData,
    this.distance,
    this.userEndTrip,
    this.time,
  });
}
