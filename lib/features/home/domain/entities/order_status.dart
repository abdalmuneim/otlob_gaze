class OrderStatus {
  int totalOrder;
  int orderToday;

  OrderStatus({this.totalOrder = 0, this.orderToday = 0});

  @override
  bool operator ==(covariant OrderStatus other) {
    if (identical(this, other)) return true;

    return other.totalOrder == totalOrder && other.orderToday == orderToday;
  }

  @override
  int get hashCode => totalOrder.hashCode ^ orderToday.hashCode;
}
