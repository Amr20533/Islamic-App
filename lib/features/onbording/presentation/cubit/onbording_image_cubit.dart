import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/onpording/data/services/image_picker_service.dart';
import 'package:islamic_app/features/onpording/presentation/cubit/onpording_image_state.dart';

class OnpordingImageCubit extends Cubit<OnpordingImageState> {
  final ImagePickerService imagePickerService;

  OnpordingImageCubit(this.imagePickerService)
    : super(const OnpordingImageState());

  Future<void> pickImage() async {
    final image = await imagePickerService.pickImage();

    if (image == null) return;

    emit(state.copyWith(image: image));
  }
}
