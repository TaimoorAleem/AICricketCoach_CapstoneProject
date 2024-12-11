import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {

  static final appTheme = ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      brightness: Brightness.dark,
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.background,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.background ,
          hintStyle: const TextStyle(
            color: Colors.white38,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color:  Colors.white,
              width: 0.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color:  Colors.white,
              width: 0.5, // Extremely thin border
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: Colors.white,
              width: 0.5, // Consistent thin border on focus
            ),
          ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 0,
              textStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)
              )
          )
      )
  );
}