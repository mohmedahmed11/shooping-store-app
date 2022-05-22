// "user_id": 0,
//   "lat": 0.3443,
//   "lng": 12.9843,
//   "total": 15000,
//   "delivery_cost": 1500,
//   "delivery_period": "dfdf",
//   "items_count": "10",
//   "note": "note",
//   "updated_at": "2022-05-21T11:27:03.000000Z",
//   "created_at": "2022-05-21T11:27:03.000000Z",
//   "id": 14,
//   "items": [
//       {
//           "order_id": 14,
//           "product_id": 1,
//           "count": 2,
//           "id": 3
//       },
//       {
//           "order_id": 14,
//           "product_id": 2,
//           "count": 1,
//           "id": 4
//       },
//       {
//           "order_id": 14,
//           "product_id": 3,
//           "count": 3,
//           "id": 5
//       }
//   ]

class Order {
  final int id;
  final double lat;
  final double lng;
  final int total;
  final int delivaryCost;
  final String deliveryPeriod;
  final int itemsCount;
  final String note;
  final String createdAt;
  final List<OrderItem> items;
  Order(
      {required this.id,
      required this.lat,
      required this.lng,
      required this.total,
      required this.delivaryCost,
      required this.deliveryPeriod,
      required this.itemsCount,
      required this.note,
      required this.createdAt,
      required this.items});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        id: json['id'],
        lat: json['lat'],
        lng: json['lng'],
        total: json['total'],
        delivaryCost: json['delivery_cost'],
        deliveryPeriod: json['delivery_period'],
        itemsCount: json['items_count'],
        note: json['note'],
        createdAt: json['created_at'],
        items: json['items']
            .map<OrderItem>((json) => OrderItem.fromJson(json))
            .toList());
  }
}

class OrderItem {
  final int id;
  final int productId;
  final int orderId;
  final int count;

  OrderItem({
    required this.id,
    required this.productId,
    required this.orderId,
    required this.count,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productId: json['product_id'],
      orderId: json['order_id'],
      count: json['count'],
    );
  }
}
