import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  /// Returns the picked [XFile] or null if the user cancelled.
  /// Use [XFile.readAsBytes()] on web; [XFile.path] on mobile.
  Future<XFile?> pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    return image;
  }
}
