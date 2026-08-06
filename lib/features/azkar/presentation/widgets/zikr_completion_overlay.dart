import 'package:flutter/material.dart';

class ZikrCompletionOverlay extends StatelessWidget {
  final String categoryTitle;
  final VoidCallback onDone;

  const ZikrCompletionOverlay({
    super.key,
    required this.categoryTitle,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.35),
        child: Center(
          child: Container(
            width: 310,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 36,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEAE3),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEAE3),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFD4CFC5),
                      width: 1.5,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check,
                      color: Color(0xFF7A8C5A),
                      size: 42,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "أحسنت",
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D3020),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "أكملت $categoryTitle",
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 15,
                    color: Color(0xFF8A7560),
                  ),
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: 220,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: onDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8C6D53),
                      elevation: 2,
                      shadowColor: Colors.black.withOpacity(0.15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "تم",
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
