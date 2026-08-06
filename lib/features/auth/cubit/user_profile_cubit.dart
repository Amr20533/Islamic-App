import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/auth/cubit/user_profile_states.dart';
import 'package:islamic_app/features/auth/repositories/user_repositories.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit(this._repository)
      : super(UserProfileState.initial());

  final UserRepository _repository;

  Future<void> loadUser() async {
    emit(
      state.copyWith(
        isLoading: true,
        message: null,
      ),
    );

    try {
      final user = await _repository.currentUser();

      emit(
        state.copyWith(
          isLoading: false,
          user: user,
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

  Future<void> logout() async {
    await _repository.logout();

    emit(UserProfileState.initial());
  }

  Future<void> refresh() async {
    await loadUser();
  }
}