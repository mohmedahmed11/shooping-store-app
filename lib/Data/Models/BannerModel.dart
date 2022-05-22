class SliderImage {
  final int id;
  final int productId;
  final String image;
  SliderImage({
    required this.id,
    required this.productId,
    required this.image,
  });

  factory SliderImage.fromJson(Map<String, dynamic> json) {
    return SliderImage(
      id: json['id'],
      productId: json['product_id'],
      image: json['image'],
    );
  }
}
