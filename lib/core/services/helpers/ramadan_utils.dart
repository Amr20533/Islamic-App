class RamadanUtils {
  static String getDayType(int hijriDay) {
    if (hijriDay > 20) {
      if (isWitr(hijriDay)) {
        return "ليلة وترية - تحرّوا ليلة القدر";
      }
      return "من العشر الأواخر";
    }
    return "أيام الرحمة والمغفرة";
  }

  static bool isWitr(int day) {
    List<int> witrDays = [21, 23, 25, 27, 29];
    return witrDays.contains(day);
  }
}
