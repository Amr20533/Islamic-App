import 'package:flutter/material.dart';

const Color _kBeige = Color(0xFFFBF9F1);

/// Full-page Mushaf frame - clean cream background without decorative frame image.
class MushafPageFrame extends StatelessWidget {
  final Widget child;
  const MushafPageFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(color: _kBeige, child: child);
  }
}
