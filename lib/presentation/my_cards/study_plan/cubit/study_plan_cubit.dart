import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lexilearnai/domain/entities/card/card.dart';
import 'package:lexilearnai/presentation/my_cards/study_plan/cubit/study_plan_state.dart';

class StudyPlanCubit extends Cubit<StudyPlanState> {
  StudyPlanCubit() : super(const StudyPlanState());

  // Plan oluşturma sürecini başlat
  void initializePlan(List<CardEntity> cards) {
    emit(state.copyWith(
      selectedCards: cards,
      dailyPlans: {},
      selectedDates: [],
      errorMessage: null,
    ));
  }

  // Bir tarihi seç veya seçimi kaldır
  void toggleDateSelection(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final selectedDates = List<DateTime>.from(state.selectedDates);

    // Eğer tarih zaten seçili ise, seçimi kaldır
    if (state.isDateSelected(normalizedDate)) {
      selectedDates.removeWhere((d) =>
          d.year == normalizedDate.year &&
          d.month == normalizedDate.month &&
          d.day == normalizedDate.day);

      emit(state.copyWith(
        selectedDates: selectedDates,
        errorMessage: null,
      ));
      return;
    }

    // Tarih seçili değilse, önce kotrolleri yap, sonra ekle

    // 1. Maksimum 30 gün seçilebilir
    if (selectedDates.length >= 30) {
      emit(state.copyWith(
        errorMessage: 'En fazla 30 gün seçebilirsiniz',
      ));
      return;
    }

    // 2. Seçilebilecek tarih sayısı kart sayısını aşamaz
    if (selectedDates.length >= state.selectedCards.length) {
      emit(state.copyWith(
        errorMessage: 'Seçilebilecek gün sayısı, kart sayısını aşamaz',
      ));
      return;
    }

    // Kontroller geçildiyse tarihi ekle
    selectedDates.add(normalizedDate);
    emit(state.copyWith(
      selectedDates: selectedDates,
      errorMessage: null,
    ));
  }

  // Sadece hafta içi günleri seç
  void selectWeekdaysOnly() {
    final now = DateTime.now();
    final selectedDates = <DateTime>[];
    final int maxDaysToSelect = state.selectedCards.length.clamp(1, 30);

    // Bugünden başlayarak 2 haftalık periyotta hafta içi günleri ekle
    for (var i = 0; i < 14; i++) {
      // Maksimum seçilebilecek gün sayısına ulaşıldıysa döngüden çık
      if (selectedDates.length >= maxDaysToSelect) break;

      final date = now.add(Duration(days: i));
      // 1-5 hafta içi günleri (Pazartesi-Cuma)
      if (date.weekday >= 1 && date.weekday <= 5) {
        selectedDates.add(DateTime(date.year, date.month, date.day));
      }
    }

    emit(state.copyWith(
      selectedDates: selectedDates,
      errorMessage: null,
    ));
  }

  // Sadece hafta sonu günleri seç
  void selectWeekendsOnly() {
    final now = DateTime.now();
    final selectedDates = <DateTime>[];
    final int maxDaysToSelect = state.selectedCards.length.clamp(1, 30);

    // Bugünden başlayarak 3 haftalık periyotta hafta sonu günleri ekle
    for (var i = 0; i < 21; i++) {
      // Maksimum seçilebilecek gün sayısına ulaşıldıysa döngüden çık
      if (selectedDates.length >= maxDaysToSelect) break;

      final date = now.add(Duration(days: i));
      // 6-7 hafta sonu günleri (Cumartesi-Pazar)
      if (date.weekday == 6 || date.weekday == 7) {
        selectedDates.add(DateTime(date.year, date.month, date.day));
      }
    }

    emit(state.copyWith(
      selectedDates: selectedDates,
      errorMessage: null,
    ));
  }

  // Takvim görünüm modunu değiştir
  void changeCalendarViewMode(CalendarViewMode mode) {
    emit(state.copyWith(viewMode: mode));
  }

  // Seçilen tarihlere kelimeleri otomatik dağıt
  void generatePlanForSelectedDates() {
    if (state.selectedDates.isEmpty) {
      emit(state.copyWith(
        errorMessage: 'Lütfen en az bir gün seçin',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      // Tarihleri sırala
      final selectedDates = List<DateTime>.from(state.selectedDates)
        ..sort((a, b) => a.compareTo(b));
      final selectedCards = List<CardEntity>.from(state.selectedCards);
      final dailyPlans = <DateTime, List<CardEntity>>{};

      // Kart yoksa boş plan döndür
      if (selectedCards.isEmpty) {
        emit(state.copyWith(
          dailyPlans: dailyPlans,
          isLoading: false,
          errorMessage: null,
        ));
        return;
      }

      // Eğer kelime sayısı seçilen gün sayısına eşitse, her güne bir kelime düşecek şekilde dağıt
      if (selectedCards.length == selectedDates.length) {
        for (int i = 0; i < selectedDates.length; i++) {
          dailyPlans[selectedDates[i]] = [selectedCards[i]];
        }
      }
      // Eğer kelime sayısı tarih sayısından fazlaysa, günlere eşit dağıtmaya çalış
      else if (selectedCards.length > selectedDates.length) {
        // Her güne düşecek minimum kart sayısı
        final int cardsPerDay = selectedCards.length ~/ selectedDates.length;
        // Kalan kartlar (bazı günlere ekstra verilecek)
        int remainingCards = selectedCards.length % selectedDates.length;

        int cardIndex = 0;

        // Her günü doldur
        for (DateTime date in selectedDates) {
          final List<CardEntity> cardsForDay = [];

          // Bu gün için temel kart sayısı
          for (int i = 0; i < cardsPerDay; i++) {
            if (cardIndex < selectedCards.length) {
              cardsForDay.add(selectedCards[cardIndex]);
              cardIndex++;
            }
          }

          // Kalan kartlardan bu güne ekstra ekle
          if (remainingCards > 0) {
            if (cardIndex < selectedCards.length) {
              cardsForDay.add(selectedCards[cardIndex]);
              cardIndex++;
              remainingCards--;
            }
          }

          // Günün planını kaydet
          if (cardsForDay.isNotEmpty) {
            dailyPlans[date] = cardsForDay;
          }
        }
      }
      // Eğer kelime sayısı tarih sayısından azsa, kelimeleri sırayla dağıt
      else {
        for (int i = 0; i < selectedCards.length; i++) {
          dailyPlans[selectedDates[i]] = [selectedCards[i]];
        }
      }

      emit(state.copyWith(
        dailyPlans: dailyPlans,
        isLoading: false,
        errorMessage: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Plan oluşturulurken bir hata oluştu: $e',
      ));
    }
  }

  // Belirli bir günün planını değiştir
  void editDayPlan(DateTime day, List<CardEntity> cards) {
    final normalizedDate = DateTime(day.year, day.month, day.day);
    final dailyPlans = Map<DateTime, List<CardEntity>>.from(state.dailyPlans);

    dailyPlans[normalizedDate] = cards;

    emit(state.copyWith(
      dailyPlans: dailyPlans,
      activeEditDay: null,
      errorMessage: null,
    ));
  }

  // Bir kart öğesini günler arasında taşı
  void movePlanItem(DateTime fromDay, DateTime toDay, CardEntity card) {
    final fromDate = DateTime(fromDay.year, fromDay.month, fromDay.day);
    final toDate = DateTime(toDay.year, toDay.month, toDay.day);

    final dailyPlans = Map<DateTime, List<CardEntity>>.from(state.dailyPlans);

    // Kaynaktan kartı kaldır
    if (dailyPlans.containsKey(fromDate)) {
      dailyPlans[fromDate] = List<CardEntity>.from(dailyPlans[fromDate] ?? [])
        ..removeWhere((c) => c.id == card.id);
    }

    // Hedefe kartı ekle
    if (dailyPlans.containsKey(toDate)) {
      dailyPlans[toDate] = List<CardEntity>.from(dailyPlans[toDate] ?? [])
        ..add(card);
    } else {
      dailyPlans[toDate] = [card];
    }

    emit(state.copyWith(
      dailyPlans: dailyPlans,
      errorMessage: null,
    ));
  }

  // Düzenleme moduna geç
  void startEditing(DateTime day) {
    final normalizedDate = DateTime(day.year, day.month, day.day);
    emit(state.copyWith(activeEditDay: normalizedDate));
  }

  // Düzenleme modundan çık
  void stopEditing() {
    emit(state.copyWith(activeEditDay: null));
  }

  // Planı sıfırla
  void resetPlan() {
    emit(state.copyWith(
      dailyPlans: {},
      selectedDates: [],
      activeEditDay: null,
      errorMessage: null,
    ));
  }

  // Hata mesajını temizle
  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  // Tüm seçili tarihleri temizle
  void resetSelectedDates() {
    emit(state.copyWith(
      selectedDates: [],
      errorMessage: null,
    ));
  }

  // Akıllı hafta içi seçimi (kart sayısı kadar)
  void selectSmartWeekdays(int maxDays) {
    final now = DateTime.now();
    final selectedDates = <DateTime>[];

    // Önce tüm seçimleri temizle
    resetSelectedDates();

    // Bugünden başlayarak 2 hafta içinde hafta içi günleri seç (maksimum kart sayısı kadar)
    for (var i = 0; i < 14; i++) {
      if (selectedDates.length >= maxDays) break;

      final date = now.add(Duration(days: i));
      // 1-5 hafta içi günleri (Pazartesi-Cuma)
      if (date.weekday >= 1 && date.weekday <= 5) {
        selectedDates.add(DateTime(date.year, date.month, date.day));
      }
    }

    emit(state.copyWith(
      selectedDates: selectedDates,
      errorMessage: null,
    ));
  }

  // Akıllı hafta sonu seçimi (kart sayısı kadar)
  void selectSmartWeekends(int maxDays) {
    final now = DateTime.now();
    final selectedDates = <DateTime>[];

    // Önce tüm seçimleri temizle
    resetSelectedDates();

    // Bugünden başlayarak 3 hafta içinde hafta sonu günleri seç (maksimum kart sayısı kadar)
    for (var i = 0; i < 21; i++) {
      if (selectedDates.length >= maxDays) break;

      final date = now.add(Duration(days: i));
      // 6-7 hafta sonu günleri (Cumartesi-Pazar)
      if (date.weekday == 6 || date.weekday == 7) {
        selectedDates.add(DateTime(date.year, date.month, date.day));
      }
    }

    emit(state.copyWith(
      selectedDates: selectedDates,
      errorMessage: null,
    ));
  }
}
