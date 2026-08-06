import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/email_service.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/features/profile/presentation/widgets/rating_comment_field.dart';
import 'package:islamic_app/features/profile/presentation/widgets/rating_success_dialog.dart';

class RateAppView extends StatefulWidget {
  const RateAppView({super.key});

  @override
  State<RateAppView> createState() => _RateAppViewState();
}

class _RateAppViewState extends State<RateAppView> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final success = await EmailService.sendFeedback(
        feedbackText: _commentController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (success) {
        _commentController.clear();
        showRatingSuccessDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تعذر فتح تطبيق البريد الإلكتروني.',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.right,
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
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
            child: Form(
              key: _formKey,
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
                  const SizedBox(height: 28),

                  // Comment section title
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'الرأي أو الملاحظات',
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
                      onPressed: _isLoading ? null : _submitFeedback,
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
      ),
    );
  }
}
