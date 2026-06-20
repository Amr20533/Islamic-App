import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/azkar/data/models/azkar_category.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/azkar_cubit.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/azkar_search_bar.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/electronic_tasbeeh_card.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/featured_azkar_grid.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/other_azkar_list.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/zikr_header.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';

class ZikrView extends StatefulWidget {
  const ZikrView({super.key});

  @override
  State<ZikrView> createState() => _ZikrViewState();
}

class _ZikrViewState extends State<ZikrView> {
  String _searchQuery = "";
  final Set<int> _featuredIds = {27, 28, 1, 15};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AzkarCubit>().loadCategories();
    });
  }

  void _navigateToDetail(String title, int categoryId) {
    Navigator.pushNamed(
      context,
      AppRoutes.azkarDetail,
      arguments: {
        'categoryTitle': title,
        'categoryId': categoryId,
      },
    ).then((_) {
      if (mounted) {
        context.read<AzkarCubit>().loadCategories();
      }
    });
  }

  List<AzkarCategory> _filterCategories(List<AzkarCategory> categories) {
    if (_searchQuery.isEmpty) return categories;
    return categories
        .where((cat) => cat.title.contains(_searchQuery))
        .toList();
  }

  List<AzkarCategory> _getRemainingCategories(List<AzkarCategory> categories) {
    return categories
        .where((cat) => !_featuredIds.contains(cat.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFCFBF9),
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<AzkarCubit, AzkarState>(
            builder: (context, state) {
              if (state is AzkarLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final List<AzkarCategory> categories =
                  state is AzkarCategoriesLoaded ? state.categories : [];

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: ZikrHeader()),
                  _buildSearchBar(),
                  ..._buildContent(categories),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: AzkarSearchBar(
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
      ),
    );
  }

  List<Widget> _buildContent(List<AzkarCategory> categories) {
    if (_searchQuery.isNotEmpty) {
      final filteredList = _filterCategories(categories);
      return [
        OtherAzkarList(
          title: "نتائج البحث (${filteredList.length})",
          categories: filteredList,
          onNavigate: _navigateToDetail,
          isSearchMode: true,
        ),
      ];
    }

    return [
      SliverToBoxAdapter(
        child: FeaturedAzkarGrid(onNavigate: _navigateToDetail),
      ),
      SliverToBoxAdapter(child: _buildElectronicTasbeehCard()),
      OtherAzkarList(
        title: "باقي الأذكار والأدعية",
        categories: _getRemainingCategories(categories),
        onNavigate: _navigateToDetail,
      ),
    ];
  }

  Widget _buildElectronicTasbeehCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: ElectronicTasbeehCard(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.electronicTasbeeh,
          );
        },
      ),
    );
  }
}
