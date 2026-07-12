import 'dart:io';

class OnboardingImageState {
  final File? image;

  const OnboardingImageState({this.image});

  OnboardingImageState copyWith({File? image}) {
    return OnboardingImageState(image: image ?? this.image);
  }
}
