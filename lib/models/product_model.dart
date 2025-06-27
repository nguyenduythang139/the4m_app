class Products {
  final String name;
  final String imageUrl;
  final int price;
  final bool isFavorite;

  Products({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.isFavorite = false,
  });

  factory Products.fromMap(Map<String, dynamic> data) {
    return Products(
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: data['price'] ?? 0,
      isFavorite: data['isFavorite'] ?? false,
    );
  }
}
