import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';
import 'package:islamic_app/core/utils/app_responsive.dart';
import 'package:islamic_app/features/home/presentation/widgets/daily_plan_card.dart';
import 'package:islamic_app/features/home/presentation/widgets/home_header.dart';
import 'package:islamic_app/features/home/presentation/widgets/progress_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AppResponsive.isWeb(context)
            ? const _WebLayout()
            : AppResponsive.isTablet(context)
                ? const _TabletLayout()
                : const _MobileLayout(),
      ),
    );
  }
}

// ─── Shared date row ────────────────────────────────────────────────────────

class _DateRow extends StatelessWidget {
  const _DateRow();

  @override
  Widget build(BuildContext context) {
    final dateStyle = AppResponsive.labelStyle(context);
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(FormatHelper.getMiladFormattedDate(), style: dateStyle),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: VerticalDivider(
              width: 1,
              thickness: 0.5,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Text(FormatHelper.getHijriFormattedDate(), style: dateStyle),
        ],
      ),
    );
  }
}

// ─── Shared hadith text ─────────────────────────────────────────────────────

class _HadithText extends StatelessWidget {
  const _HadithText({this.textAlign = TextAlign.center});
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      '"أحبُّ الأعمالِ إلى اللهِ أدومُها وإن قلَّ"',
      style: AppResponsive.titleStyle(
        context,
        fontWeight: FontWeight.w400,
      ).copyWith(
        color: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFFF5F2EE)
            : null,
        height: 1.5,
      ),
      textAlign: textAlign,
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// MOBILE Layout  (< 600px)
// ═══════════════════════════════════════════════════════════════════════════

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          HomeHeader(),
          _DateRow(),
          _HadithText(),
          DailyPlanCard(),
          ProgressCard(
            icon: 'assets/icons/progress.png',
            leading: 'استمرارك ',
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// TABLET Layout  (>= 600px, non-web)
// ═══════════════════════════════════════════════════════════════════════════

class _TabletLayout extends StatelessWidget {
  const _TabletLayout();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Top bar: greeting + date ────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Expanded(child: HomeHeader()),
                  _DateRow(),
                ],
              ),
              const SizedBox(height: 24),

              // ── Hadith label + text ──────────────────────────────────────
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2E2A26)
                        : const Color(0xFFF0EBE5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'حديث اليوم',
                    style: AppResponsive.labelStyle(context,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? const Color(0xFFC8A88A)
                            : const Color(0xFF6B4F35)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const _HadithText(textAlign: TextAlign.right),
              const SizedBox(height: 24),

              // ── Two-column: plan card + progress ───────────────────────
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: const [
                    Expanded(flex: 5, child: DailyPlanCard()),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 5,
                      child: ProgressCard(
                        icon: 'assets/icons/progress.png',
                        leading: 'استمرارك ',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// WEB Layout  (kIsWeb == true)
// ═══════════════════════════════════════════════════════════════════════════

class _WebLayout extends StatelessWidget {
  const _WebLayout();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 28),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar ──────────────────────────────────────────────────
            const Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: HomeHeader()),
                  _DateRow(),
                ],
              ),
            ),
            const SizedBox(height: 36),

            // ── Main content: 2-column grid ─────────────────────────────
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left: hadith + streak
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Decorative label
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2E2A26)
                                : const Color(0xFFF0EBE5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'حديث اليوم',
                            style: AppResponsive.labelStyle(context,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? const Color(0xFFC8A88A)
                                    : const Color(0xFF6B4F35)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const _HadithText(textAlign: TextAlign.right),
                        const SizedBox(height: 32),
                        const ProgressCard(
                          icon: 'assets/icons/progress.png',
                          leading: 'استمرارك ',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 36),
                  // Right: daily plan
                  const Expanded(flex: 5, child: DailyPlanCard()),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
