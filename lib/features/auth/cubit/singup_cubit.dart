import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/auth/cubit/singup_states.dart';
import 'package:islamic_app/features/auth/repositories/user_repositories.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._repository)
      : super(SignUpState.initial());

  final UserRepository _repository;

  void updateName(String value) {
    emit(
      state.copyWith(
        user: state.user.copyWith(fullName: value),
      ),
    );
  }

  void updateEmail(String value) {
    emit(
      state.copyWith(
        user: state.user.copyWith(emailAddress: value),
      ),
    );
  }

  void updatePassword(String value) {
    emit(
      state.copyWith(
        user: state.user.copyWith(password: value),
      ),
    );
  }

  Future<void> signUp() async {
    final errors = state.user.validate();

    if (errors.isNotEmpty) {
      emit(
        state.copyWith(errors: errors),
      );
      return;
    }

    emit(
      state.copyWith(
        isLoading: true,
        errors: {},
      ),
    );

    try {
      await _repository.createUser(state.user);

      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: true,
          message: 'Account created successfully.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          message: e.toString(),
        ),
      );
    }
  }
}