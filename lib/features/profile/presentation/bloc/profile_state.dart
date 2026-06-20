abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final bool isDailyReminderEnabled;
  final String dailyReminderTime;
  final String? profileImagePath;
  final String profileName;
  final String profileEmail;
  final String profilePassword;

  ProfileLoaded({
    required this.isDailyReminderEnabled,
    required this.dailyReminderTime,
    this.profileImagePath,
    required this.profileName,
    required this.profileEmail,
    required this.profilePassword,
  });

  ProfileLoaded copyWith({
    bool? isDailyReminderEnabled,
    String? dailyReminderTime,
    String? profileImagePath,
    String? profileName,
    String? profileEmail,
    String? profilePassword,
  }) {
    return ProfileLoaded(
      isDailyReminderEnabled: isDailyReminderEnabled ?? this.isDailyReminderEnabled,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      profileName: profileName ?? this.profileName,
      profileEmail: profileEmail ?? this.profileEmail,
      profilePassword: profilePassword ?? this.profilePassword,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}
