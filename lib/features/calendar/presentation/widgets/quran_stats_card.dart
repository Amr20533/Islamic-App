import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/di/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranStatsCard extends StatefulWidget {
  const QuranStatsCard({super.key});

  @override
  State<QuranStatsCard> createState() => _QuranStatsCardState();
}

class _QuranStatsCardState extends State<QuranStatsCard> {
  int _lastPage = 0;
  int _weeklyDays = 0; // days read in the last 7 days
  int _currentStreak = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final prefs = locator<SharedPreferences>();
    final now = DateTime.now();

    // Last read page (out of 604)
    final lastPage = prefs.getInt('quran_sequential_last_page') ?? 0;

    // Count days read in the last 7 days & calculate streak
    int weeklyDays = 0;
    int streak = 0;
    bool streakBroken = false;

    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: i));
      final key = 'daily_quran_done_${day.year}-${day.month}-${day.day}';
      final done = prefs.getBool(key) ?? false;
      if (done) weeklyDays++;
      if (!streakBroken) {
        if (done) {
          streak++;
        } else if (i > 0) {
          // Allow today to be incomplete (it's still ongoing)
          streakBroken = true;
        }
      }
    }

    setState(() {
      _lastPage = lastPage;
      _weeklyDays = weeklyDays;
      _currentStreak = streak;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF282522) : AppColors.thirdColor;
    final labelColor = isDark
        ? const Color(0xFFB8AEA5)
        : AppColors.hintTextColor;
    final valueColor = isDark
        ? const Color(0xFFF5F2EE)
        : AppColors.counterColor;
    final accentColor = isDark
        ? const Color(0xFFC8A88A)
        : AppColors.primaryColor;
    final dividerColor = isDark
        ? const Color(0xFF383430)
        : AppColors.primaryColor.withValues(alpha: 0.15);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF282522) : bgColor,
        borderRadius: BorderRadius.circular(24),
        border: isDark
            ? Border.all(color: const Color(0xFF383430), width: 1)
            : null,
        image: DecorationImage(
          image: const ResizeImage(
            width: 800,
            AssetImage(
              'assets/images/Gemini_Generated_Image_p06u05p06u05p06u (1) 1.png',
            ),
          ),
          fit: BoxFit.cover,
          colorFilter: isDark
              ? ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.75),
                  BlendMode.darken,
                )
              : ColorFilter.mode(
                  Colors.white.withValues(alpha: 0.45),
                  BlendMode.lighten,
                ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ────────────────────────────────────────────
          Row(
            children: [
              Text(
                'وِردك القرآني',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
              Spacer(),
              Image.asset(
                'assets/icons/book.png',
                width: 20,
                height: 20,
                color: accentColor,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Stats row ─────────────────────────────────────────
          Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(
                  value: '${_lastPage > 0 ? _lastPage : "-"}',
                  label: 'الصفحة الحالية',
                  suffix: _lastPage > 0 ? '\nمن 604' : '',
                  valueColor: valueColor,
                  labelColor: labelColor,
                ),
                _Divider(color: dividerColor),
                _StatItem(
                  value: '$_weeklyDays',
                  label: 'أيام هذا الأسبوع',
                  suffix: '\nمن 7',
                  valueColor: valueColor,
                  labelColor: labelColor,
                ),
                _Divider(color: dividerColor),
                _StatItem(
                  value: '$_currentStreak',
                  label: 'سلسلة الأيام',
                  suffix: _currentStreak == 1 ? '\nيوم' : '\nأيام',
                  valueColor: valueColor,
                  labelColor: labelColor,
                ),
              ],
            ),
          ),

          // ── Progress bar ──────────────────────────────────────
          if (_lastPage > 0) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _lastPage / 604,
                minHeight: 5,
                backgroundColor: isDark
                    ? const Color(0xFF383430)
                    : AppColors.primaryColor.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${(_lastPage / 604 * 100).toStringAsFixed(1)}٪ من المصحف',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(color: labelColor),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Helper widgets ────────────────────────────────────────────────────────────

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.suffix,
    required this.valueColor,
    required this.labelColor,
  });

  final String value;
  final String label;
  final String suffix;
  final Color valueColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                    height: 1,
                  ),
                ),
                if (suffix.isNotEmpty)
                  TextSpan(
                    text: suffix,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 11,
                      color: labelColor,
                      height: 1.4,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 11,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 48, color: color);
  }
}
