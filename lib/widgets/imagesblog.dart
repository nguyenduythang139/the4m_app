import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BoxFit fit;
  final double borderRadius;
  final bool isAsset;

  const ImageWidget({
    super.key,
    required this.imageUrl,
    this.height = 800,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
    this.borderRadius = 16,
    this.isAsset = false,
  });

  @override
  Widget build(BuildContext context) {
    final image =
        isAsset
            ? Image.asset(imageUrl, fit: fit, height: height, width: width)
            : Image.network(
              imageUrl,
              fit: fit,
              height: height,
              width: width,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return SizedBox(
                  height: height,
                  width: width,
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            );

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: image,
    );
  }
}
