import 'package:islamic_app/core/models/auth/signup_model.dart';
import 'package:islamic_app/core/services/states/auth_status.dart';

class AuthState {
  final AuthStatus status;
  final SignUpModel? user;

  const AuthState({
    required this.status,
    this.user,
  });
}