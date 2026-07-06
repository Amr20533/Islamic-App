import 'package:islamic_app/core/models/auth/signup_model.dart';

class SignUpState {
  final SignUpModel user;
  final Map<String, String> errors;
  final bool isLoading;
  final bool isSuccess;
  final String? message;

  const SignUpState({
    required this.user,
    this.errors = const {},
    this.isLoading = false,
    this.isSuccess = false,
    this.message,
  });

  factory SignUpState.initial() => SignUpState(
    user: SignUpModel.empty(),
  );

  SignUpState copyWith({
    SignUpModel? user,
    Map<String, String>? errors,
    bool? isLoading,
    bool? isSuccess,
    String? message,
  }) {
    return SignUpState(
      user: user ?? this.user,
      errors: errors ?? this.errors,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message,
    );
  }
}