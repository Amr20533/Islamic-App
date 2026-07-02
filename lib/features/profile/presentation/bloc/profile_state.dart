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
  final String? gender;

  ProfileLoaded({
    required this.isDailyReminderEnabled,
    required this.dailyReminderTime,
    this.profileImagePath,
    required this.profileName,
    required this.profileEmail,
    required this.profilePassword,
    this.gender,
  });

  ProfileLoaded copyWith({
    bool? isDailyReminderEnabled,
    String? dailyReminderTime,
    String? profileImagePath,
    bool clearImage = false,
    String? profileName,
    String? profileEmail,
    String? profilePassword,
    String? gender,
  }) {
    return ProfileLoaded(
      isDailyReminderEnabled:
          isDailyReminderEnabled ?? this.isDailyReminderEnabled,
      dailyReminderTime: dailyReminderTime ?? this.dailyReminderTime,
      profileImagePath: clearImage
          ? null
          : (profileImagePath ?? this.profileImagePath),
      profileName: profileName ?? this.profileName,
      profileEmail: profileEmail ?? this.profileEmail,
      profilePassword: profilePassword ?? this.profilePassword,
      gender: gender ?? this.gender,
    );
  }
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError({required this.message});
}
