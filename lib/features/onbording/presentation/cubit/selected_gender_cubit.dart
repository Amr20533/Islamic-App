import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/onbording/presentation/cubit/selected_gender_state.dart';

class GenderCubit extends Cubit<GenderState> {
  GenderCubit() : super(const GenderState());

  void selectGender(Gender gender) {
    emit(state.copyWith(selectedGender: gender));
  }
}
