import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';

class AudioController extends GetxController {
  final AudioPlayer _player = AudioPlayer();
  final isPlaying = false.obs;
  final duration = Duration.zero.obs;
  final position = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();

    _player.onPlayerStateChanged.listen((state) {
      isPlaying.value = state == PlayerState.playing;
    });

    _player.onDurationChanged.listen((newDuration) {
      duration.value = newDuration;
    });

    _player.onPositionChanged.listen((newPosition) {
      position.value = newPosition;
    });
  }

  Future<void> playNetwork(String path) async {
    // If it's already paused, just resume
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
    // Resume automatically after seeking if you prefer
    await _player.resume();
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }
}