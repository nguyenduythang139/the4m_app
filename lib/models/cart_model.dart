class Cart {
  final String productImage;
  final String productName;
  final String productColor;
  final String productSize;
  final int productPrice;
  final int productQuantity;

  Cart({
    required this.productImage,
    required this.productName,
    required this.productColor,
    required this.productSize,
    required this.productPrice,
    required this.productQuantity,
  });

  factory Cart.fromMap(Map<String, dynamic> data) {
    return Cart(
      productImage: data['productImage'] ?? '',
      productName: data['productName'] ?? '',
      productColor: data['productColor'] ?? '',
      productSize: data['productSize'] ?? '',
      productPrice: data['productPrice'] ?? '',
      productQuantity: data['productQuantity'] ?? '',
    );
  }
}
