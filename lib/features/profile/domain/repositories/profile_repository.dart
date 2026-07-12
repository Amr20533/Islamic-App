abstract class ProfileRepository {
  Future<bool> getDailyReminderEnabled();
  Future<void> saveDailyReminderEnabled(bool enabled);
  Future<String> getDailyReminderTime();
  Future<void> saveDailyReminderTime(String time);
  Future<String?> getProfileImagePath();
  Future<void> saveProfileImagePath(String? path);
  Future<String> getProfileName();
  Future<void> saveProfileName(String name);
  Future<String> getProfileEmail();
  Future<void> saveProfileEmail(String email);
  Future<String> getProfilePassword();
  Future<void> saveProfilePassword(String password);
  Future<String?> getGender();
  Future<void> saveGender(String gender);
}
