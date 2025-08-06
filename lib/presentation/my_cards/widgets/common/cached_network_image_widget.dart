import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Resimleri önbellekleme ve gösterme işlemlerini yapan widget.
class CachedNetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BorderRadius? borderRadius;
  final String? heroTag;
  final BoxFit fit;

  const CachedNetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.height = 75,
    this.width = 75,
    this.borderRadius,
    this.heroTag,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _precacheImage(context, imageUrl),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data != true) {
          return _buildShimmerPlaceholder();
        }

        Widget imageContainer = Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: fit,
            ),
          ),
        );

        if (heroTag != null) {
          return Hero(
            tag: heroTag!,
            child: imageContainer,
          );
        }

        return imageContainer;
      },
    );
  }

  Widget _buildShimmerPlaceholder() {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        period: const Duration(milliseconds: 1500),
        child: Container(
          height: height,
          width: width,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<bool> _precacheImage(BuildContext context, String imageUrl) async {
    try {
      final image = NetworkImage(imageUrl);
      await precacheImage(image, context);
      return true;
    } catch (e) {
      debugPrint('Resim yüklenirken hata: $e');
      return false;
    }
  }
}
