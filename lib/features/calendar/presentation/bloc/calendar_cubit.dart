import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:islamic_app/features/calendar/presentation/bloc/calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final CalendarRepository repository;
  final List<int> _sunnahPoints = [10, 20, 10, 10, 10];

  CalendarCubit({required this.repository}) : super(CalendarInitial());

  Future<void> initCalendar() async {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    await loadDate(today, focusedMonth: today);
  }

  Future<void> loadDate(DateTime date, {DateTime? focusedMonth}) async {
    final currentMonth = focusedMonth ?? 
        (state is CalendarLoaded ? (state as CalendarLoaded).focusedMonth : date);

    final fard = await repository.getFardStates(date);
    final sunnah = await repository.getSunnahStates(date);

    final fardCheckedCount = fard.where((e) => e).length;
    final totalPoints = _calculatePoints(fard, sunnah);

    emit(CalendarLoaded(
      selectedDate: date,
      focusedMonth: currentMonth,
      fardStates: fard,
      sunnahStates: sunnah,
      totalPoints: totalPoints,
      fardCount: fardCheckedCount,
    ));
  }

  Future<void> changeFocusedMonth(DateTime month) async {
    if (state is CalendarLoaded) {
      final loaded = state as CalendarLoaded;
      emit(loaded.copyWith(focusedMonth: month));
    }
  }

  Future<void> toggleFard(int index) async {
    if (state is CalendarLoaded) {
      final loaded = state as CalendarLoaded;
      final newFard = List<bool>.from(loaded.fardStates);
      newFard[index] = !newFard[index];

      await repository.saveFardStates(loaded.selectedDate, newFard);

      final fardCheckedCount = newFard.where((e) => e).length;
      final totalPoints = _calculatePoints(newFard, loaded.sunnahStates);

      emit(loaded.copyWith(
        fardStates: newFard,
        totalPoints: totalPoints,
        fardCount: fardCheckedCount,
      ));
    }
  }

  Future<void> toggleSunnah(int index) async {
    if (state is CalendarLoaded) {
      final loaded = state as CalendarLoaded;
      final newSunnah = List<bool>.from(loaded.sunnahStates);
      newSunnah[index] = !newSunnah[index];

      await repository.saveSunnahStates(loaded.selectedDate, newSunnah);

      final totalPoints = _calculatePoints(loaded.fardStates, newSunnah);

      emit(loaded.copyWith(
        sunnahStates: newSunnah,
        totalPoints: totalPoints,
      ));
    }
  }

  int _calculatePoints(List<bool> fard, List<bool> sunnah) {
    int fardCheckedCount = fard.where((e) => e).length;
    int fardPoints = 0;

    // Fard points: 10 points per checked fard, but only if >= 3 are checked!
    if (fardCheckedCount >= 3) {
      fardPoints = fardCheckedCount * 10;
    }

    // Sunnah points
    int sunnahPoints = 0;
    for (int i = 0; i < sunnah.length; i++) {
      if (sunnah[i]) {
        sunnahPoints += _sunnahPoints[i];
      }
    }

    return fardPoints + sunnahPoints;
  }
}
