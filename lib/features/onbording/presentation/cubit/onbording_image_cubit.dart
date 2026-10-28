import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/onbording/data/services/image_picker_service.dart';
import 'package:islamic_app/features/onbording/presentation/cubit/onbording_image_state.dart';

class OnboardingImageCubit extends Cubit<OnboardingImageState> {
  final ImagePickerService imagePickerService;

  OnboardingImageCubit(this.imagePickerService)
    : super(const OnboardingImageState());

  Future<void> pickImage() async {
    final xFile = await imagePickerService.pickImage();
    if (xFile == null) return;

    // readAsBytes() works on both web and mobile
    final bytes = await xFile.readAsBytes();
    emit(state.copyWith(imageBytes: bytes));
  }
}
