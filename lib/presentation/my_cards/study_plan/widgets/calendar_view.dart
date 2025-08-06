import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lexilearnai/core/config/theme/app_color_scheme.dart';

class CompactCalendarView extends StatefulWidget {
  final List<DateTime> selectedDates;
  final Function(DateTime) onDateSelected;  
  final Map<DateTime, int>? dailyCardCounts;
  final DateTime initialDate;

  CompactCalendarView({
    super.key,
    required this.selectedDates,
    required this.onDateSelected,
    this.dailyCardCounts,
    DateTime? initialDate,
  }) : initialDate = initialDate ?? DateTime.now();

  @override
  State<CompactCalendarView> createState() => _CompactCalendarViewState();
}

class _CompactCalendarViewState extends State<CompactCalendarView> {
  late PageController _pageController;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth =
        DateTime(widget.initialDate.year, widget.initialDate.month, 1);
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 8),
        SizedBox(
          height: 320,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              final monthOffset = index - 1;
              final targetMonth = DateTime(
                _currentMonth.year,
                _currentMonth.month + monthOffset,
                1,
              );
              return _buildCalendarMonth(targetMonth);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
        ),
        Text(
          DateFormat.yMMMM('tr_TR').format(_currentMonth),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCalendarMonth(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final firstWeekdayOfMonth = firstDayOfMonth.weekday;

    // Haftanın günleri başlıkları
    final weekdayLabels = ['Pt', 'Sa', 'Çr', 'Pr', 'Cu', 'Ct', 'Pz'];

    return Column(
      children: [
        // Günlerin isimleri
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekdayLabels
              .map((label) => SizedBox(
                    width: 40,
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColorScheme.lightColorScheme.onSurfaceVariant,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        // Takvim günleri
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: 42, // 6 hafta x 7 gün
            itemBuilder: (context, index) {
              // İlk gün öncesi boşluklar
              final adjustedIndex = index - (firstWeekdayOfMonth - 1);

              if (adjustedIndex < 0 || adjustedIndex >= daysInMonth) {
                return const SizedBox();
              }

              final date = DateTime(month.year, month.month, adjustedIndex + 1);
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);

              final isSelected = widget.selectedDates.any((selectedDate) =>
                  selectedDate.year == date.year &&
                  selectedDate.month == date.month &&
                  selectedDate.day == date.day);

              final isToday = date.year == today.year &&
                  date.month == today.month &&
                  date.day == today.day;

              final isPast = date.isBefore(today);

              // Gündeki kart sayısı
              final cardCount = widget.dailyCardCounts?.entries
                      .where((entry) =>
                          entry.key.year == date.year &&
                          entry.key.month == date.month &&
                          entry.key.day == date.day)
                      .fold(0, (prev, element) => prev + element.value) ??
                  0;

              return _CalendarDay(
                date: date,
                isSelected: isSelected,
                isToday: isToday,
                isPast: isPast,
                cardCount: cardCount,
                onTap: () => widget.onDateSelected(date),
              );
            },
          ),
        ),
      ],
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + (page - 1),
        1,
      );
    });
  }
}

class _CalendarDay extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool isPast;
  final int cardCount;
  final VoidCallback onTap;

  const _CalendarDay({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.isPast,
    required this.cardCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dayTextColor = isPast
        ? AppColorScheme.lightColorScheme.onSurfaceVariant.withOpacity(0.5)
        : isSelected
            ? Colors.white
            : isToday
                ? AppColorScheme.lightColorScheme.primary
                : AppColorScheme.lightColorScheme.onSurface;

    return InkWell(
      onTap: isPast ? null : onTap,
      borderRadius: BorderRadius.circular(40),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColorScheme.lightColorScheme.primary
              : isToday
                  ? AppColorScheme.lightColorScheme.primaryContainer
                      .withOpacity(0.3)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(40),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColorScheme.lightColorScheme.primary
                        .withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                color: dayTextColor,
                fontWeight:
                    isToday || isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (cardCount > 0)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white
                      : AppColorScheme.lightColorScheme.secondary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
