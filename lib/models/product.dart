class Product {
  final String name;
  final String imagePath;
  final String price;

  Product({required this.name, required this.imagePath, required this.price});
}

List<Product> products = [
  Product(
    name: 'Áo thun cotton jersey regular fit',
    imagePath: 'lib/assets/images/product_1.png',
    price: '300.000 vnđ',
  ),
  Product(
    name: 'Áo polo cotton mercerized',
    imagePath: 'lib/assets/images/product_2.png',
    price: '270.000 vnđ',
  ),
  Product(
    name: 'Áo polo Paddy vải cotton jacquard',
    imagePath: 'lib/assets/images/product_4.png',
    price: '250.000 vnđ',
  ),
  Product(
    name: 'Áo thun cotton jersey regular fit',
    imagePath: 'lib/assets/images/product_5.png',
    price: '300.000 vnđ',
  ),
  Product(
    name: 'Áo polo cotton mercerized',
    imagePath: 'lib/assets/images/product_6.png',
    price: '270.000 vnđ',
  ),
  Product(
    name: 'Áo polo Paddy vải cotton jacquard',
    imagePath: 'lib/assets/images/product_7.png',
    price: '250.000 vnđ',
  ),
];
