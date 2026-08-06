import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';

class ZikrHeader extends StatelessWidget {
  const ZikrHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            "الأذكار",
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.counterColor,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Color(0xFF3D3020),
                size: 32,
              ),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.main),
            ),
          ),
        ],
      ),
    );
  }
}
