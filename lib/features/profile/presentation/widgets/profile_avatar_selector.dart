import 'dart:io';
import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class ProfileAvatarSelector extends StatelessWidget {
  final String? imagePath;
  final String? gender;
  final VoidCallback onEditTap;
  final double size;

  const ProfileAvatarSelector({
    super.key,
    required this.imagePath,
    this.gender,
    required this.onEditTap,
    this.size = 156.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderColor2, width: 2),
            ),
            child: ClipOval(
              child: imagePath != null && File(imagePath!).existsSync()
                  ? Image.file(File(imagePath!), fit: BoxFit.cover)
                  : Image.asset(
                      gender == 'female'
                          ? 'assets/images/Ellipse 12 (1).png'
                          : gender == 'male'
                          ? 'assets/images/Ellipse 12.png'
                          : 'assets/images/avatar_1.jpg',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Positioned(
            bottom: 4,
            left: 4,
            child: GestureDetector(
              onTap: onEditTap,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderColor2, width: 1.5),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
