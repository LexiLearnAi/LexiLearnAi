import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lexilearnai/core/config/theme/app_color_scheme.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';
import 'package:lexilearnai/presentation/my_cards/study_plan/cubit/study_plan_cubit.dart';
import 'package:lexilearnai/presentation/my_cards/study_plan/cubit/study_plan_state.dart';
import 'package:lexilearnai/presentation/my_cards/study_plan/widgets/plan_preview.dart';

class StudyPlanSheet {
  Future<Map<DateTime, List<CardEntity>>?> show(
    BuildContext context,
    List<CardEntity> selectedCards,
  ) async {
    final size = MediaQuery.of(context).size;

    return await showModalBottomSheet<Map<DateTime, List<CardEntity>>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StudyPlanBottomSheet(
        selectedCards: selectedCards,
        size: size,
      ),
    );
  }
}

class _StudyPlanBottomSheet extends StatefulWidget {
  final List<CardEntity> selectedCards;
  final Size size;

  const _StudyPlanBottomSheet({
    required this.selectedCards,
    required this.size,
  });

  @override
  State<_StudyPlanBottomSheet> createState() => _StudyPlanBottomSheetState();
}

class _StudyPlanBottomSheetState extends State<_StudyPlanBottomSheet> {
  bool _isSecondStep = false;
  bool _showInfoCard = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StudyPlanCubit()..initializePlan(widget.selectedCards),
      child: BlocConsumer<StudyPlanCubit, StudyPlanState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                behavior: SnackBarBehavior.floating,
              ),
            );

            context.read<StudyPlanCubit>().clearError();
          }
        },
        builder: (context, state) {
          return Container(
            height: widget.size.height * 0.75,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                _buildHandle(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildHeader(context, state),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Expanded(
                  child: _isSecondStep
                      ? _buildPlanPreview(context, state)
                      : _buildDateSelection(context, state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, StudyPlanState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        Text(
          _isSecondStep ? 'Kelime Çalışma Planı' : 'Çalışma Günlerini Seç',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            if (!_isSecondStep)
              IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: AppColorScheme.lightColorScheme.primary,
                  size: 20,
                ),
                tooltip: 'Plan Bilgisi',
                onPressed: () {
                  setState(() {
                    _showInfoCard = !_showInfoCard;
                  });
                },
              ),
            _buildSelectedCardCounter(context, state),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedCardCounter(BuildContext context, StudyPlanState state) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColorScheme.lightColorScheme.primary.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '${state.totalSelectedCards}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColorScheme.lightColorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelection(BuildContext context, StudyPlanState state) {
    final dailyCardCounts = <DateTime, int>{};

    // Plan oluşturulduysa tarihlere göre kart sayılarını hazırla
    if (state.dailyPlans.isNotEmpty) {
      for (final entry in state.dailyPlans.entries) {
        dailyCardCounts[entry.key] = entry.value.length;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bilgilendirme metni (info butonu ile açılıp kapanabilen)
          if (_showInfoCard && state.selectedCards.length <= 5)
            _buildInfoCard(state),
          // Kompakt takvim
          SizedBox(
            height: 250,
            child: _buildCompactCalendar(context, state, dailyCardCounts),
          ),
          const SizedBox(height: 12),
          // Hızlı seçim butonları ve temizle butonu
          _buildActionButtons(context, state),
          const SizedBox(height: 24),
          _buildSelectedDateInfo(context, state),
          const Spacer(),
          _buildBottomButtons(context, state),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInfoCard(StudyPlanState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        color:
            AppColorScheme.lightColorScheme.primaryContainer.withOpacity(0.2),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.tips_and_updates_outlined,
                    color: AppColorScheme.lightColorScheme.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'İpuçları',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColorScheme.lightColorScheme.primary,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _showInfoCard = false;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Icon(
                      Icons.close,
                      size: 14,
                      color: AppColorScheme.lightColorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColorScheme.lightColorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Max ${state.selectedCards.length} gün seçin',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColorScheme.lightColorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '•',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColorScheme.lightColorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'İdeal: Her güne bir kelime',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColorScheme.lightColorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCalendar(BuildContext context, StudyPlanState state,
      Map<DateTime, int> dailyCardCounts) {
    final now = DateTime.now();

    // Gelecek 14 günü göster (2 hafta)
    final visibleDates = List.generate(
        14, (index) => DateTime(now.year, now.month, now.day + index));

    return Column(
      children: [
        // Başlık
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${DateFormat.MMMM('tr_TR').format(now)} - ${DateFormat.MMMM('tr_TR').format(now.add(const Duration(days: 13)))}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Günler
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1, // Kare gün hücreleri
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: 14, // Sadece 14 gün göster
            itemBuilder: (context, index) {
              final date = visibleDates[index];
              final isSelected = state.isDateSelected(date);
              final isToday = date.day == now.day &&
                  date.month == now.month &&
                  date.year == now.year;

              return InkWell(
                onTap: () =>
                    context.read<StudyPlanCubit>().toggleDateSelection(date),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColorScheme.lightColorScheme.primary
                        : (isToday
                            ? AppColorScheme.lightColorScheme.primaryContainer
                                .withOpacity(0.2)
                            : AppColorScheme
                                .lightColorScheme.surfaceContainerLow),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColorScheme.lightColorScheme.primary
                                  .withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Gün adı
                      Text(
                        DateFormat('E', 'tr_TR').format(date).substring(0, 1),
                        style: TextStyle(
                          fontSize: 10,
                          color: isSelected
                              ? Colors.white.withOpacity(0.8)
                              : AppColorScheme
                                  .lightColorScheme.onSurfaceVariant,
                        ),
                      ),
                      // Gün sayısı
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : AppColorScheme.lightColorScheme.onSurface,
                        ),
                      ),
                      // Kart sayısı göstergesi
                      if (dailyCardCounts[date] != null)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : AppColorScheme.lightColorScheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, StudyPlanState state) {
    final availableDays =
        state.selectedCards.length; // Seçilebilecek maksimum gün

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Temizle ve Hızlı Seçim başlıkları
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hızlı Seçim',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColorScheme.lightColorScheme.onSurfaceVariant,
              ),
            ),
            TextButton.icon(
              onPressed: state.selectedDates.isEmpty
                  ? null
                  : () => context.read<StudyPlanCubit>().resetSelectedDates(),
              icon: Icon(
                Icons.cleaning_services_outlined,
                size: 16,
                color: state.selectedDates.isEmpty
                    ? AppColorScheme.lightColorScheme.onSurfaceVariant
                        .withOpacity(0.5)
                    : AppColorScheme.lightColorScheme.error,
              ),
              label: Text(
                'Temizle',
                style: TextStyle(
                  fontSize: 12,
                  color: state.selectedDates.isEmpty
                      ? AppColorScheme.lightColorScheme.onSurfaceVariant
                          .withOpacity(0.5)
                      : AppColorScheme.lightColorScheme.error,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Yeni hızlı seçim butonları
        Row(
          children: [
            Expanded(
              child: _ActionChip(
                label: 'Bugünden Başla',
                icon: Icons.today,
                color: AppColorScheme.lightColorScheme.primary,
                onTap: () {
                  final now = DateTime.now();
                  // Reset the selection first
                  context.read<StudyPlanCubit>().resetSelectedDates();

                  // Add days up to available cards count
                  for (int i = 0; i < availableDays; i++) {
                    final date = now.add(Duration(days: i));
                    context.read<StudyPlanCubit>().toggleDateSelection(date);
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ActionChip(
                label: 'Hafta içi',
                icon: Icons.work_outline,
                color: AppColorScheme.lightColorScheme.secondary,
                onTap: () {
                  context
                      .read<StudyPlanCubit>()
                      .selectSmartWeekdays(availableDays);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ActionChip(
                label: 'Hafta sonu',
                icon: Icons.weekend_outlined,
                color: AppColorScheme.lightColorScheme.tertiary,
                onTap: () {
                  context
                      .read<StudyPlanCubit>()
                      .selectSmartWeekends(availableDays);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectedDateInfo(BuildContext context, StudyPlanState state) {
    if (state.selectedDates.isEmpty) {
      return const SizedBox(height: 8); // Boş bir alan bırak
    }

    // Seçili tarih sayısını ve günlük kelime oranını hesapla
    final double cardsPerDay = state.selectedCards.length /
        (state.selectedDates.isEmpty ? 1 : state.selectedDates.length);

    // Renge göre durumu belirle
    final bool isOptimal =
        state.selectedDates.length == state.selectedCards.length;
    final bool isTooMany =
        state.selectedDates.length > state.selectedCards.length;

    // Durum rengi
    final Color statusColor = isOptimal
        ? AppColorScheme.lightColorScheme.tertiary
        : (isTooMany
            ? AppColorScheme.lightColorScheme.error
            : AppColorScheme.lightColorScheme.primary);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          // Seçili tarih bilgisi (daha kompakt)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Seçili: ',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColorScheme.lightColorScheme.onSurfaceVariant,
                      ),
                    ),
                    TextSpan(
                      text: '${state.selectedDates.length} gün',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColorScheme.lightColorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: statusColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  'Günde ~${cardsPerDay.ceil()} kart',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // İlerleme çubuğu
          LinearProgressIndicator(
            value: state.selectedDates.length / state.selectedCards.length,
            backgroundColor:
                AppColorScheme.lightColorScheme.surfaceContainerLowest,
            color: statusColor,
            borderRadius: BorderRadius.circular(2),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, StudyPlanState state) {
    // Tarih seçilmemişse veya seçilen tarih sayısı kart sayısını aşıyorsa buton devre dışı
    final bool isDisabled = state.selectedDates.isEmpty ||
        state.selectedDates.length > state.selectedCards.length;

    String? warningText;
    if (state.selectedDates.isEmpty) {
      warningText = 'Lütfen en az bir gün seçin';
    } else if (state.selectedDates.length > state.selectedCards.length) {
      warningText = 'Seçilen gün sayısı kart sayısını aşamaz';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (warningText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              warningText,
              style: TextStyle(
                color: AppColorScheme.lightColorScheme.error,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isDisabled
                    ? null
                    : () {
                        context
                            .read<StudyPlanCubit>()
                            .generatePlanForSelectedDates();
                        setState(() {
                          _isSecondStep = true;
                        });
                      },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Devam Et'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColorScheme.lightColorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlanPreview(BuildContext context, StudyPlanState state) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: PlanPreview(
        dailyPlans: state.dailyPlans,
        onEdit: () {
          setState(() {
            _isSecondStep = false;
          });
        },
        onComplete: () {
          Navigator.of(context).pop(state.dailyPlans);
        },
      ),
    );
  }
}

// Yeni tasarlanmış aksiyon butonu
class _ActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: color,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
