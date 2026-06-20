import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/features/profile/presentation/widgets/interactive_rating_stars.dart';
import 'package:islamic_app/features/profile/presentation/widgets/rating_comment_field.dart';
import 'package:islamic_app/features/profile/presentation/widgets/rating_success_dialog.dart';

class RateAppView extends StatefulWidget {
  const RateAppView({super.key});

  @override
  State<RateAppView> createState() => _RateAppViewState();
}

class _RateAppViewState extends State<RateAppView> {
  final _commentController = TextEditingController();
  int _selectedRating = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitRating() {
    if (_selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى اختيار التقييم بالنجوم أولاً',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Mimic API/Database call
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // Show Custom Success/Thank you Dialog helper
      showRatingSuccessDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F5F0),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF7F5F0),
          elevation: 0,
          leading: Container(),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryTextColor,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          centerTitle: true,
          title: const Text(
            'تقييم التطبيق',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.counterColor,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 12),

                // Instructions / Header
                const Text(
                  'يسعدنا أن نعرف رأيك في تطبيقنا لكي نتمكن من تحسين خدماتنا وتقديم الأفضل لك دائماً.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryTextColor,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 36),

                // Reusable Interactive Stars Widget
                InteractiveRatingStars(
                  rating: _selectedRating,
                  onRatingChanged: (value) {
                    setState(() {
                      _selectedRating = value;
                    });
                  },
                ),

                const SizedBox(height: 28),

                // Optional comment section title
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'التعليق (اختياري)',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.counterColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Reusable Comment Field Widget
                RatingCommentField(controller: _commentController),

                const SizedBox(height: 40),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitRating,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'إرسال التقييم',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
