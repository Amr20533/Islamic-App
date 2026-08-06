import 'package:islamic_app/core/models/auth/signup_model.dart';

class UserProfileState {
  final bool isLoading;
  final SignUpModel? user;
  final String? message;

  const UserProfileState({
    required this.isLoading,
    required this.user,
    this.message,
  });

  factory UserProfileState.initial() {
    return const UserProfileState(
      isLoading: false,
      user: null,
    );
  }

  UserProfileState copyWith({
    bool? isLoading,
    SignUpModel? user,
    String? message,
  }) {
    return UserProfileState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      message: message,
    );
  }

  bool get isLoggedIn => user != null;
}