import 'dart:io';
import 'package:flutter/material.dart';
import 'package:islamic_app/features/onbording/data/services/image_picker_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final ImagePickerService _imagePickerService;

  ProfileViewModel(this._imagePickerService);

  File? selectedImage;

  Future<void> pickImage() async {
    final image = await _imagePickerService.pickImage();

    if (image == null) return;

    selectedImage = image;
    notifyListeners();
  }
}
