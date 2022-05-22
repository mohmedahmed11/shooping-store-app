import 'CategoryModel.dart';

class Product {
  final int id;
  final String name;
  final int categoryId;
  final String image;
  final String code;
  final int quantity;
  final int status;
  final int price;
  late int count = 1;
  final String details;
  final List<ProductImage> images;
  final List<ProductProparety> properties;
  final CategoryModel? category;
  final ProductOffer? offer;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.categoryId,
    required this.code,
    required this.quantity,
    required this.status,
    required this.price,
    required this.details,
    required this.images,
    required this.properties,
    required this.category,
    required this.offer,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      categoryId: json['category_id'],
      code: json['code'],
      quantity: json['quantity'],
      status: json['status'],
      price: json['price'],
      details: json['details'],
      images: json['images']
          .map<ProductImage>((json) => ProductImage.fromJson(json))
          .toList(),
      properties: json['properties']
          .map<ProductProparety>((json) => ProductProparety.fromJson(json))
          .toList(),
      category: CategoryModel.fromJson(json['category']),
      offer:
          json['offer'] != null ? ProductOffer.fromJson(json['offer']) : null,
    );
  }
}

class ProductImage {
  final int id;
  final int productId;
  final String image;
  ProductImage({
    required this.id,
    required this.productId,
    required this.image,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      productId: json['product_id'],
      image: json['image'],
    );
  }
}

class ProductProparety {
  final int id;
  final String name;
  final String value;
  final String type;
  ProductProparety({
    required this.id,
    required this.name,
    required this.type,
    required this.value,
  });

  factory ProductProparety.fromJson(Map<String, dynamic> json) {
    return ProductProparety(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      value: json['property_value'],
    );
  }
}

class ProductOffer {
  final int id;
  final int items;
  final int present;
  ProductOffer({
    required this.id,
    required this.items,
    required this.present,
  });

  factory ProductOffer.fromJson(Map<String, dynamic> json) {
    return ProductOffer(
      id: json['id'],
      items: json['items'],
      present: json['present'],
    );
  }
}
