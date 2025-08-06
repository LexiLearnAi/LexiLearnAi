import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lexilearnai/core/config/theme/app_color_scheme.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';
import 'package:lexilearnai/presentation/my_cards/study_plan/cubit/study_plan_cubit.dart';

class PlanPreview extends StatelessWidget {
  final Map<DateTime, List<CardEntity>> dailyPlans;
  final VoidCallback onEdit;
  final VoidCallback onComplete;

  const PlanPreview({
    super.key,
    required this.dailyPlans,
    required this.onEdit,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    // Tarihleri sırala
    final sortedDates = dailyPlans.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    if (sortedDates.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 56,
              color: AppColorScheme.lightColorScheme.onSurfaceVariant
                  .withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Henüz bir plan oluşturulmadı',
              style: TextStyle(
                fontSize: 16,
                color: AppColorScheme.lightColorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Özet bilgisi
        _buildPlanSummary(context),

        // İpucu
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: AppColorScheme.lightColorScheme.primary,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Kelimeleri taşımak için sağdaki takvim simgesine dokunun',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColorScheme.lightColorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Günlük plan listesi
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            itemCount: sortedDates.length,
            itemBuilder: (context, index) {
              final date = sortedDates[index];
              final cards = dailyPlans[date] ?? [];

              return _DayPlanCard(
                date: date,
                cards: cards,
                availableDates: sortedDates,
                onMoveCard: (sourceDate, targetDate, card) {
                  context.read<StudyPlanCubit>().movePlanItem(
                        sourceDate,
                        targetDate,
                        card,
                      );
                },
              );
            },
          ),
        ),

        // Butonlar
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onEdit,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      foregroundColor:
                          AppColorScheme.lightColorScheme.onSurface,
                      side: BorderSide(
                        color: AppColorScheme.lightColorScheme.outline
                            .withOpacity(0.5),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Geri Dön',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: onComplete,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColorScheme.lightColorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Kaydet',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanSummary(BuildContext context) {
    final totalDays = dailyPlans.keys.length;
    final totalCards =
        dailyPlans.values.fold(0, (sum, cards) => sum + cards.length);
    final startDate = dailyPlans.keys.isEmpty
        ? DateTime.now()
        : (dailyPlans.keys.toList()..sort()).first;
    final endDate = dailyPlans.keys.isEmpty
        ? DateTime.now()
        : (dailyPlans.keys.toList()..sort()).last;

    return Card(
      elevation: 0,
      color: AppColorScheme.lightColorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık ve tarih aralığı
            Row(
              children: [
                Icon(
                  Icons.date_range,
                  size: 20,
                  color: AppColorScheme.lightColorScheme.primary,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Çalışma Planı',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${DateFormat("d MMM", "tr_TR").format(startDate)} - ${DateFormat("d MMM", "tr_TR").format(endDate)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // İstatistikler
            Row(
              children: [
                _SummaryItem(
                  icon: Icons.calendar_today,
                  value: '$totalDays',
                  label: 'Gün',
                ),
                _SummaryItem(
                  icon: Icons.school,
                  value: '$totalCards',
                  label: 'Kelime',
                ),
                if (totalDays > 0)
                  _SummaryItem(
                    icon: Icons.speed,
                    value: '~${(totalCards / totalDays).ceil()}',
                    label: 'Günlük',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColorScheme.lightColorScheme.primary,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColorScheme.lightColorScheme.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayPlanCard extends StatelessWidget {
  final DateTime date;
  final List<CardEntity> cards;
  final List<DateTime> availableDates;
  final Function(DateTime, DateTime, CardEntity) onMoveCard;

  const _DayPlanCard({
    required this.date,
    required this.cards,
    required this.availableDates,
    required this.onMoveCard,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    // Tarih formatı
    final dayName = DateFormat('EEEE', 'tr_TR').format(date);
    final dayNumber = DateFormat('d', 'tr_TR').format(date);
    final monthName = DateFormat('MMMM', 'tr_TR').format(date);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isToday
              ? AppColorScheme.lightColorScheme.primary.withOpacity(0.3)
              : AppColorScheme.lightColorScheme.outline.withOpacity(0.1),
          width: isToday ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tarih başlığı
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isToday
                  ? AppColorScheme.lightColorScheme.primary.withOpacity(0.08)
                  : Colors.transparent,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Tarih gösterimi
                Text(
                  dayNumber,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isToday
                        ? AppColorScheme.lightColorScheme.primary
                        : AppColorScheme.lightColorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 12),

                // Gün ve ay bilgisi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dayName,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isToday
                              ? AppColorScheme.lightColorScheme.primary
                              : AppColorScheme.lightColorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        monthName,
                        style: TextStyle(
                          fontSize: 13,
                          color:
                              AppColorScheme.lightColorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Kelime sayısı ve bugün etiketi
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isToday)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColorScheme.lightColorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Bugün',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    const SizedBox(height: 4),
                    Text(
                      '${cards.length} kelime',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColorScheme.lightColorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (cards.isNotEmpty) ...[
            // Kelime listesi
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cards.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              itemBuilder: (context, index) {
                final card = cards[index];
                return _WordItem(
                  card: card,
                  currentDate: date,
                  availableDates: availableDates,
                  onMoveToDate: (targetDate) {
                    onMoveCard(date, targetDate, card);
                  },
                );
              },
            ),
          ] else ...[
            // Boş durum
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'Bu günde hiç kelime yok',
                  style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: AppColorScheme.lightColorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WordItem extends StatelessWidget {
  final CardEntity card;
  final DateTime currentDate;
  final List<DateTime> availableDates;
  final Function(DateTime) onMoveToDate;

  const _WordItem({
    required this.card,
    required this.currentDate,
    required this.availableDates,
    required this.onMoveToDate,
  });

  @override
  Widget build(BuildContext context) {
    // Kelime için tür/tanım
    final typeInfo = card.types.isNotEmpty
        ? '${card.types.first.type}: ${card.types.first.definition.isNotEmpty ? card.types.first.definition.first : ''}'
        : '';

    // Kelime seviyesi
    final wordLevel = card.types.isNotEmpty ? card.types.first.level : '';

    return InkWell(
      onLongPress: () => _showMoveToDateDialog(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Kelime içeriği
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          card.word,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (wordLevel.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColorScheme
                                .lightColorScheme.tertiaryContainer
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            wordLevel,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: AppColorScheme.lightColorScheme.tertiary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (typeInfo.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      typeInfo,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColorScheme.lightColorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Taşıma butonu
            IconButton(
              icon: const Icon(Icons.calendar_month, size: 20),
              onPressed: () => _showMoveToDateDialog(context),
              tooltip: 'Başka güne taşı',
              style: IconButton.styleFrom(
                foregroundColor: AppColorScheme.lightColorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoveToDateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.calendar_month,
              color: AppColorScheme.lightColorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Kelimeyi Taşı',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                card.word,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: availableDates.length,
                  itemBuilder: (context, index) {
                    final targetDate = availableDates[index];
                    final isSameDay = targetDate.year == currentDate.year &&
                        targetDate.month == currentDate.month &&
                        targetDate.day == currentDate.day;

                    final isToday = DateTime.now().day == targetDate.day &&
                        DateTime.now().month == targetDate.month &&
                        DateTime.now().year == targetDate.year;

                    if (isSameDay) {
                      return const SizedBox.shrink(); // Mevcut günü gösterme
                    }

                    final formattedDate =
                        DateFormat('EEEE, d MMMM', 'tr_TR').format(targetDate);

                    return ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: isToday
                            ? AppColorScheme.lightColorScheme.primary
                            : AppColorScheme.lightColorScheme.onSurfaceVariant,
                      ),
                      title: Text(
                        formattedDate,
                        style: TextStyle(
                          fontWeight:
                              isToday ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 14,
                          color: isToday
                              ? AppColorScheme.lightColorScheme.primary
                              : AppColorScheme.lightColorScheme.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: isToday
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColorScheme.lightColorScheme.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Bugün',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : null,
                      onTap: () {
                        onMoveToDate(targetDate);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
        ],
      ),
    );
  }
}
