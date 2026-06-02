import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/features/azkar/data/models/azkar_category.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/remaining_azkar_tile.dart';

class OtherAzkarList extends StatelessWidget {
  final List<AzkarCategory> categories;
  final String? title;
  final Function(String title, int id) onNavigate;
  final bool isSearchMode;

  const OtherAzkarList({
    super.key,
    required this.categories,
    this.title,
    required this.onNavigate,
    this.isSearchMode = false,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty && isSearchMode) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Text(
              "لم يتم العثور على نتائج للبحث",
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
                color: AppColors.greyColor,
              ),
            ),
          ),
        ),
      );
    }

    return MultiSliver(
      children: [
        if (title != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                right: 24,
                left: 24,
                top: 20,
                bottom: 12,
              ),
              child: Text(
                title!,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: isSearchMode ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: isSearchMode
                      ? AppColors.primaryColor
                      : AppColors.primaryTextColor.withOpacity(0.9),
                ),
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final cat = categories[index];
              return RemainingAzkarTile(
                index: cat.id,
                title: cat.title,
                onTap: () => onNavigate(cat.title, cat.id),
              );
            }, childCount: categories.length),
          ),
        ),
      ],
    );
  }
}

class MultiSliver extends StatelessWidget {
  final List<Widget> children;
  const MultiSliver({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(slivers: children);
  }
}
