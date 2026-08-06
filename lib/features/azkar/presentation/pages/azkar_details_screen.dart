import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/azkar_cubit.dart';
import 'package:islamic_app/features/azkar/data/models/zikr_item.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/zikr_detail_header.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/zikr_detail_item.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/zikr_detail_bottom_nav.dart';
import 'package:islamic_app/features/azkar/presentation/widgets/zikr_completion_overlay.dart';

class AzkarDetailScreen extends StatefulWidget {
  final String categoryTitle;
  final int categoryId;
  final List<ZikrItem>? zikrList;

  const AzkarDetailScreen({
    super.key,
    required this.categoryTitle,
    required this.categoryId,
    this.zikrList,
  });

  @override
  State<AzkarDetailScreen> createState() => _AzkarDetailScreenState();
}

class _AzkarDetailScreenState extends State<AzkarDetailScreen> {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _showCompletionOverlay = false;
  final Map<int, int> _remainingRepeats = {};

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (widget.zikrList == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<AzkarCubit>().loadZikrDetails(widget.categoryId, widget.categoryTitle);
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed(int totalPages) {
    if (_currentIndex < totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      HapticFeedback.mediumImpact();
      setState(() => _showCompletionOverlay = true);
    }
  }

  void _onPrevPressed() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _decrementRepetition(ZikrItem item, int totalPages) {
    final currentRemaining = _remainingRepeats[_currentIndex] ?? item.repeat;
    if (currentRemaining > 0) {
      HapticFeedback.lightImpact();
      setState(() => _remainingRepeats[_currentIndex] = currentRemaining - 1);

      if (currentRemaining - 1 == 0) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted && _currentIndex < totalPages) {
            _onNextPressed(totalPages);
          }
        });
      }
    }
  }

  String _getBackgroundImage() {
    switch (widget.categoryTitle) {
      case 'أذكار الصباح':
        return 'assets/images/alzker alsbah (1).png';
      case 'أذكار المساء':
        return "assets/images/alzker msa'a.png";
      case 'أذكار بعد الصلاة':
        return 'assets/images/alzker befor salah.png';
      case 'أذكار النوم':
        return 'assets/images/alzker go to sleep.png';
      default:
        return 'assets/images/alzker alsbah (1).png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 244, 231, 220),
        body: SafeArea(
          child: widget.zikrList != null
              ? _buildContent(widget.zikrList!)
              : BlocBuilder<AzkarCubit, AzkarState>(
                  builder: (context, state) {
                    if (state is AzkarLoading) {
                      return _buildLoadingState();
                    }
                    if (state is AzkarError) {
                      return _buildErrorState(state.message);
                    }
                    if (state is AzkarDetailsLoaded) {
                      return state.zikrList.isEmpty
                          ? _buildEmptyState()
                          : _buildContent(state.zikrList);
                    }
                    return _buildLoadingState();
                  },
                ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ZikrDetailHeader(title: widget.categoryTitle),
        ),
        const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B5040)),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ZikrDetailHeader(title: widget.categoryTitle),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
                color: Color(0xFF3D3020),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ZikrDetailHeader(title: widget.categoryTitle),
        ),
        const Center(
          child: Text(
            "لا توجد أذكار في هذا القسم",
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 16,
              color: Color(0xFF3D3020),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(List<ZikrItem> zikrList) {
    final totalPages = zikrList.length;

    return Stack(
      children: [
        _buildBackground(),
        _buildPageView(zikrList, totalPages),
        _buildBottomNavigation(totalPages),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ZikrDetailHeader(title: widget.categoryTitle),
        ),
        if (_showCompletionOverlay)
          ZikrCompletionOverlay(
            categoryTitle: widget.categoryTitle,
            onDone: () => Navigator.pop(context),
          ),
      ],
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.3,
        child: Image.asset(_getBackgroundImage(), fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildPageView(List<ZikrItem> zikrList, int totalPages) {
    return Positioned.fill(
      top: 56,
      bottom: 120,
      child: PageView.builder(
        controller: _pageController,
        physics: const BouncingScrollPhysics(),
        onPageChanged: (index) {
          HapticFeedback.lightImpact();
          setState(() => _currentIndex = index);
        },
        itemCount: totalPages,
        itemBuilder: (context, index) {
          final item = zikrList[index];
          final remaining = _remainingRepeats[index] ?? item.repeat;

          return ZikrDetailItem(
            item: item,
            remaining: remaining,
            onTap: () => _decrementRepetition(item, totalPages),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigation(int totalPages) {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: ZikrDetailBottomNav(
        currentIndex: _currentIndex,
        totalPages: totalPages,
        onNext: () => _onNextPressed(totalPages),
        onPrev: _onPrevPressed,
      ),
    );
  }
}
