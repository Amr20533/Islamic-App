abstract class CalendarRepository {
  Future<List<bool>> getFardStates(DateTime date);
  Future<List<bool>> getSunnahStates(DateTime date);
  Future<void> saveFardStates(DateTime date, List<bool> states);
  Future<void> saveSunnahStates(DateTime date, List<bool> states);
}
