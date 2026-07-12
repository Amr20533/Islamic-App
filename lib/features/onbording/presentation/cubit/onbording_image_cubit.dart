import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/onbording/data/services/image_picker_service.dart';
import 'package:islamic_app/features/onbording/presentation/cubit/onbording_image_state.dart';

class OnboardingImageCubit extends Cubit<OnboardingImageState> {
  final ImagePickerService imagePickerService;

  OnboardingImageCubit(this.imagePickerService)
    : super(const OnboardingImageState());

  Future<void> pickImage() async {
    final image = await imagePickerService.pickImage();

    if (image == null) return;

    emit(state.copyWith(image: image));
  }
}
