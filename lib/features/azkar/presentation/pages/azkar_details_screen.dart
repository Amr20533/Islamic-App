import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/azkar_cubit.dart';

class AzkarDetailScreen extends StatelessWidget {
  final String title;
  const AzkarDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.lightGreyColor,
        appBar: AppBar(
          backgroundColor: AppColors.lightGreyColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: context.primaryColor,
              size: 18,
            ),
          ),
          title: Text(title, style: AppTextStyles.textTheme.titleLarge),
        ),
        body: BlocBuilder<AzkarCubit, AzkarState>(
          builder: (context, state) {
            if (state is AzkarLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AzkarDetailsLoaded) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.zikrList.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final item = state.zikrList[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.arabicText,
                        textAlign: TextAlign.justify,
                        style: AppTextStyles.textTheme.bodyLarge!.copyWith(
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Chip(
                        label: Text("التكرار: ${item.repeat}"),
                        backgroundColor: AppColors.thirdColor,
                      ),
                    ],
                  );
                },
              );
            }
            return const Center(child: Text("لا توجد بيانات"));
          },
        ),
      ),
    );
  }
}
