import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/email_service.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/features/profile/presentation/widgets/problem_type_dropdown.dart';
import 'package:islamic_app/features/profile/presentation/widgets/problem_description_field.dart';

class ReportProblemView extends StatefulWidget {
  const ReportProblemView({super.key});

  @override
  State<ReportProblemView> createState() => _ReportProblemViewState();
}

class _ReportProblemViewState extends State<ReportProblemView> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String? _selectedProblemType;
  bool _isLoading = false;

  final List<String> _problemTypes = ['تعطل', 'صوت', 'تحديث', 'أخرى'];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedProblemType == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'يرجى اختيار نوع المشكلة أولاً',
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

      final success = await EmailService.sendBugReport(
        problemType: _selectedProblemType!,
        problemDescription: _descriptionController.text,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (success) {
        _descriptionController.clear();
        setState(() {
          _selectedProblemType = null;
        });
        Navigator.pop(context);
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Container(),
          actions: [
            IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: isDark
                    ? const Color(0xFFF5F2EE)
                    : AppColors.primaryTextColor,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
          centerTitle: true,
          title: Text(
            'الإبلاغ عن مشكلة',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? const Color(0xFFF5F2EE) : AppColors.counterColor,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Instruction text
                  Text(
                    'يسعدنا سماع ملاحظاتك لحل أي مشكلة تواجهك في أسرع وقت.',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? const Color(0xFFB8AEA5)
                          : AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Dropdown Header
                  Text(
                    'نوع المشكلة',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? const Color(0xFFF5F2EE)
                          : AppColors.counterColor,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Reusable dropdown widget
                  ProblemTypeDropdown(
                    selectedValue: _selectedProblemType,
                    items: _problemTypes,
                    onChanged: (value) {
                      setState(() {
                        _selectedProblemType = value;
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // Description Header
                  Text(
                    'وصف المشكلة',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? const Color(0xFFF5F2EE)
                          : AppColors.counterColor,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Reusable description field widget
                  ProblemDescriptionField(controller: _descriptionController),

                  const SizedBox(height: 40),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? const Color(0xFFC8A88A)
                            : AppColors.primaryColor,
                        foregroundColor: isDark
                            ? const Color(0xFF141312)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: isDark
                                    ? const Color(0xFF141312)
                                    : Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'إرسال',
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
