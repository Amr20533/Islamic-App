import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';
import 'package:islamic_app/features/calendar/presentation/widgets/brown_checkbox.dart';

class FardPrayersCard extends StatelessWidget {
  final List<bool> fardStates;
  final int fardCount;
  final Function(int) onToggle;

  final List<String> _fardNames = [
    'الفجر',
    'الظهر',
    'العصر',
    'المغرب',
    'العشاء',
  ];

  FardPrayersCard({
    super.key,
    required this.fardStates,
    required this.fardCount,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF242220) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: const Color(0xFF383430), width: 1) : null,
        boxShadow: isDark
            ? const []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.circle_notifications,
                color: isDark ? const Color(0xFFC8A88A) : AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'الفروض الخمسة',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFFF5F2EE) : AppColors.primaryTextColor,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF383430)
                      : (fardCount >= 3 ? Colors.green[50] : Colors.amber[50]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  FormatHelper.replaceWithArabicNumbers("$fardCount من ٥"),
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? const Color(0xFFC8A88A)
                        : (fardCount >= 3 ? Colors.green[700] : Colors.brown[600]),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 24,
            color: isDark ? const Color(0xFF383430) : null,
          ),

          // List of 5 prayers
          ...List.generate(5, (index) {
            final isChecked = fardStates[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: InkWell(
                onTap: () => onToggle(index),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _fardNames[index],
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 16,
                          fontWeight: isChecked
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: isChecked
                              ? (isDark ? const Color(0xFFC8A88A) : AppColors.primaryColor)
                              : (isDark ? const Color(0xFFF5F2EE) : AppColors.primaryTextColor),
                        ),
                      ),
                      BrownCheckbox(isChecked: isChecked),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 12),

          // Minimum 3 prayers check
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E1C1A)
                  : (fardCount >= 3
                      ? Colors.green[50]?.withOpacity(0.5)
                      : Colors.amber[50]?.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF383430)
                    : (fardCount >= 3 ? Colors.green[100]! : Colors.amber[100]!),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  fardCount >= 3 ? Icons.lock_open : Icons.lock,
                  color: isDark
                      ? const Color(0xFFC8A88A)
                      : (fardCount >= 3 ? Colors.green[700] : Colors.brown[600]),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    fardCount >= 3
                        ? "تم تفعيل نقاط الفروض!  (+${fardCount * 10} نقطة)"
                        : "أدّ ٣ فروض على الأقل لتفعيل نقاط الفروض اليومية ",
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFFB8AEA5)
                          : (fardCount >= 3 ? Colors.green[800] : Colors.brown[600]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
