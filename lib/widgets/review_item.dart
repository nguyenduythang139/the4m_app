import 'dart:io';
import 'package:flutter/material.dart';
import 'package:the4m_app/models/review_model.dart';

class ReviewItem extends StatelessWidget {
  final Review review;

  const ReviewItem({super.key, required this.review});

  Widget buildStars(int count) {
    return Row(
      children: List.generate(
        count,
        (index) => const Icon(Icons.star, color: Colors.orange, size: 16),
      ),
    );
  }

  Widget buildAvatar(String avatarUrl) {
    if (avatarUrl.startsWith('http')) {
      return CircleAvatar(radius: 10, backgroundImage: NetworkImage(avatarUrl));
    } else if (avatarUrl.startsWith('/')) {
      return CircleAvatar(
        radius: 10,
        backgroundImage: FileImage(File(avatarUrl)),
      );
    } else {
      return CircleAvatar(radius: 10, backgroundImage: AssetImage(avatarUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          review.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "TenorSans",
          ),
        ),
        const SizedBox(height: 4),
        Text(review.date, style: const TextStyle(fontFamily: "TenorSans")),
        const SizedBox(height: 4),
        buildStars(review.rating),
        const SizedBox(height: 6),
        Text(
          "KÍCH CỠ: ${review.size}",
          style: const TextStyle(fontSize: 13, fontFamily: "TenorSans"),
        ),
        Text(
          "MÀU SẮC: ${review.color}",
          style: const TextStyle(fontSize: 13, fontFamily: "TenorSans"),
        ),
        Text(
          "ĐÁNH GIÁ: ${review.content}",
          style: const TextStyle(fontSize: 13, fontFamily: "TenorSans"),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            buildAvatar(review.avatarUrl),
            const SizedBox(width: 6),
            Text(
              review.userName,
              style: const TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ],
        ),
        const Divider(height: 30),
      ],
    );
  }
}
