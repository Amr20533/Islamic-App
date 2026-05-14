import 'package:flutter/material.dart';

class SurahHeader extends StatelessWidget {
  const SurahHeader({super.key, required this.page, this.juz});
  final int page;
  final int? juz;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(color: Colors.green.withOpacity(0.05)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("الجزء $juz", style: const TextStyle(color: Colors.grey)),
          Text("صفحة $page", style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
