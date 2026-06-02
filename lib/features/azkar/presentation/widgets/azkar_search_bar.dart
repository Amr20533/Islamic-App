import 'package:flutter/material.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';

class AzkarSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const AzkarSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = "ابحث عن الذكر...",
  });

  @override
  State<AzkarSearchBar> createState() => _AzkarSearchBarState();
}

class _AzkarSearchBarState extends State<AzkarSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: const TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 15,
          color: AppColors.primaryTextColor,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 14,
            color: AppColors.hintTextColor.withOpacity(0.6),
          ),
          prefixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: AppColors.greyColor,
                    size: 18,
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                    setState(() {});
                  },
                )
              : null,
          suffixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              'assets/icons/iconoir_search.png',
              width: 18,
              height: 18,
              color: AppColors.primaryColor,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.search,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
        ),
        onTap: () {
          setState(() {});
        },
      ),
    );
  }
}
