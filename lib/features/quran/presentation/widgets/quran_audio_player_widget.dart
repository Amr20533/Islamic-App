import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:islamic_app/features/quran/data/models/audio_reciter.dart';
import 'package:islamic_app/features/quran/data/services/surah_audio_download_service.dart';

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
  List<AudioReciter> _filteredReciters = [];

  // Offline Download States
  bool _isDownloaded = false;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  final Map<String, bool> _downloadedRecitersMap = {};

  @override
  void initState() {
    super.initState();
    _filterReciters();
    if (_filteredReciters.isNotEmpty) {
      _selectedReciter = _filteredReciters.first;
      _checkDownloadStatus();
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
  void didUpdateWidget(covariant QuranAudioPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reciters != widget.reciters) {
      _filterReciters();
      if (_selectedReciter != null) {
        final exists = _filteredReciters.any(
          (r) => r.reciterNameAr == _selectedReciter!.reciterNameAr,
        );
        if (!exists && _filteredReciters.isNotEmpty) {
          _selectedReciter = _filteredReciters.first;
        } else if (exists) {
          _selectedReciter = _filteredReciters.firstWhere(
            (r) => r.reciterNameAr == _selectedReciter!.reciterNameAr,
          );
        }
      } else if (_filteredReciters.isNotEmpty) {
        _selectedReciter = _filteredReciters.first;
      }
      _checkDownloadStatus();
    }
  }

  Future<void> _checkDownloadStatus() async {
    if (_selectedReciter == null) return;
    final url = _selectedReciter!.link;
    final downloaded = await SurahAudioDownloadService().isDownloaded(url);

    // Also check for all reciters to update sheet indicators
    for (final reciter in _filteredReciters) {
      final isReciterDownloaded = await SurahAudioDownloadService().isDownloaded(reciter.link);
      _downloadedRecitersMap[reciter.link] = isReciterDownloaded;
    }

    if (mounted) {
      setState(() {
        _isDownloaded = downloaded;
      });
    }
  }

  void _filterReciters() {
    final allowedKeywords = [
      'العفاسي',
      'الدوسري',
      'فارس عباد',
      'المعيقلي',
      'سعد الغامدي',
      'العجمي',
      'القطامي',
      'المنشاوي',
      'الحصري',
      'عبدالباسط',
    ];

    final List<AudioReciter> result = [];
    final Set<String> seenNames = {};

    for (final keyword in allowedKeywords) {
      for (final reciter in widget.reciters) {
        final cleanName = reciter.reciterNameAr.trim().replaceAll(
          RegExp(r'\s+'),
          ' ',
        );
        if (cleanName.contains(keyword)) {
          if (!seenNames.contains(cleanName)) {
            seenNames.add(cleanName);
            result.add(reciter);
          }
        }
      }
    }

    _filteredReciters = result;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String url) async {
    final downloaded = await SurahAudioDownloadService().isDownloaded(url);
    if (downloaded) {
      final localPath = await SurahAudioDownloadService().getLocalFilePath(url);
      await _audioPlayer.play(DeviceFileSource(localPath));
    } else {
      await _audioPlayer.play(UrlSource(url));
    }
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
  }

  Future<void> _toggleDownload() async {
    if (_selectedReciter == null) return;
    final url = _selectedReciter!.link;

    if (_isDownloaded) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('حذف التنزيل', style: TextStyle(fontFamily: 'Tajawal')),
          content: const Text('هل تريد حذف الملف الصوتي لهذه السورة من الجهاز؟', style: TextStyle(fontFamily: 'Tajawal')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء', style: TextStyle(fontFamily: 'Tajawal')),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('حذف', style: TextStyle(fontFamily: 'Tajawal', color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await SurahAudioDownloadService().deleteAudio(url);
        await _checkDownloadStatus();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حذف التنزيل من الجهاز.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
      return;
    }

    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
    });

    await SurahAudioDownloadService().downloadAudio(
      url: url,
      onProgress: (progress) {
        if (mounted) {
          setState(() {
            _downloadProgress = progress;
          });
        }
      },
      onCompleted: (localPath) async {
        await _checkDownloadStatus();
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _isDownloaded = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم تنزيل السورة بنجاح للاستماع بدون إنترنت! 🟢'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isDownloading = false;
            _downloadProgress = 0.0;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF211F1D) : const Color(0xFFFBF9F1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'اختر القارئ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal',
                        color: isDark
                            ? const Color(0xFFF5F2EE)
                            : const Color(0xFF2C1C12),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _filteredReciters.length,
                      itemBuilder: (context, index) {
                        final reciter = _filteredReciters[index];
                        final isSelected = _selectedReciter?.id == reciter.id;
                        final isReciterDownloaded = _downloadedRecitersMap[reciter.link] ?? false;

                        return ListTile(
                          title: Row(
                            children: [
                              Text(
                                reciter.reciterNameAr,
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  color: isSelected
                                      ? (isDark
                                          ? const Color(0xFFC8A88A)
                                          : const Color(0xFF8B4513))
                                      : (isDark
                                          ? const Color(0xFFF5F2EE)
                                          : Colors.black),
                                ),
                              ),
                              if (isReciterDownloaded) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.offline_pin_rounded, color: Colors.green, size: 18),
                              ],
                            ],
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check,
                                  color: isDark
                                      ? const Color(0xFFC8A88A)
                                      : const Color(0xFF8B4513),
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedReciter = reciter;
                            });
                            _checkDownloadStatus();
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryAccent = isDark
        ? const Color(0xFFC8A88A)
        : const Color(0xFF8B4513);
    final secondaryText = isDark
        ? const Color(0xFFB8AEA5)
        : Colors.grey;

    if (!_isExpanded) {
      return InkWell(
        onTap: () {
          setState(() {
            _isExpanded = true;
          });
          widget.onExpanded();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _popupMenuKey.currentState?.showButtonMenu();
          });
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF242220) : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            Icons.play_arrow_outlined,
            color: primaryAccent,
            size: 30,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF211F1D) : Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: isDark ? const Color(0xFF383430) : Colors.transparent,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
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
                style: TextStyle(fontSize: 10, color: secondaryText),
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
                    activeTrackColor: primaryAccent,
                    inactiveTrackColor: isDark
                        ? const Color(0xFF383430)
                        : Colors.grey.withOpacity(0.3),
                    thumbColor: primaryAccent,
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
                style: TextStyle(fontSize: 10, color: secondaryText),
              ),
            ],
          ),
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PopupMenuButton<int>(
                key: _popupMenuKey,
                icon: Icon(Icons.more_horiz, color: primaryAccent),
                color: isDark ? const Color(0xFF2D2A26) : const Color(0xFFEBE6DF),
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
                        Text(
                          'اختيار القارئ',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: primaryAccent,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.person_outline,
                          color: primaryAccent,
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
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: primaryAccent,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.speed, color: primaryAccent),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'التكرار',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: primaryAccent,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _isRepeat ? Icons.repeat_on : Icons.repeat,
                          color: primaryAccent,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          _isDownloading
                              ? 'جاري التنزيل (${(_downloadProgress * 100).toInt()}%)'
                              : _isDownloaded
                                  ? 'محفوظة أوفلاين (حذف)'
                                  : 'تنزيل السورة (أوفلاين)',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                            color: _isDownloaded ? Colors.green : primaryAccent,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_isDownloading)
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              value: _downloadProgress,
                              strokeWidth: 2,
                              color: primaryAccent,
                            ),
                          )
                        else if (_isDownloaded)
                          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20)
                        else
                          Icon(Icons.download_for_offline_outlined, color: primaryAccent, size: 20),
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
                  } else if (value == 4) {
                    _toggleDownload();
                  }
                },
              ),
              // Direct Download Button Icon next to controls
              IconButton(
                tooltip: _isDownloaded ? 'منزلة أوفلاين' : 'تنزيل السورة',
                icon: _isDownloading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          value: _downloadProgress,
                          strokeWidth: 2.2,
                          color: primaryAccent,
                        ),
                      )
                    : Icon(
                        _isDownloaded
                            ? Icons.offline_pin_rounded
                            : Icons.download_for_offline_outlined,
                        color: _isDownloaded ? Colors.green : primaryAccent,
                        size: 24,
                      ),
                onPressed: _toggleDownload,
              ),
              IconButton(
                icon: Icon(
                  Icons.fast_rewind_outlined,
                  color: primaryAccent,
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
                    color: isDark
                        ? const Color(0xFF141312)
                        : const Color(0xFFFBF9F1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: primaryAccent,
                    size: 32,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.fast_forward_outlined,
                  color: primaryAccent,
                ),
                onPressed: () {
                  final newPos = _position + const Duration(seconds: 10);
                  _audioPlayer.seek(newPos > _duration ? _duration : newPos);
                },
              ),
              IconButton(
                icon: Icon(Icons.close, color: primaryAccent),
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
