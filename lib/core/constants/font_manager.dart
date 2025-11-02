import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:parker_touch/core/constants/app_colors.dart';

class FontManager {
  // Font Families
  static const String poppins = "Poppins";
  static const String nunito = "Nunito";

  // Font Weights

  static const FontWeight w400 = FontWeight.w400;
  static const FontWeight w500 = FontWeight.w500;
  static const FontWeight w600 = FontWeight.w600;
  static const FontWeight w700 = FontWeight.w700;

  static TextStyle titleStyle = TextStyle(
    fontFamily: poppins,
    fontSize: 24.sp,
    fontWeight: w600,
    color: AppColors.black,
  );

  static TextStyle cong = TextStyle(
    fontFamily: poppins,
    fontSize: 32.sp,
    fontWeight: w600,
    color: AppColors.green,
  );

  static TextStyle subtitle = TextStyle(
    fontFamily: nunito,
    fontSize: 16.sp,
    fontWeight: w400,
    color: AppColors.black,
  );

  static TextStyle loginStyle = TextStyle(
    fontFamily: poppins,
    fontSize: 16.sp,
    fontWeight: w400,
    color: AppColors.black,
  );

  static TextStyle contTitle = TextStyle(
    fontFamily: poppins,
    fontSize: 20.sp,
    fontWeight: w500,
    color: AppColors.black,
  );

  static TextStyle bodyText = TextStyle(
    fontFamily: nunito,
    fontSize: 14.sp,
    fontWeight: w400,
    color: AppColors.cColor2,
  );

  static TextStyle bodyText2 = TextStyle(
    fontFamily: nunito,
    fontSize: 16.sp,
    fontWeight: w600,
    color: AppColors.cColor2,
  );

  static TextStyle bodyText3 = TextStyle(
    fontFamily: poppins,
    fontSize: 14.sp,
    fontWeight: w600,
    color: AppColors.black1,
  );

  static TextStyle connect = TextStyle(
    fontFamily: poppins,
    fontSize: 20.sp,
    fontWeight: w600,
    color: AppColors.connect,
  );

  static TextStyle connectPotient = TextStyle(
    fontFamily: nunito,
    fontSize: 16.sp,
    fontWeight: w400,
    color: AppColors.connectColor,
  );

  static TextStyle contSubTitle = TextStyle(
    fontFamily: nunito,
    fontSize: 14.sp,
    fontWeight: w400,
    color: AppColors.black1,
  );

  static TextStyle bodyText4 = TextStyle(
    fontFamily: nunito,
    fontSize: 12.sp,
    fontWeight: w400,
    color: AppColors.disconnectColor,
  );

  static TextStyle bodyText5 = TextStyle(
    fontFamily: nunito,
    fontSize: 14.sp,
    fontWeight: w500,
    color: AppColors.black1,
  );

  static TextStyle bodyText6 = TextStyle(
    fontFamily: poppins,
    fontSize: 15.sp,
    fontWeight: w500,
    color: AppColors.black1,
  );
  static TextStyle bodyText7 = TextStyle(
    fontFamily: poppins,
    fontSize: 14.sp,
    fontWeight: w400,
    color: AppColors.black1,
  );

  static TextStyle bodyText8 = TextStyle(
    fontFamily: nunito,
    fontSize: 32.sp,
    fontWeight: w700,
    color: AppColors.black1,
  );

  static TextStyle bodyText9 = TextStyle(
    fontFamily: poppins,
    fontSize: 20.sp,
    fontWeight: w600,
    color: AppColors.black1,
  );
}
