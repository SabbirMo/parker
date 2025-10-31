import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';
import 'package:parker_touch/core/constants/font_manager.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.text,
    required this.hintText,
    required this.items,
    this.onChanged,
    this.value,
    this.bgColor,
    this.borderColor,
  });

  final String text;
  final String hintText;
  final List<String> items;
  final Function(String?)? onChanged;
  final String? value;
  final Color? bgColor;
  final Color? borderColor;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          style: FontManager.loginStyle.copyWith(
            fontSize: 14.sp,
            color: Colors.black,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 6, bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.bgColor ?? AppColors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: widget.borderColor ?? Color(0xffd6d9dd)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedValue,
              hint: Text(
                widget.hintText,
                style: FontManager.loginStyle.copyWith(
                  color: AppColors.grey,
                  fontSize: 14.sp,
                ),
              ),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: AppColors.grey),
              elevation: 16,
              style: FontManager.loginStyle.copyWith(
                color: Colors.black,
                fontSize: 14.sp,
              ),
              underline: Container(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedValue = newValue;
                  if (widget.onChanged != null) {
                    widget.onChanged!(newValue);
                  }
                });
              },
              items: widget.items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
