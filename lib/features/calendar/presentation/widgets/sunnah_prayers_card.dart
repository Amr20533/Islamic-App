import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/services/helpers/format_helper.dart';
import 'package:islamic_app/features/calendar/presentation/widgets/brown_checkbox.dart';

class SunnahPrayersCard extends StatelessWidget {
  final List<bool> sunnahStates;
  final Function(int) onToggle;

  final List<String> _sunnahNames = [
    'سنة الفجر (ركعتان قبلها)',
    'سنة الظهر القبلية (٤ ركعات)',
    'سنة الظهر البعدية (ركعتان)',
    'سنة المغرب البعدية (ركعتان)',
    'سنة العشاء البعدية (ركعتان)'
  ];
  final List<int> _sunnahPoints = [10, 20, 10, 10, 10];

  SunnahPrayersCard({
    super.key,
    required this.sunnahStates,
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
                )
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.stars,
                color: isDark ? const Color(0xFFC8A88A) : AppColors.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'السنن الرواتب',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? const Color(0xFFF5F2EE) : AppColors.primaryTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'مجموعها ١٢ ركعة تؤسس لك بيتاً في الجنة',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
              color: isDark ? const Color(0xFFB8AEA5) : Colors.grey[500],
            ),
          ),
          Divider(
            height: 24,
            color: isDark ? const Color(0xFF383430) : null,
          ),

          // List of 5 Sunnah items
          ...List.generate(5, (index) {
            final isChecked = sunnahStates[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: InkWell(
                onTap: () => onToggle(index),
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _sunnahNames[index],
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 15,
                              fontWeight: isChecked ? FontWeight.bold : FontWeight.w500,
                              color: isChecked
                                  ? (isDark ? const Color(0xFFC8A88A) : AppColors.primaryColor)
                                  : (isDark ? const Color(0xFFF5F2EE) : AppColors.primaryTextColor),
                            ),
                          ),
                          Text(
                            "+${FormatHelper.replaceWithArabicNumbers(_sunnahPoints[index].toString())} نقاط",
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                              color: isDark ? const Color(0xFFB8AEA5) : Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                      BrownCheckbox(isChecked: isChecked),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
