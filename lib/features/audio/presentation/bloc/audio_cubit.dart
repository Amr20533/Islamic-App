import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class AudioState extends Equatable {
  final bool isPlaying;
  final Duration duration;
  final Duration position;

  const AudioState({
    this.isPlaying = false,
    this.duration = Duration.zero,
    this.position = Duration.zero,
  });

  @override
  List<Object?> get props => [isPlaying, duration, position];

  AudioState copyWith({
    bool? isPlaying,
    Duration? duration,
    Duration? position,
  }) {
    return AudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      duration: duration ?? this.duration,
      position: position ?? this.position,
    );
  }
}

class AudioCubit extends Cubit<AudioState> {
  final AudioPlayer _player = AudioPlayer();

  AudioCubit() : super(const AudioState()) {
    _init();
  }

  void _init() {
    _player.onPlayerStateChanged.listen((playerState) {
      emit(state.copyWith(isPlaying: playerState == PlayerState.playing));
    });

    _player.onDurationChanged.listen((newDuration) {
      emit(state.copyWith(duration: newDuration));
    });

    _player.onPositionChanged.listen((newPosition) {
      emit(state.copyWith(position: newPosition));
    });
  }

  Future<void> playNetwork(String path) async {
    if (_player.state == PlayerState.paused) {
      await _player.resume();
    } else {
      await _player.play(UrlSource(path));
    }
  }

  Future<void> playAsset(String assetPath) async {
    await _player.play(AssetSource(assetPath));
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> seek(Duration newPosition) async {
    await _player.seek(newPosition);
    await _player.resume();
  }

  @override
  Future<void> close() {
    _player.dispose();
    return super.close();
  }
}
