class SignUpModel {
  static const colFullName     = 'full_name';
  static const colEmailAddress = 'email_address';
  static const colPassword     = 'password';

  final String fullName;
  final String emailAddress;
  final String password;

  const SignUpModel({
    required this.fullName,
    required this.emailAddress,
    required this.password,
  });

  factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
    fullName:     json[colFullName]     as String,
    emailAddress: json[colEmailAddress] as String,
    password:     json[colPassword]     as String,
  );


  factory SignUpModel.empty() =>
      const SignUpModel(
        fullName: '',
        emailAddress: '',
        password: '',
      );


  Map<String, dynamic> toJson() => {
    colFullName:     fullName,
    colEmailAddress: emailAddress,
    colPassword:     password,
  };


  SignUpModel copyWith({
    String? fullName,
    String? emailAddress,
    String? password,
  }) =>
      SignUpModel(
        fullName: fullName ?? this.fullName,
        emailAddress: emailAddress ?? this.emailAddress,
        password: password ?? this.password,
      );

  Map<String, String> validate() {
    final errors = <String, String>{};

    if (fullName.trim().isEmpty) {
      errors['full_name'] = 'Full name is required.';
    } else if (fullName.trim().length < 2) {
      errors['full_name'] = 'Full name must be at least 2 characters.';
    }

    if (emailAddress.trim().isEmpty) {
      errors['email_address'] = 'Email address is required.';
    } else if (!_isValidEmail(emailAddress.trim())) {
      errors['email_address'] = 'Enter a valid email address.';
    }

    if (password.isEmpty) {
      errors['password'] = 'Password is required.';
    } else if (password.length < 8) {
      errors['password'] = 'Password must be at least 8 characters.';
    } else if (!_hasUppercase(password)) {
      errors['password'] = 'Password must contain at least one uppercase letter.';
    } else if (!_hasDigit(password)) {
      errors['password'] = 'Password must contain at least one number.';
    }

    return errors;
  }

  bool get isValid => validate().isEmpty;


  static bool _isValidEmail(String email) => RegExp(
    r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
  ).hasMatch(email);

  static bool _hasUppercase(String s) => s.contains(RegExp(r'[A-Z]'));
  static bool _hasDigit(String s)     => s.contains(RegExp(r'[0-9]'));


  @override
  String toString() =>
      'SignUpModel(fullName: $fullName, emailAddress: $emailAddress, password: [REDACTED])';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SignUpModel &&
              runtimeType == other.runtimeType &&
              fullName     == other.fullName &&
              emailAddress == other.emailAddress &&
              password     == other.password;

  @override
  int get hashCode => Object.hash(fullName, emailAddress, password);
}
