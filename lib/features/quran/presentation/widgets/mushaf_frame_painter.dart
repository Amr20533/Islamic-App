import 'package:flutter/material.dart';

const Color _kBeige = Color(0xFFFBF9F1);

/// Full-page Mushaf frame - clean cream background without decorative frame image.
class MushafPageFrame extends StatelessWidget {
  final Widget child;
  const MushafPageFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? const Color(0xFF1B1A18) : _kBeige,
      child: child,
    );
  }
}
