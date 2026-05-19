import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:islamic_app/core/services/extensions/theme_extension.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/features/azkar/presentation/bloc/azkar_cubit.dart';

class AzkarDetailScreen extends StatefulWidget {
  final String title;
  final int categoryId;
  const AzkarDetailScreen({
    super.key,
    required this.title,
    required this.categoryId,
  });

  @override
  State<AzkarDetailScreen> createState() => _AzkarDetailScreenState();
}

class _AzkarDetailScreenState extends State<AzkarDetailScreen> {
  // Map to store the remaining count for each zikr item by its index
  final Map<int, int> _remainingCounts = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AzkarCubit>().loadZikrDetails(widget.categoryId);
    });
  }

  void _decrementCounter(int index, int initialRepeat) {
    setState(() {
      if (!_remainingCounts.containsKey(index)) {
        _remainingCounts[index] = initialRepeat;
      }
      if (_remainingCounts[index]! > 0) {
        _remainingCounts[index] = _remainingCounts[index]! - 1;
      }
    });
  }

  void _resetCounters(int listLength, List<dynamic> zikrList) {
    setState(() {
      _remainingCounts.clear();
      for (int i = 0; i < listLength; i++) {
        _remainingCounts[i] = zikrList[i].repeat;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_sharp,
              color: context.primaryColor,
              size: 20,
            ),
          ),
          title: Text(
            widget.title,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          actions: [
            BlocBuilder<AzkarCubit, AzkarState>(
              builder: (context, state) {
                if (state is AzkarDetailsLoaded) {
                  return IconButton(
                    icon: Icon(Icons.refresh, color: context.primaryColor),
                    tooltip: 'إعادة ضبط العدادات',
                    onPressed: () =>
                        _resetCounters(state.zikrList.length, state.zikrList),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<AzkarCubit, AzkarState>(
          builder: (context, state) {
            if (state is AzkarLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AzkarError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'خطأ: ${state.message}',
                    style: const TextStyle(fontFamily: 'Tajawal', fontSize: 16),
                  ),
                ),
              );
            }
            if (state is AzkarDetailsLoaded) {
              if (state.zikrList.isEmpty) {
                return const Center(
                  child: Text(
                    "لا توجد أذكار في هذا القسم",
                    style: TextStyle(fontFamily: 'Tajawal', fontSize: 16),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.zikrList.length,
                itemBuilder: (context, index) {
                  final item = state.zikrList[index];
                  final initialRepeat = item.repeat;

                  // Initialize the remaining count if it hasn't been set yet
                  if (!_remainingCounts.containsKey(index)) {
                    _remainingCounts[index] = initialRepeat;
                  }

                  final currentCount = _remainingCounts[index]!;
                  final isCompleted = currentCount == 0;

                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isCompleted ? 0.6 : 1.0,
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: isCompleted ? 0.5 : 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: isCompleted
                              ? Colors.green.withOpacity(0.2)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      color: isCompleted
                          ? Colors.green[50]?.withOpacity(0.5)
                          : Colors.white,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => _decrementCounter(index, initialRepeat),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // The Zikr Arabic Text
                              Text(
                                item.arabicText,
                                textAlign: TextAlign.justify,
                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                  height: 1.6,
                                ),
                              ),

                              if (item.translatedText.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Text(
                                  item.translatedText,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    height: 1.4,
                                  ),
                                ),
                              ],

                              const SizedBox(height: 16),

                              // Counter Button & Progress Indicator
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Progress indicator text (e.g. 1 / 3)
                                  Text(
                                    isCompleted
                                        ? "تم بحمد الله"
                                        : "المتبقي: $currentCount من $initialRepeat",
                                    style: TextStyle(
                                      fontFamily: 'Tajawal',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isCompleted
                                          ? Colors.green[700]
                                          : Colors.grey[700],
                                    ),
                                  ),

                                  // Interactive tap circle
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isCompleted
                                          ? Colors.green[600]
                                          : AppColors.thirdColor.withOpacity(
                                              0.15,
                                            ),
                                      border: Border.all(
                                        color: isCompleted
                                            ? Colors.green[600]!
                                            : AppColors.thirdColor,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: isCompleted
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 24,
                                            )
                                          : Text(
                                              "$currentCount",
                                              style: TextStyle(
                                                fontFamily: 'Tajawal',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.thirdColor,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
