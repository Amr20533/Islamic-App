import 'package:flutter/material.dart';

class CustomAssetImage extends StatelessWidget {
  const CustomAssetImage({
    super.key, required this.image,
    this.width = 200,
    this.height
  });
  final String image;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      width: width,
      height: height,
      cacheWidth: (200 * MediaQuery.of(context).devicePixelRatio).round(),
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: child,
        );
      },
    );
  }
}