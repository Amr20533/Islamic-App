import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:islamic_app/features/quran/data/models/verse.dart';

/// Bottom sheet displaying the verse and playing its audio by Sheikh Mishary Rashid Alafasy.
class VerseAudioBottomSheet extends StatefulWidget {
  final Verse verse;

  const VerseAudioBottomSheet({
    super.key,
    required this.verse,
  });

  /// Utility method to show the bottom sheet.
  static void show(BuildContext context, Verse verse) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VerseAudioBottomSheet(verse: verse),
    );
  }

  @override
  State<VerseAudioBottomSheet> createState() => _VerseAudioBottomSheetState();
}

class _VerseAudioBottomSheetState extends State<VerseAudioBottomSheet> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = true;
  bool _isRepeat = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          if (state == PlayerState.playing || state == PlayerState.paused) {
            _isLoading = false;
          }
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _position = Duration.zero;
          _isPlaying = false;
        });
        if (_isRepeat) {
          _playAudio();
        } else {
          Navigator.pop(context); // Close sheet when single playback finishes
        }
      }
    });

    // Auto-play on open
    _playAudio();
  }

  Future<void> _playAudio() async {
    final surahNum = widget.verse.surahNumber ?? 1;
    final verseNum = widget.verse.number ?? 1;
    final surahStr = surahNum.toString().padLeft(3, '0');
    final verseStr = verseNum.toString().padLeft(3, '0');
    final audioUrl = 'https://verses.quran.com/Alafasy/mp3/$surahStr$verseStr.mp3';

    setState(() {
      _isLoading = true;
    });

    try {
      await _audioPlayer.play(UrlSource(audioUrl));
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('عذراً، تعذر تشغيل الصوت. يرجى التحقق من اتصالك بالإنترنت.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _pauseAudio();
    } else {
      await _playAudio();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surahName = widget.verse.surahNameAr ?? '';
    final verseNum = widget.verse.number ?? 1;
    final verseTextAr = widget.verse.text?['ar'] ?? '';

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFBF9F1),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: FractionallySizedBox(
        heightFactor: 0.55,
        child: Column(
          children: [
            // Drag handle indicator
            const SizedBox(height: 12),
            Container(
              width: 50,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD4A574).withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF2C1C12)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'الاستماع للآية',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                          color: Color(0xFF3E2723),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'سورة $surahName - آية $verseNum (الشيخ مشاري العفاسي)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF8B4513),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(color: Color(0xFFE5D5C5), height: 1),

            // Main Content Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Verse Text Display Card
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 16,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F1E8),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFD4A574).withValues(alpha: 0.6),
                          width: 1.2,
                        ),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Text(
                          verseTextAr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'QuranFont',
                            color: Color(0xFF2C1C12),
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Slider Progress Bar
                    Row(
                      children: [
                        Text(
                          _formatDuration(_position),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5D4037),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 3,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                              activeTrackColor: const Color(0xFF8B4513),
                              inactiveTrackColor: const Color(0xFFD4A574).withValues(alpha: 0.3),
                              thumbColor: const Color(0xFF8B4513),
                            ),
                            child: Slider(
                              value: _position.inSeconds.toDouble(),
                              min: 0,
                              max: _duration.inSeconds.toDouble() > 0
                                  ? _duration.inSeconds.toDouble()
                                  : 1,
                              onChanged: (val) {
                                _audioPlayer.seek(Duration(seconds: val.toInt()));
                              },
                            ),
                          ),
                        ),
                        Text(
                          _formatDuration(_duration),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF5D4037),
                            fontFamily: 'Tajawal',
                          ),
                        ),
                      ],
                    ),

                    // Controls Panel
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Repeat Button
                        IconButton(
                          icon: Icon(
                            _isRepeat ? Icons.repeat_one_on_outlined : Icons.repeat_outlined,
                            color: const Color(0xFF8B4513),
                            size: 26,
                          ),
                          onPressed: () {
                            setState(() {
                              _isRepeat = !_isRepeat;
                            });
                          },
                        ),
                        const SizedBox(width: 20),

                        // Play/Pause Button
                        GestureDetector(
                          onTap: _isLoading ? null : _togglePlayPause,
                          child: Container(
                            width: 68,
                            height: 68,
                            decoration: const BoxDecoration(
                              color: Color(0xFF8B4513),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                )
                              ],
                            ),
                            child: Center(
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : Icon(
                                      _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),

                        // Stop Button
                        IconButton(
                          icon: const Icon(
                            Icons.stop_circle_outlined,
                            color: Color(0xFF8B4513),
                            size: 28,
                          ),
                          onPressed: () {
                            _audioPlayer.stop();
                            setState(() {
                              _position = Duration.zero;
                              _isPlaying = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
