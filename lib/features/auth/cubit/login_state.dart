class LoginState {
  final String emailAddress;
  final String password;

  final Map<String, String> errors;

  final bool isLoading;
  final bool isSuccess;

  final String? message;

  const LoginState({
    required this.emailAddress,
    required this.password,
    this.errors = const {},
    this.isLoading = false,
    this.isSuccess = false,
    this.message,
  });

  factory LoginState.initial() {
    return const LoginState(
      emailAddress: '',
      password: '',
    );
  }

  LoginState copyWith({
    String? emailAddress,
    String? password,
    Map<String, String>? errors,
    bool? isLoading,
    bool? isSuccess,
    String? message,
  }) {
    return LoginState(
      emailAddress: emailAddress ?? this.emailAddress,
      password: password ?? this.password,
      errors: errors ?? this.errors,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      message: message,
    );
  }

  Map<String, String> validate() {
    final errors = <String, String>{};

    if (emailAddress.trim().isEmpty) {
      errors['email_address'] = 'Email address is required.';
    } else if (!_isValidEmail(emailAddress.trim())) {
      errors['email_address'] = 'Enter a valid email address.';
    }

    if (password.isEmpty) {
      errors['password'] = 'Password is required.';
    }

    return errors;
  }

  static bool _isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }
}