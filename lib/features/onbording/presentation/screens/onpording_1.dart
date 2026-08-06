import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';
import 'package:islamic_app/core/widgets/custom_app_bar.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_cubit.dart';

class Onpording1 extends StatefulWidget {
  const Onpording1({super.key});

  @override
  State<Onpording1> createState() => _Onpording1State();
}

class _Onpording1State extends State<Onpording1> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const CustomAppBar(title: 'معلومات بسيطة عنك', isBack: true),

                const SizedBox(height: 24),

                Text(
                  'ما اسمك ؟',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
                const SizedBox(height: 32),

                // ── Name field (required) ─────────────────────────────
                TextFormField(
                  controller: _nameController,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'من فضلك أدخل اسمك';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'ما الاسم الذي تفضّله',
                    hintStyle: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      color: AppColors.hintTextColor,
                    ),
                    errorStyle: const TextStyle(fontFamily: 'Tajawal'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.redAccent),
                    ),
                  ),
                ),

                const Spacer(),

                // ── Next button ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 24),
                  child: AppPrimaryButton(
                    onPressed: () async {
                      if (!(_formKey.currentState?.validate() ?? false)) return;

                      // Save name to ProfileCubit (persisted in SharedPrefs)
                      await context.read<ProfileCubit>().updateProfileName(
                        _nameController.text.trim(),
                      );

                      if (!context.mounted) return;
                      Navigator.pushNamed(context, AppRoutes.chooseAPicture);
                    },
                    label: 'التالي',
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
