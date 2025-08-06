import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lexilearnai/core/config/theme/app_color_scheme.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';
import 'package:lexilearnai/presentation/my_cards/widgets/common/tag_chip.dart';
import 'package:shimmer/shimmer.dart';

/// Kart listesinde gösterilen tekil kart bileşeni.
class CardItem extends StatelessWidget {
  final CardEntity card;
  final VoidCallback? onTap;
  final bool disableTapAnimation;

  const CardItem({
    super.key,
    required this.card,
    this.onTap,
    this.disableTapAnimation = false,
  });

  @override
  Widget build(BuildContext context) {
    if (card.types.isEmpty || card.types.first.photo == null) {
      return const SizedBox.shrink();
    }

    // Öncelikle smallPhoto'yu kullan, yoksa orijinal photo'yu kullan
    final imageUrl = card.types.first.photo ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          splashFactory: disableTapAnimation ? NoSplash.splashFactory : null,
          highlightColor: disableTapAnimation ? Colors.transparent : null,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resim (sol tarafta) - CachedNetworkImage kullanılıyor
                Hero(
                  tag: 'card_image_${card.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 75,
                      width: 75,
                      fit: BoxFit.cover,
                      memCacheHeight: 150,
                      memCacheWidth: 150,
                      errorListener: (error) =>
                          debugPrint('Resim yükleme hatası: $error'),
                      placeholder: (context, url) =>
                          _buildLoadingImagePlaceholder(),
                      errorWidget: (context, url, error) => Container(
                        height: 75,
                        width: 75,
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.error_outline,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // İçerik (sağ tarafta)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        card.word,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (card.types.isNotEmpty &&
                          card.types.first.definition.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          card.types.first.definition.first,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          TagChip(
                            text: card.types.first.type,
                            backgroundColor: AppColorScheme
                                .lightColorScheme.primary
                                .withOpacity(0.1),
                            textColor: AppColorScheme.lightColorScheme.primary,
                          ),
                          const SizedBox(width: 6),
                          TagChip(
                            text: card.types.first.level,
                            backgroundColor: AppColorScheme
                                .lightColorScheme.secondary
                                .withOpacity(0.1),
                            textColor:
                                AppColorScheme.lightColorScheme.secondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // İleri ok ikonu
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingImagePlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: const Duration(milliseconds: 1500),
      child: Container(
        height: 75,
        width: 75,
        color: Colors.white,
      ),
    );
  }
}
