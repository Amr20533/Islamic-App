import 'package:islamic_app/features/calendar/data/datasources/calendar_local_datasource.dart';
import 'package:islamic_app/features/calendar/domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final CalendarLocalDataSource localDataSource;

  CalendarRepositoryImpl({required this.localDataSource});

  String _getDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  Future<List<bool>> getFardStates(DateTime date) async {
    return localDataSource.getFardStates(_getDateKey(date));
  }

  @override
  Future<List<bool>> getSunnahStates(DateTime date) async {
    return localDataSource.getSunnahStates(_getDateKey(date));
  }

  @override
  Future<void> saveFardStates(DateTime date, List<bool> states) async {
    return localDataSource.saveFardStates(_getDateKey(date), states);
  }

  @override
  Future<void> saveSunnahStates(DateTime date, List<bool> states) async {
    return localDataSource.saveSunnahStates(_getDateKey(date), states);
  }
}
