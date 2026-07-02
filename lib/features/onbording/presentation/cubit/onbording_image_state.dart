import 'dart:io';

class OnpordingImageState {
  final File? image;

  const OnpordingImageState({this.image});

  OnpordingImageState copyWith({File? image}) {
    return OnpordingImageState(image: image ?? this.image);
  }
}
