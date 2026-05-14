import 'package:flutter/material.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';

class DailyDuaView extends StatelessWidget {
  const DailyDuaView({super.key});

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
          title: Text("دعاء اليوم", style: AppTextStyles.textTheme.titleLarge),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                child: Text(
                  "\"اللهم أنت ربي لا إله إلا أنت خلقتني وأنا عبدك وأنا على عهدك ووعدك ما استطعت، أعوذ بك من شر ما صنعت، أبوء لك بنعمتك علي وأبوء بذنبي فاغفر لي فإنه لا يغفر الذنوب إلا أنت.\"",
                  style: AppTextStyles.textTheme.labelSmall!.copyWith(
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              const Spacer(flex: 1),
              AppPrimaryButton(
                width: 116,
                onPressed: () {
                  Navigator.pop(context);
                },
                label: 'تم',
              ),
              const SizedBox(height: 37),
            ],
          ),
        ),
      ),
    );
  }
}
