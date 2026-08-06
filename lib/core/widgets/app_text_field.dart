import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:islamic_app/core/static_files/app_colors.dart';
import 'package:islamic_app/core/static_files/app_text_styles.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.onChanged,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();

    _isObscured = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: TextFormField(
        controller: widget.controller,
        obscureText: _isObscured,
        keyboardType: widget.keyboardType,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.textTheme.labelSmall!.copyWith(
            color: AppColors.hintTextColor,
            fontSize: 12,
          ),
          filled: true,
          fillColor: AppColors.creamOverlay, // 60% Cream #F7F3EE99
          // Prefix Icon (Right side in RTL)
          prefixIcon: Padding(
            padding: const EdgeInsets.all(
              9,
            ), // Adjust padding to center the icon
            // padding: const EdgeInsetsDirectional.only(start: 8, top: 10, bottom: 10), // Adjust padding to center the icon
            child: SvgPicture.asset(
              'assets/icons/${widget.prefixIcon}',
              width: 18,
              height: 18,
              // fit: BoxFit.contain, // Ensures the SVG stays within the 18x18 box
            ),
          ),
          // prefixIcon: Icon(widget.prefixIcon, color: const Color(0xFF8B6B4F), size: 20),

          // Conditional Suffix Icon: Only shows for Password fields
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    _isObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.secondaryGreyColor,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _isObscured = !_isObscured),
                )
              : null,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEFE6DA)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.greyColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF8B6B4F), width: 1.2),
          ),
        ),
        onChanged: widget.onChanged
      ),
    );
  }
}
