import 'package:equatable/equatable.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';

enum CalendarViewMode { compact, twoWeek, month }

class StudyPlanState extends Equatable {
  final bool isLoading;
  final List<CardEntity> selectedCards;
  final Map<DateTime, List<CardEntity>> dailyPlans;
  final List<DateTime> selectedDates;
  final DateTime? activeEditDay;
  final String? errorMessage;
  final CalendarViewMode viewMode;

  const StudyPlanState({
    this.isLoading = false,
    this.selectedCards = const [],
    this.dailyPlans = const {},
    this.selectedDates = const [],
    this.activeEditDay,
    this.errorMessage,
    this.viewMode = CalendarViewMode.twoWeek,
  });

  @override
  List<Object?> get props => [
        isLoading,
        selectedCards,
        dailyPlans,
        selectedDates,
        activeEditDay,
        errorMessage,
        viewMode,
      ];

  StudyPlanState copyWith({
    bool? isLoading,
    List<CardEntity>? selectedCards,
    Map<DateTime, List<CardEntity>>? dailyPlans,
    List<DateTime>? selectedDates,
    DateTime? activeEditDay,
    String? errorMessage,
    CalendarViewMode? viewMode,
  }) {
    return StudyPlanState(
      isLoading: isLoading ?? this.isLoading,
      selectedCards: selectedCards ?? this.selectedCards,
      dailyPlans: dailyPlans ?? this.dailyPlans,
      selectedDates: selectedDates ?? this.selectedDates,
      activeEditDay: activeEditDay ?? this.activeEditDay,
      errorMessage: errorMessage ?? this.errorMessage,
      viewMode: viewMode ?? this.viewMode,
    );
  }

  // Seçilen kartların toplam sayısı
  int get totalSelectedCards => selectedCards.length;

  // Seçilen günlerin toplam sayısı
  int get totalSelectedDates => selectedDates.length;

  // Günlük ortalama kart sayısı (plan oluşturulduğunda)
  double get averageCardsPerDay {
    if (selectedDates.isEmpty) return 0;
    return totalSelectedCards / totalSelectedDates;
  }

  // Bir tarih seçili mi?
  bool isDateSelected(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return selectedDates.any((d) =>
        d.year == normalizedDate.year &&
        d.month == normalizedDate.month &&
        d.day == normalizedDate.day);
  }

  // Belirli bir günde kaç kart olduğunu döndür
  int getCardCountForDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return dailyPlans[normalizedDate]?.length ?? 0;
  }
}
