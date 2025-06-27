import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:intl/intl.dart';

class ProductItem extends StatelessWidget {
  final Products product;

  const ProductItem({super.key, required this.product});

  String formatCurrency(int amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'VNĐ');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.asset(product.imageUrl, fit: BoxFit.cover),
            ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Icon(Icons.favorite_border, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(product.name, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          formatCurrency(product.price),
          style: const TextStyle(
            color: Colors.deepOrange,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
