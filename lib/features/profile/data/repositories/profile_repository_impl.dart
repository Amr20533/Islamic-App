import 'package:islamic_app/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:islamic_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({required this.localDataSource});

  @override
  Future<bool> getDailyReminderEnabled() {
    return localDataSource.getDailyReminderEnabled();
  }

  @override
  Future<void> saveDailyReminderEnabled(bool enabled) {
    return localDataSource.saveDailyReminderEnabled(enabled);
  }

  @override
  Future<String> getDailyReminderTime() {
    return localDataSource.getDailyReminderTime();
  }

  @override
  Future<void> saveDailyReminderTime(String time) {
    return localDataSource.saveDailyReminderTime(time);
  }

  @override
  Future<String?> getProfileImagePath() {
    return localDataSource.getProfileImagePath();
  }

  @override
  Future<void> saveProfileImagePath(String? path) {
    return localDataSource.saveProfileImagePath(path);
  }

  @override
  Future<String> getProfileName() {
    return localDataSource.getProfileName();
  }

  @override
  Future<void> saveProfileName(String name) {
    return localDataSource.saveProfileName(name);
  }

  @override
  Future<String> getProfileEmail() {
    return localDataSource.getProfileEmail();
  }

  @override
  Future<void> saveProfileEmail(String email) {
    return localDataSource.saveProfileEmail(email);
  }

  @override
  Future<String> getProfilePassword() {
    return localDataSource.getProfilePassword();
  }

  @override
  Future<void> saveProfilePassword(String password) {
    return localDataSource.saveProfilePassword(password);
  }

  @override
  Future<String?> getGender() {
    return localDataSource.getGender();
  }

  @override
  Future<void> saveGender(String gender) {
    return localDataSource.saveGender(gender);
  }
}
