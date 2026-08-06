import 'package:flutter/material.dart';

class ZikrDetailHeader extends StatelessWidget {
  final String title;

  const ZikrDetailHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3D3020),
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
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
