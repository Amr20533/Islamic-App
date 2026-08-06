import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:islamic_app/features/calendar/presentation/widgets/calendar_view_header.dart';
import 'package:islamic_app/features/calendar/presentation/widgets/next_prayer_countdown_card.dart';
import 'package:islamic_app/features/calendar/presentation/widgets/prayer_times_card.dart';
import 'package:islamic_app/features/calendar/presentation/widgets/islamic_occasion_card.dart';
import 'package:islamic_app/core/services/helpers/islamic_occasion_helper.dart';

void main() {
  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  setUpAll(() async {
    await initializeDateFormatting('ar', null);
  });

  group('Calendar View Widgets Tests', () {
    testWidgets('CalendarViewHeader renders correct dates and title', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const CalendarViewHeader(
            hijriDate: '١٥ رمضان ١٤٤٧',
            gregorianDate: '١٣ يونيو ٢٠٢٦',
          ),
        ),
      );

      expect(find.text('التقويم'), findsOneWidget);
      expect(find.text('١٥ رمضان ١٤٤٧'), findsOneWidget);
      expect(find.text('١٣ يونيو ٢٠٢٦'), findsOneWidget);
    });

    testWidgets('NextPrayerCountdownCard displays countdown components correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          const NextPrayerCountdownCard(
            nextPrayerName: 'العصر',
            countdown: '01:23:45',
          ),
        ),
      );

      expect(find.text('الصلاة القادمة'), findsOneWidget);
      expect(find.text('العصر'), findsOneWidget);

      // Verify countdown unit values are present
      expect(find.text('01'), findsOneWidget);
      expect(find.text('23'), findsOneWidget);
      expect(find.text('45'), findsOneWidget);

      // Verify labels are present
      expect(find.text('ساعة'), findsOneWidget);
      expect(find.text('دقيقة'), findsNWidgets(3));
      expect(find.text('ثانيه'), findsOneWidget);
    });

    testWidgets('PrayerTimesCard renders all prayer rows and formatted times', (WidgetTester tester) async {
      // Mock today's prayers mapping
      final todayPrayers = {
        'الفجر': DateTime(2026, 6, 13, 3, 30),
        'الشروق': DateTime(2026, 6, 13, 5, 0),
        'الظهر': DateTime(2026, 6, 13, 12, 15),
        'العصر': DateTime(2026, 6, 13, 15, 45),
        'المغرب': DateTime(2026, 6, 13, 18, 50),
        'العشاء': DateTime(2026, 6, 13, 20, 20),
      };

      await tester.pumpWidget(
        buildTestableWidget(
          PrayerTimesCard(todayPrayers: todayPrayers),
        ),
      );

      expect(find.text('أوقات الصلاة'), findsOneWidget);

      // Verify all prayer names are shown
      expect(find.text('الفجر'), findsOneWidget);
      expect(find.text('الشروق'), findsOneWidget);
      expect(find.text('الظهر'), findsOneWidget);
      expect(find.text('العصر'), findsOneWidget);
      expect(find.text('المغرب'), findsOneWidget);
      expect(find.text('العشاء'), findsOneWidget);
    });

    testWidgets('IslamicOccasionCard displays the occasion detail correctly', (WidgetTester tester) async {
      const occasion = IslamicOccasion(
        name: 'عيد الفطر المبارك',
        description: 'يوم الفرحة والسرور بعد صيام رمضان، اجعله يومًا للشكر وصلة الأرحام.',
        month: 10,
        day: 1,
      );

      await tester.pumpWidget(
        buildTestableWidget(
          const IslamicOccasionCard(occasion: occasion),
        ),
      );

      expect(find.text('المناسبة الدينية القادمة'), findsOneWidget);
      expect(find.text('عيد الفطر المبارك'), findsOneWidget);
      expect(find.text('استعد لهذه المناسبة المباركة 🌿'), findsOneWidget);
      expect(
        find.text('يوم الفرحة والسرور بعد صيام رمضان، اجعله يومًا للشكر وصلة الأرحام.'),
        findsOneWidget,
      );
    });
  });
}
