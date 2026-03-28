class Product {
  final int id;
  final String name;
  final String price;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String rawPrice = json['prices']?['price'] ?? "0";

    double finalPrice = (double.tryParse(rawPrice) ?? 0) / 100;

    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      price: finalPrice.toStringAsFixed(0),
      image: (json['images'] != null && json['images'].isNotEmpty)
          ? json['images'][0]['src']
          : "",
    );
  }
}