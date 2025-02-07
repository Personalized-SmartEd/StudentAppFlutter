import 'package:google_fonts/google_fonts.dart';

import 'package:flutter/material.dart';
import 'package:smarted/shared/constants/color.constants.dart';
import 'package:smarted/shared/constants/textstyle.constant.dart';
import 'package:smarted/shared/text_styles/text_styles.dart';

class ZTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.dmSansTextTheme(),
    colorScheme: ColorScheme.fromSeed(
      primary: ColorConstants.primary,
      seedColor: ColorConstants.primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: ColorConstants.scaffoldBackground,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorConstants.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: ColorConstants.primary.withOpacity(0.5),
        disabledForegroundColor: Colors.white,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: ColorConstants.primary),
        foregroundColor: ColorConstants.primary,
        disabledForegroundColor: Colors.grey,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: ColorConstants.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: ColorConstants.error),
      ),
    ),
  );

  static Color get foregroundColor => const Color(0xFF171717);
  static Color get backgroundColor => Colors.white;

  // custom text styles:

  static ZTextStyles fs28 = ZTextStyles(
    bold: TextStyleConstants.fs28Bold,
    semibold: TextStyleConstants.fs28SemiBold,
    medium: TextStyleConstants.fs28Medium,
    regular: TextStyleConstants.fs28Regular,
  );

  static ZTextStyles fs24 = ZTextStyles(
    bold: TextStyleConstants.fs24Bold,
    semibold: TextStyleConstants.fs24SemiBold,
    medium: TextStyleConstants.fs24Medium,
    regular: TextStyleConstants.fs24Regular,
  );

  static ZTextStyles fs22 = ZTextStyles(
    bold: TextStyleConstants.fs22Bold,
    semibold: TextStyleConstants.fs22SemiBold,
    medium: TextStyleConstants.fs22Medium,
    regular: TextStyleConstants.fs22Regular,
  );

  static ZTextStyles fs20 = ZTextStyles(
    bold: TextStyleConstants.fs20Bold,
    semibold: TextStyleConstants.fs20SemiBold,
    medium: TextStyleConstants.fs20Medium,
    regular: TextStyleConstants.fs20Regular,
  );

  static ZTextStyles fs18 = ZTextStyles(
    bold: TextStyleConstants.fs18Bold,
    semibold: TextStyleConstants.fs18SemiBold,
    medium: TextStyleConstants.fs18Medium,
    regular: TextStyleConstants.fs18Regular,
  );

  static ZTextStyles fs16 = ZTextStyles(
    bold: TextStyleConstants.fs16Bold,
    semibold: TextStyleConstants.fs16SemiBold,
    medium: TextStyleConstants.fs16Medium,
    regular: TextStyleConstants.fs16Regular,
  );

  static ZTextStyles fs14 = ZTextStyles(
    bold: TextStyleConstants.fs14Bold,
    semibold: TextStyleConstants.fs14SemiBold,
    medium: TextStyleConstants.fs14Medium,
    regular: TextStyleConstants.fs14Regular,
  );

  static ZTextStyles fs12 = ZTextStyles(
    bold: TextStyleConstants.fs12Bold,
    semibold: TextStyleConstants.fs12SemiBold,
    medium: TextStyleConstants.fs12Medium,
    regular: TextStyleConstants.fs12Regular,
  );

  static ZTextStyles fs11 = ZTextStyles(
    bold: TextStyleConstants.fs11Bold,
    semibold: TextStyleConstants.fs11SemiBold,
    medium: TextStyleConstants.fs11Medium,
    regular: TextStyleConstants.fs11Regular,
  );

  static ZTextStyles fs10 = ZTextStyles(
    bold: TextStyleConstants.fs10Bold,
    semibold: TextStyleConstants.fs10SemiBold,
    medium: TextStyleConstants.fs10Medium,
    regular: TextStyleConstants.fs10Regular,
  );

  static ZTextStyles fs32 = ZTextStyles(
    bold: TextStyleConstants.fs32Bold,
    semibold: TextStyleConstants.fs32SemiBold,
    medium: TextStyleConstants.fs32Medium,
    regular: TextStyleConstants.fs32Regular,
  );

  static ZTextStyles fs36 = ZTextStyles(
    bold: TextStyleConstants.fs36Bold,
    semibold: TextStyleConstants.fs36SemiBold,
    medium: TextStyleConstants.fs36Medium,
    regular: TextStyleConstants.fs36Regular,
  );

  static ZTextStyles fs42 = ZTextStyles(
    bold: TextStyleConstants.fs42Bold,
    semibold: TextStyleConstants.fs42SemiBold,
    medium: TextStyleConstants.fs42Medium,
    regular: TextStyleConstants.fs42Regular,
  );

  static TextStyle heading1 = TextStyleConstants.fs24SemiBold;

  static TextStyle heading2 = TextStyleConstants.fs18Bold;

  static TextStyle heading3 = TextStyleConstants.fs16SemiBold;

  static TextStyle heading4 = TextStyleConstants.fs14SemiBold;
}
