import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingImagePicker extends StatelessWidget {
  const OnboardingImagePicker({
    super.key,
    required this.imageBytes,
    required this.onTap,
  });

  final Uint8List? imageBytes;
  final VoidCallback onTap;

  static const double _size = 180;
  static const Color _borderColor = Color(0xFFD8CFC6);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: _size,
        height: _size,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: _borderColor),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _borderColor),
          ),
          child: ClipOval(
            child: imageBytes != null
                ? Image.memory(
                    imageBytes!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Center(
                    child: SvgPicture.asset(
                      'assets/svg/Vector.svg',
                      width: 40,
                      height: 40,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
