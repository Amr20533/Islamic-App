import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/auth/cubit/login_state.dart';
import 'package:islamic_app/features/auth/repositories/user_repositories.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repository)
      : super(LoginState.initial());

  final UserRepository _repository;

  void updateEmail(String value) {
    emit(
      state.copyWith(
        emailAddress: value,
      ),
    );
  }

  void updatePassword(String value) {
    emit(
      state.copyWith(
        password: value,
      ),
    );
  }

  Future<void> login() async {
    final errors = state.validate();

    if (errors.isNotEmpty) {
      emit(
        state.copyWith(
          errors: errors,
          message: null,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        errors: {},
        message: null,
      ),
    );

    try {
      final user = await _repository.login(
        state.emailAddress.trim(),
        state.password,
      );

      if (user == null) {
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: false,
            message: 'Invalid email or password.',
          ),
        );
        return;
      }

      // Save the logged-in user's ID
      await _repository.saveUserId(user.id!);

      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          message: 'Login successful.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          message: e.toString(),
        ),
      );
    }
  }
}