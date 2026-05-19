import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/adhan_bloc.dart';
import 'package:islamic_app/features/prayer/presentation/bloc/adhan_event.dart';

class AdanView extends StatelessWidget {
  const AdanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.notifications_active, size: 100, color: Colors.teal),
            const SizedBox(height: 20),
            const Text(
              "نظام تنبيه الأذان",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                context.read<AdhanBloc>().add(const AdhanPlayEvent("العصر"));
              },
              child: const Text("تشغيل تجريبي"),
            ),
          ],
        ),
      ),
    );
  }
}
