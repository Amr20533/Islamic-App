import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TasbeehState extends Equatable {
  const TasbeehState();
  @override
  List<Object?> get props => [];
}

class TasbeehInitial extends TasbeehState {}

class TasbeehLoaded extends TasbeehState {
  final int counter;
  const TasbeehLoaded(this.counter);
  @override
  List<Object?> get props => [counter];
}

class TasbeehCubit extends Cubit<TasbeehState> {
  static const String _storageKey = 'electronic_tasbeeh_count';
  
  TasbeehCubit() : super(TasbeehInitial());

  Future<void> loadCounter() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_storageKey) ?? 0;
    emit(TasbeehLoaded(count));
  }

  Future<void> incrementCounter() async {
    if (state is TasbeehLoaded) {
      final currentCount = (state as TasbeehLoaded).counter;
      final newCount = currentCount + 1;
      emit(TasbeehLoaded(newCount));
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_storageKey, newCount);
    }
  }

  Future<void> resetCounter() async {
    emit(const TasbeehLoaded(0));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_storageKey, 0);
  }
}
