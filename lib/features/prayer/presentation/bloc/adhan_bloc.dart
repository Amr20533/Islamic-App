import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'adhan_event.dart';
import 'adhan_state.dart';

class AdhanBloc extends Bloc<AdhanEvent, AdhanState> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _adhanTimer;

  AdhanBloc() : super(AdhanInitial()) {
    on<AdhanScheduleEvent>(_onSchedule);
    on<AdhanPlayEvent>(_onPlay);
    on<AdhanStopEvent>(_onStop);
  }

  Future<void> _onSchedule(
    AdhanScheduleEvent event,
    Emitter<AdhanState> emit,
  ) async {
    // Start (or restart) the foreground in-app timer for audio playback.
    // Notification scheduling is NOT done here.
    _startForegroundTimer(event.prayerTimes);
    emit(AdhanIdle());
  }

  Future<void> _onPlay(AdhanPlayEvent event, Emitter<AdhanState> emit) async {
    try {
      await _audioPlayer.setSource(AssetSource('audio/adhan.mp3'));
      await _audioPlayer.resume();
      emit(AdhanPlaying(event.prayerName));
    } catch (e) {
      debugPrint('❌ [AdhanBloc] Error playing adhan audio: $e');
    }
  }

  Future<void> _onStop(AdhanStopEvent event, Emitter<AdhanState> emit) async {
    await _audioPlayer.stop();
    emit(AdhanIdle());
  }

  void _startForegroundTimer(PrayerTimes prayerTimes) {
    _adhanTimer?.cancel();

    final nextPrayer = prayerTimes.nextPrayer();
    if (nextPrayer == Prayer.none) return;

    final prayerName = _translate(nextPrayer);
    final prayerTime = prayerTimes.timeForPrayer(nextPrayer);
    if (prayerTime == null) return;

    final duration = prayerTime.difference(DateTime.now());
    if (duration.isNegative) return;

    _adhanTimer = Timer(duration, () {
      add(AdhanPlayEvent(prayerName));
      _startForegroundTimer(prayerTimes);
    });

    debugPrint(
      '⏱ [AdhanBloc] Foreground timer set for $prayerName '
      'in ${duration.inMinutes}m ${duration.inSeconds % 60}s',
    );
  }

  // ─── Translation ───────────────────────────────────────────────────────────

  String _translate(Prayer prayer) {
    switch (prayer) {
      case Prayer.fajr:
        return 'الفجر';
      case Prayer.dhuhr:
        return 'الظهر';
      case Prayer.asr:
        return 'العصر';
      case Prayer.maghrib:
        return 'المغرب';
      case Prayer.isha:
        return 'العشاء';
      default:
        return '';
    }
  }

  // ─── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    _adhanTimer?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}
