import 'package:flutter/material.dart';

class TasbeehHeader extends StatelessWidget {
  final VoidCallback onReset;

  const TasbeehHeader({
    super.key,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SizedBox(
        height: 56,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Text(
              "المسبحة الإلكترونية",
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D3020),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(
                  Icons.chevron_right,
                  color: Color(0xFF3D3020),
                  size: 32,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Color(0xFF3D3020),
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
