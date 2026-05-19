import 'package:equatable/equatable.dart';

abstract class CalendarState extends Equatable {
  const CalendarState();

  @override
  List<Object?> get props => [];
}

class CalendarInitial extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final DateTime selectedDate;
  final DateTime focusedMonth;
  final List<bool> fardStates;
  final List<bool> sunnahStates;
  final int totalPoints;
  final int fardCount;

  const CalendarLoaded({
    required this.selectedDate,
    required this.focusedMonth,
    required this.fardStates,
    required this.sunnahStates,
    required this.totalPoints,
    required this.fardCount,
  });

  CalendarLoaded copyWith({
    DateTime? selectedDate,
    DateTime? focusedMonth,
    List<bool>? fardStates,
    List<bool>? sunnahStates,
    int? totalPoints,
    int? fardCount,
  }) {
    return CalendarLoaded(
      selectedDate: selectedDate ?? this.selectedDate,
      focusedMonth: focusedMonth ?? this.focusedMonth,
      fardStates: fardStates ?? this.fardStates,
      sunnahStates: sunnahStates ?? this.sunnahStates,
      totalPoints: totalPoints ?? this.totalPoints,
      fardCount: fardCount ?? this.fardCount,
    );
  }

  @override
  List<Object?> get props => [
        selectedDate,
        focusedMonth,
        fardStates,
        sunnahStates,
        totalPoints,
        fardCount,
      ];
}
