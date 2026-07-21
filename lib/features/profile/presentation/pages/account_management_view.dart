import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_cubit.dart';
import 'package:islamic_app/features/profile/presentation/bloc/profile_state.dart';
import 'package:islamic_app/features/profile/presentation/widgets/account_field_row.dart';
import 'package:islamic_app/features/profile/presentation/widgets/profile_avatar_selector.dart';

class AccountManagementView extends StatelessWidget {
  const AccountManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: _AccountManagementContent(),
    );
  }
}

class _AccountManagementContent extends StatelessWidget {
  const _AccountManagementContent();

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedFile = await File(
          pickedFile.path,
        ).copy('${directory.path}/$fileName');
        if (context.mounted) {
          context.read<ProfileCubit>().updateProfileImage(savedFile.path);
        }
      } catch (e) {
        debugPrint("Error picking/saving image: $e");
      }
    }
  }

  void _showEditDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
    required Function(String) onSave,
    bool isPassword = false,
  }) {
    final controller = TextEditingController(
      text: isPassword ? "" : initialValue,
    );
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: const Color(0xFFF7F5F0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.borderColor2, width: 1.5),
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.counterColor,
              ),
            ),
            content: TextField(
              controller: controller,
              obscureText: isPassword,
              autofocus: true,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderColor2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final val = controller.text.trim();
                  if (val.isNotEmpty) {
                    onSave(val);
                  }
                  Navigator.pop(dialogContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'حفظ',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'إدارة الحساب',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.counterColor,
          ),
        ),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          if (state is ProfileLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // ── Circular Avatar with Edit Overlay ────────────────────
                  ProfileAvatarSelector(
                    imagePath: state.profileImagePath,
                    gender: state.gender,
                    onEditTap: () => _pickImage(context),
                  ),

                  const SizedBox(height: 48),

                  // ── Name Row ─────────────────────────────────────────────
                  AccountFieldRow(
                    onEdit: () => _showEditDialog(
                      context: context,
                      title: 'تعديل الاسم',
                      initialValue: state.profileName,
                      onSave: (val) =>
                          context.read<ProfileCubit>().updateProfileName(val),
                    ),

                    value: state.profileName,
                    icon: SvgPicture.asset(
                      "assets/icons/user.svg",
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Email Row ────────────────────────────────────────────
                  AccountFieldRow(
                    value: state.profileEmail,
                    icon: SvgPicture.asset(
                      'assets/icons/email.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    onEdit: () => _showEditDialog(
                      context: context,
                      title: 'تعديل البريد الإلكتروني',
                      initialValue: state.profileEmail,
                      onSave: (val) =>
                          context.read<ProfileCubit>().updateProfileEmail(val),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Password Row ─────────────────────────────────────────
                  AccountFieldRow(
                    value: '*' * state.profilePassword.length,
                    icon: SvgPicture.asset(
                      'assets/icons/lock.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primaryColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    onEdit: () => _showEditDialog(
                      context: context,
                      title: 'تعديل كلمة المرور',
                      initialValue: state.profilePassword,
                      isPassword: true,
                      onSave: (val) => context
                          .read<ProfileCubit>()
                          .updateProfilePassword(val),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
