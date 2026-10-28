import 'dart:typed_data';

/// Holds the picked image as raw bytes so it works on both
/// Flutter Web (no dart:io File support) and mobile.
class OnboardingImageState {
  final Uint8List? imageBytes;

  const OnboardingImageState({this.imageBytes});

  OnboardingImageState copyWith({Uint8List? imageBytes}) {
    return OnboardingImageState(imageBytes: imageBytes ?? this.imageBytes);
  }
}
