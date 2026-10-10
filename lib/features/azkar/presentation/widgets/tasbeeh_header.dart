import 'package:flutter/material.dart';

class TasbeehHeader extends StatelessWidget {
  final VoidCallback onReset;

  const TasbeehHeader({
    super.key,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SizedBox(
        height: 56,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              "المسبحة الإلكترونية",
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFFC8A88A) : const Color(0xFF3D3020),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: isDark ? const Color(0xFFF5F2EE) : const Color(0xFF3D3020),
                  size: 32,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  color: isDark ? const Color(0xFFC8A88A) : const Color(0xFF3D3020),
                  size: 28,
                ),
                onPressed: onReset,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
