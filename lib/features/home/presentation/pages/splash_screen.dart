import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadApp();
  }

  void _loadApp() async {
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [Color(0xFF8B6B4F), Color(0xFF3E2F25)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/logo.png', width: 200),
            const SizedBox(height: 32),
            // Your Text
            Text(
              "عُد… ولو بخطوة بسيطة",
              style: AppTextStyles.textTheme.labelMedium!.copyWith(
                color: context.surfaceColor,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
