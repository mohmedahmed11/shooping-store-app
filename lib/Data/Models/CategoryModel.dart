class CategoryModel {
  final int id;
  final String name;
  final String image;
  CategoryModel({
    required this.name,
    required this.id,
    required this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

// "id": 1,
// "name": "نظارة شمسية",
// "category_id": 2,
// "image": "img/cat1-2345445.jpg",
// "code": "s34334",
// "price": 300,
// "quantity": 10,
// "status": 1,
// "x": 0,
// "created_at": "2022-05-14 10:07:48",
// "updated_at": "0000-00-00 00:00:00",
// "images": [],
// "properties": []

