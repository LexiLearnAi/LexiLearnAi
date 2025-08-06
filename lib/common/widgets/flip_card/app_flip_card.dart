import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lexilearnai/core/config/constants/app_colors.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';

class AppFlipCard extends StatefulWidget {
  final CardEntity card;

  const AppFlipCard({
    super.key,
    required this.card,
  });

  @override
  State<AppFlipCard> createState() => _AppFlipCardState();
}

class _AppFlipCardState extends State<AppFlipCard> {
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      fill: Fill.fillBack,
      direction: FlipDirection.HORIZONTAL,
      speed: 400,
      front: _CardFrontSide(card: widget.card),
      back: _CardBackSide(card: widget.card),
    );
  }
}

class _CardFrontSide extends StatelessWidget {
  final CardEntity card;

  const _CardFrontSide({
    required this.card,
  });


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.5,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context)
                .colorScheme
                .shadow
                .withValues(alpha: AppColors.kAlphaShadow),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              if (card.types[0].photo != null)
                _CardImage(
                  photo: card.types[0].photo ?? '',
                  word: card.word,
                  type: card.types[0].type,
                  level: card.types[0].level,
                  height: constraints.maxHeight * 0.45,
                ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _CardHeader(
                        word: card.word,
                      ),
                      _CardDefinition(
                        definition: card.types[0].definition.first,
                      ),
                      const SizedBox(height: 12),
                      _CardInfo(
                        level: card.types[0].level,
                      ),
                      const _FlipHint(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CardBackSide extends StatelessWidget {
  final CardEntity card;

  const _CardBackSide({
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.5,
      width: size.width * 0.8,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context)
                .colorScheme
                .shadow
                .withValues(alpha: AppColors.kAlphaShadow),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (card.types.isNotEmpty) ...[
            _ExampleSentences(
              sentences: card.types[0].sentence,
              word: card.word,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _WordNetwork(
                synonyms: card.types[0].synonym,
              ),
            ),
            const _FlipHint(),
          ],
        ],
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  final String photo;
  final String? mediumPhoto;
  final String? smallPhoto;
  final String word;
  final String type;
  final String level;
  final double height;

  const _CardImage({
    required this.photo,
    this.mediumPhoto,
    this.smallPhoto,
    required this.word,
    required this.type,
    required this.level,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        children: [
          Hero(
            tag: word,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              child: CachedNetworkImage(
                imageUrl: photo,
                width: double.infinity,
                height: height,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: AppColors.kAlphaOverlay),
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
          ),
          _CardBadge(
            text: type,
            alignment: Alignment.topLeft,
          ),
          _CardBadge(
            text: level,
            alignment: Alignment.topRight,
          ),
        ],
      ),
    );
  }
}

class _CardBadge extends StatelessWidget {
  final String text;
  final Alignment alignment;

  const _CardBadge({
    required this.text,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      left: alignment == Alignment.topLeft ? 12 : null,
      right: alignment == Alignment.topRight ? 12 : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surface
              .withValues(alpha: AppColors.kAlphaOverlay),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String word;
  final String? ipa;

  const _CardHeader({
    required this.word,
    this.ipa,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  word,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                if (ipa != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withValues(alpha: AppColors.kAlphaContainer),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ipa!,
                      style: GoogleFonts.notoSans(
                        textStyle:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: AppColors.kAlphaText),
                                ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          _SoundButton(),
        ],
      ),
    );
  }
}

class _SoundButton extends StatelessWidget {
  const _SoundButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer
            .withValues(alpha: AppColors.kAlphaContainer),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {
          // TTS implementation will be added here
        },
        icon: Icon(
          Icons.volume_up_rounded,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
      ),
    );
  }
}

class _CardDefinition extends StatelessWidget {
  final String definition;

  const _CardDefinition({
    required this.definition,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        definition,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: AppColors.kAlphaText),
              height: 1.4,
            ),
      ),
    );
  }
}

class _CardInfo extends StatelessWidget {
  final String? level;

  const _CardInfo({
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Row(
        children: [
          Expanded(
            child: _InfoCard(
              title: 'flipCard.formality'.tr(),
              value: level ?? 'flipCard.frequencyLevels.normal'.tr(),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _InfoCard(
              title: 'flipCard.frequency'.tr(),
              value: level ?? 'flipCard.frequencyLevels.normal'.tr(),
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppColors.kAlphaCard),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}

class _FlipHint extends StatelessWidget {
  const _FlipHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .surface
              .withValues(alpha: AppColors.kAlphaOverlay),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .outline
                .withValues(alpha: AppColors.kAlphaCard),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.touch_app_rounded,
              size: 14,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: AppColors.kAlphaHint),
            ),
            const SizedBox(width: 4),
            Text(
              'flipCard.tapToFlip'.tr(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: AppColors.kAlphaHint),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExampleSentences extends StatelessWidget {
  final List<String> sentences;
  final String word;

  const _ExampleSentences({
    required this.sentences,
    required this.word,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'flipCard.exampleSentences'.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: AppColors.kAlphaText),
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Text.rich(
          TextSpan(
            children:
                _buildHighlightedSentence(context, sentences.join("\n"), word),
          ),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                height: 1.5,
              ),
        ),
      ],
    );
  }

  List<TextSpan> _buildHighlightedSentence(
      BuildContext context, String sentence, String word) {
    final List<TextSpan> spans = [];
    final RegExp regex = RegExp(
      '\\b$word(?:s|ed|ing|es)?\\b',
      caseSensitive: false,
    );
    int start = 0;

    for (final Match match in regex.allMatches(sentence)) {
      if (match.start > start) {
        spans.add(TextSpan(text: sentence.substring(start, match.start)));
      }
      spans.add(TextSpan(
        text: sentence.substring(match.start, match.end),
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ));
      start = match.end;
    }

    if (start < sentence.length) {
      spans.add(TextSpan(text: sentence.substring(start)));
    }

    return spans;
  }
}

class _WordNetwork extends StatelessWidget {
  final List<String> synonyms;  

  const _WordNetwork({
    required this.synonyms,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (synonyms.isNotEmpty) ...[
            _WordSection(
              title: 'flipCard.synonyms'.tr(),
              words: synonyms,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
          ],
              
          
        ],
      ),
    );
  }
}

class _WordSection extends StatelessWidget {
  final String title;
  final List<String> words;
  final Color color;

  const _WordSection({
    required this.title,
    required this.words,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: AppColors.kAlphaText),
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              words.map((word) => _WordChip(word: word, color: color)).toList(),
        ),
      ],
    );
  }
}

class _WordChip extends StatelessWidget {
  final String word;
  final Color color;

  const _WordChip({
    required this.word,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppColors.kAlphaCard),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        word,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
