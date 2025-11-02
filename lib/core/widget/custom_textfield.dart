import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/font_manager.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield({
    super.key,
    required this.text,
    required this.hintText,
    this.icon,
    this.controller,
    this.obscureText = false,
    this.bgColor,
    this.borderColor,
    this.enabled = true,
    this.isSelected = true,
    this.onToggleObscureText,
  });

  final String text;
  final String hintText;
  final IconData? icon;
  final TextEditingController? controller;
  final Color? bgColor;
  final Color? borderColor;
  final bool isSelected;
  final bool enabled;
  final bool obscureText;
  final VoidCallback? onToggleObscureText;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
      if (widget.onToggleObscureText != null) {
        widget.onToggleObscureText!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: widget.isSelected
              ? FontManager.loginStyle.copyWith(
                  fontSize: 14.sp,
                  color: Colors.black,
                )
              : FontManager.subtitle.copyWith(color: Colors.black),
        ),
        Container(
          margin: const EdgeInsets.only(top: 6, bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.bgColor ?? AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: widget.borderColor ?? Color(0xffd6d9dd)),
          ),
          child: TextField(
            controller: widget.controller,
            scrollPadding: EdgeInsets.all(8),
            enabled: widget.enabled,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.hintText,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
              hintStyle: FontManager.loginStyle.copyWith(
                color: AppColors.grey,
                fontSize: 14.sp,
              ),
              suffixIcon: widget.icon != null
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.grey,
                      ),
                      onPressed: widget.obscureText ? _toggleObscureText : null,
                    )
                  : null,
            ),
            obscureText: _obscureText,
          ),
        ),
      ],
    );
  }
}
