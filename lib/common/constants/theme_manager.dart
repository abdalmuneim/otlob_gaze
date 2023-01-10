import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otlob_gas/common/constants/app_colors.dart';

import 'font_manager.dart';

ThemeData get applicationTheme => ThemeData(
      scaffoldBackgroundColor: AppColors.scaffoldColor,

      /// Main Color

      primaryColor: AppColors.mainApp,
      primaryColorLight: AppColors.lightBlue,
      primaryColorDark: Colors.black,
      disabledColor: Colors.grey,

      /// CardViewTheme

      cardTheme: const CardTheme(),

      /// AppBar Theme

      appBarTheme: const AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarColor: AppColors.mainApp,
        ),
        backgroundColor: AppColors.mainApp,
        titleTextStyle: TextStyle(
            fontSize: 19,
            fontWeight: FontWeightManger.bold,
            color: Colors.white),
        centerTitle: true,
      ),

      /// Button Theme

      buttonTheme: const ButtonThemeData(),

      /// Elevated Button Theme

      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textStyle: const TextStyle(
                fontFamily: FontConstants.fontFamily,
                fontSize: 16,
                fontWeight: FontWeightManger.regular,
                color: Colors.white,
              ),
              backgroundColor: AppColors.mainApp)),

      /// Text Theme

      textTheme: const TextTheme(
        //
        headlineLarge: TextStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: 36,
          fontWeight: FontWeightManger.bold,
          color: Colors.white,
        ),

        headlineMedium: TextStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: 20,
          fontWeight: FontWeightManger.medium,
          color: Colors.black,
        ),
        headlineSmall: TextStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: 20,
          fontWeight: FontWeightManger.regular,
          color: Colors.grey,
        ),
        labelMedium: TextStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: 20,
          fontWeight: FontWeightManger.regular,
          color: Colors.red,
        ),
        bodySmall: TextStyle(
          fontFamily: FontConstants.fontFamily,
          fontSize: 20,
          fontWeight: FontWeightManger.regular,
          color: Colors.black,
        ),
      ),

      /// Input Decoration Theme (text form filed)
    );
