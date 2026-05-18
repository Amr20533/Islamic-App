import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:islamic_app/features/quran/data/models/audio_reciter.dart';

class QuranAudioPlayerWidget extends StatefulWidget {
  final List<AudioReciter> reciters;
  final VoidCallback onExpanded;

  const QuranAudioPlayerWidget({
    super.key,
    required this.reciters,
    required this.onExpanded,
  });

  @override
  State<QuranAudioPlayerWidget> createState() => _QuranAudioPlayerWidgetState();
}

class _QuranAudioPlayerWidgetState extends State<QuranAudioPlayerWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final GlobalKey<PopupMenuButtonState<int>> _popupMenuKey = GlobalKey();
  bool _isExpanded = false;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  AudioReciter? _selectedReciter;
  double _playbackRate = 1.0;
  bool _isRepeat = false;

  @override
  void initState() {
    super.initState();
    if (widget.reciters.isNotEmpty) {
      _selectedReciter = widget.reciters.first;
    }

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
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
        if (_isRepeat && _selectedReciter != null) {
          _playAudio(_selectedReciter!.link);
        }
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String url) async {
    await _audioPlayer.play(UrlSource(url));
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  void _changeSpeed() {
    setState(() {
      if (_playbackRate == 1.0) {
        _playbackRate = 1.5;
      } else if (_playbackRate == 1.5) {
        _playbackRate = 2.0;
      } else {
        _playbackRate = 1.0;
      }
      _audioPlayer.setPlaybackRate(_playbackRate);
    });
  }

  void _showRecitersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Color(0xFFFBF9F1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'اختر القارئ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.reciters.length,
                  itemBuilder: (context, index) {
                    final reciter = widget.reciters[index];
                    final isSelected = _selectedReciter?.id == reciter.id;
                    return ListTile(
                      title: Text(
                        reciter.reciterNameAr,
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          color: isSelected
                              ? const Color(0xFF8B4513)
                              : Colors.black,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Color(0xFF8B4513))
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedReciter = reciter;
                        });
                        _playAudio(reciter.link);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isExpanded) {
      return InkWell(
        onTap: () {
          setState(() {
            _isExpanded = true;
          });
          widget.onExpanded();
          // فتح القائمة (الثلاث نقاط) تلقائياً بمجرد التوسيع، دون تشغيل الصوت
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _popupMenuKey.currentState?.showButtonMenu();
          });
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.play_arrow_outlined,
            color: Color(0xFF8B4513),
            size: 30,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress Bar
          Row(
            children: [
              Text(
                _formatDuration(_position),
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 4,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 10,
                    ),
                    activeTrackColor: const Color(0xFF8B4513),
                    inactiveTrackColor: Colors.grey.withOpacity(0.3),
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
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PopupMenuButton<int>(
                key: _popupMenuKey,
                icon: const Icon(Icons.more_horiz, color: Color(0xFF8B4513)),
                color: const Color(0xFFEBE6DF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                position: PopupMenuPosition.over,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'اختيار القارئ',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: Color(0xFF8B4513),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.person_outline,
                          color: Color(0xFF8B4513),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'السرعة ${_playbackRate}x',
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            color: Color(0xFF8B4513),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.speed, color: Color(0xFF8B4513)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'التكرار',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: Color(0xFF8B4513),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _isRepeat ? Icons.repeat_on : Icons.repeat,
                          color: const Color(0xFF8B4513),
                        ),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 1) {
                    _showRecitersSheet(context);
                  } else if (value == 2) {
                    _changeSpeed();
                  } else if (value == 3) {
                    setState(() {
                      _isRepeat = !_isRepeat;
                    });
                  }
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.fast_rewind_outlined,
                  color: Color(0xFF8B4513),
                ),
                onPressed: () {
                  final newPos = _position - const Duration(seconds: 10);
                  _audioPlayer.seek(
                    newPos < Duration.zero ? Duration.zero : newPos,
                  );
                },
              ),
              InkWell(
                onTap: () {
                  if (_isPlaying) {
                    _pauseAudio();
                  } else if (_selectedReciter != null) {
                    _playAudio(_selectedReciter!.link);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF9F1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: const Color(0xFF8B4513),
                    size: 32,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.fast_forward_outlined,
                  color: Color(0xFF8B4513),
                ),
                onPressed: () {
                  final newPos = _position + const Duration(seconds: 10);
                  _audioPlayer.seek(newPos > _duration ? _duration : newPos);
                },
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF8B4513)),
                onPressed: () {
                  _audioPlayer.stop();
                  setState(() {
                    _isExpanded = false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
