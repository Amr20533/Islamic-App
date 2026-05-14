import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class DailyDhikrState extends Equatable {
  final int count;
  final int maxCount;

  const DailyDhikrState({this.count = 0, this.maxCount = 10});

  bool get isCompleted => count >= maxCount;

  @override
  List<Object?> get props => [count, maxCount];

  DailyDhikrState copyWith({int? count, int? maxCount}) {
    return DailyDhikrState(
      count: count ?? this.count,
      maxCount: maxCount ?? this.maxCount,
    );
  }
}

class DailyDhikrCubit extends Cubit<DailyDhikrState> {
  DailyDhikrCubit() : super(const DailyDhikrState());

  void incrementCount() {
    if (state.count < state.maxCount) {
      emit(state.copyWith(count: state.count + 1));
    }
  }

  void resetCount() {
    emit(state.copyWith(count: 0));
  }
}
