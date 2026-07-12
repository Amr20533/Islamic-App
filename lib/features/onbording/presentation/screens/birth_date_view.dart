import 'package:flutter/material.dart';
import 'package:islamic_app/core/constants/date_constants.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_routes.dart';
import 'package:islamic_app/core/widgets/app_primary_button.dart';
import 'package:islamic_app/core/widgets/custom_app_bar.dart';

class BirthDateView extends StatefulWidget {
  const BirthDateView({super.key});

  @override
  State<BirthDateView> createState() => _BirthDateViewState();
}

class _BirthDateViewState extends State<BirthDateView> {
  late final FixedExtentScrollController _dayController;
  late final FixedExtentScrollController _monthController;
  late final FixedExtentScrollController _yearController;

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;

  static const double _itemExtent = 44.0;
  static const double _pickerHeight = _itemExtent * 3;

  @override
  void initState() {
    super.initState();
    _dayController = FixedExtentScrollController();
    _monthController = FixedExtentScrollController();
    _yearController = FixedExtentScrollController();
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Widget _buildColumn({
    required FixedExtentScrollController controller,
    required List<String> items,
    required int selectedIndex,
    required ValueChanged<int> onChanged,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: _itemExtent,
        diameterRatio: 8,
        squeeze: 1,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: items.length,
          builder: (context, index) {
            final bool isSelected = index == selectedIndex;
            return Center(
              child: Text(
                items[index],
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: isSelected ? 16 : 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? AppColors.counterColor
                      : AppColors.greyColor,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const CustomAppBar(title: 'معلومات بسيطة عنك', isBack: true),

              const SizedBox(height: 24),
              Text(
                'تاريخ ميلادك',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),

              const SizedBox(height: 24),

              Container(
                height: _pickerHeight,
                decoration: BoxDecoration(
                  color: AppColors.lightGreyColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.borderColor, width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Positioned(
                        top: _itemExtent, // skip first row
                        left: 8,
                        right: 8,
                        child: Container(
                          height: _itemExtent,
                          decoration: BoxDecoration(
                            color: AppColors.thirdColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          _buildColumn(
                            controller: _dayController,
                            items: DateConstants.days,
                            selectedIndex: _selectedDay,
                            onChanged: (i) => setState(() => _selectedDay = i),
                          ),

                          _buildColumn(
                            controller: _monthController,
                            items: DateConstants.months,
                            selectedIndex: _selectedMonth,
                            onChanged: (i) =>
                                setState(() => _selectedMonth = i),
                            flex: 2,
                          ),

                          _buildColumn(
                            controller: _yearController,
                            items: DateConstants.years,
                            selectedIndex: _selectedYear,
                            onChanged: (i) => setState(() => _selectedYear = i),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: 120,
                child: AppPrimaryButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.goodStart);
                  },
                  label: 'التالي',
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
