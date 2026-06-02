import 'package:flutter/material.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/zikr_category_card.dart';

class FeaturedAzkarGrid extends StatelessWidget {
  final Function(String title, int id) onNavigate;

  const FeaturedAzkarGrid({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        children: [
          ZikrCategoryCard(
            title: 'أذكار الصباح',
            backgroundImage: 'assets/images/2 87.png',
            iconImage: 'assets/images/Ellipse 2.png',
            onTap: () => onNavigate('أذكار الصباح', 27),
          ),
          ZikrCategoryCard(
            title: 'أذكار المساء',
            backgroundImage: 'assets/images/1 77.png',
            iconImage: 'assets/images/Ellipse 2 (2).png',
            onTap: () => onNavigate('أذكار المساء', 27),
          ),
          ZikrCategoryCard(
            title: 'أذكار بعد الصلاة',
            backgroundImage: 'assets/images/3 1.png',
            iconImage: 'assets/images/Ellipse 2 (3).png',
            onTap: () => onNavigate('أذكار بعد الصلاة', 15),
          ),
          ZikrCategoryCard(
            title: 'أذكار النوم',
            backgroundImage: 'assets/images/4 1.png',
            iconImage: 'assets/images/Ellipse 2 (1).png',
            onTap: () => onNavigate('أذكار النوم', 28),
          ),
        ],
      ),
    );
  }
}
