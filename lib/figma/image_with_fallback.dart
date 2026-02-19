import 'package:flutter/material.dart';

class ImageWithFallback extends StatelessWidget {
  final String? imageUrl;
  final String? assetFallback;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ImageWithFallback({this.imageUrl, this.assetFallback, this.width, this.height, this.fit = BoxFit.cover, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildFallback();
    }

    return Image.network(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildFallback(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          width: width,
          height: height,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildFallback() {
    if (assetFallback != null) {
      return Image.asset(assetFallback!, width: width, height: height, fit: fit);
    }
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Icon(Icons.image, size: (width ?? 48) / 2, color: Colors.grey[600]),
    );
  }
}
