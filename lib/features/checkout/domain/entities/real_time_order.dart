import 'package:otlob_gas/features/checkout/domain/entities/order.dart';

class RealTimeOrder {
  bool? status;
  String? lat;
  String? long;
  String? time;
  String? message;
  OrderEntity? order;
  RealTimeOrder({
    this.status,
    this.lat,
    this.long,
    this.time,
    this.message,
    this.order,
  });

  RealTimeOrder copyWith({
    bool? status,
    String? lat,
    String? long,
    String? time,
    String? message,
    OrderEntity? order,
  }) {
    return RealTimeOrder(
      status: status ?? this.status,
      lat: lat ?? this.lat,
      long: long ?? this.long,
      time: time ?? this.time,
      message: message ?? this.message,
      order: order ?? this.order,
    );
  }

  @override
  String toString() {
    return 'RealTimeOrder(status: $status, lat: $lat, long: $long, time: $time, message: $message)';
  }

  @override
  bool operator ==(covariant RealTimeOrder other) {
    if (identical(this, other)) return true;

    return other.status == status &&
        other.lat == lat &&
        other.long == long &&
        other.message == message &&
        other.order == order &&
        other.time == time;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        lat.hashCode ^
        long.hashCode ^
        order.hashCode ^
        message.hashCode ^
        time.hashCode;
  }
}
