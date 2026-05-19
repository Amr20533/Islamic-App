import 'package:flutter/material.dart';

class Fatiha extends StatelessWidget {
  const Fatiha({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Text(
          "بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ",
          style: TextStyle(fontSize: 30, fontFamily: 'QuranFont'),
        ),
      ),
    );
  }
}
