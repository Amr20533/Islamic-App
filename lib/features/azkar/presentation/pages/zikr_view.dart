import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/features/azkar/data/models/azkar_category.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/azkar_cubit.dart';
import 'azkar_details_screen.dart';

class ZikrView extends StatelessWidget {
  const ZikrView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<AzkarCubit, AzkarState>(
        builder: (context, state) {
          List<AzkarCategory> categories = [];
          if (state is AzkarCategoriesLoaded) {
            categories = state.categories;
          } else if (state is AzkarLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = categories.isNotEmpty ? categories : AzkarCategory.azkar;

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final cat = list[index];
              return ListTile(
                title: Text(cat.title, textAlign: TextAlign.right),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<AzkarCubit>(),
                        child: AzkarDetailScreen(
                          title: cat.title,
                          categoryId: cat.id,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
