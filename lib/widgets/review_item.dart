import 'package:flutter/material.dart';
import 'package:the4m_app/models/review_model.dart';
import 'package:the4m_app/utils/app_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          review.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "TenorSans",
          ),
        ),
        SizedBox(height: 4),
        Text(review.date, style: TextStyle(fontFamily: "TenorSans")),
        SizedBox(height: 4),
        buildStars(review.rating),
        SizedBox(height: 6),
        Text(
          "KÍCH CỠ: ${review.size}",
          style: TextStyle(fontSize: 13, fontFamily: "TenorSans"),
        ),
        Text(
          "MÀU SẮC: ${review.color}",
          style: TextStyle(fontSize: 13, fontFamily: "TenorSans"),
        ),
        Text(
          "ĐÁNH GIÁ: ${review.content}",
          style: TextStyle(fontSize: 13, fontFamily: "TenorSans"),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundImage: AssetImage(review.avatarUrl),
            ),
            SizedBox(width: 6),
            Text(
              review.userName,
              style: TextStyle(color: Colors.orange, fontSize: 12),
            ),
          ],
        ),
        Divider(height: 30),
      ],
    );
  }
}
