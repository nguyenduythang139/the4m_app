import 'package:flutter/material.dart';

class TitleWithDivider extends StatelessWidget {
  final String title;
  final double letterSpacing;
  final double lineWidth;
  final Color dividerColor;
  final Color diamondColor;
  final double diamondSize;

  const TitleWithDivider({
    super.key,
    required this.title,
    this.letterSpacing = 4.0,
    this.lineWidth = 125,
    this.dividerColor = const Color(0xFFBDBDBD),
    this.diamondColor = Colors.white,
    this.diamondSize = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, letterSpacing: letterSpacing),
        ),
        SizedBox(height: 2),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(height: 1, width: lineWidth, color: dividerColor),
            Container(
              margin: EdgeInsets.only(bottom: 3),
              width: diamondSize,
              height: diamondSize,
              decoration: BoxDecoration(
                color: diamondColor,
                border: Border.all(color: dividerColor),
              ),
              transform: Matrix4.rotationZ(0.785398),
            ),
          ],
        ),
      ],
    );
  }
}
