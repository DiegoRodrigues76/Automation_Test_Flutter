import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:automation_test_flutter/modules/common/theme/sizes.dart';
import 'package:flutter/material.dart';

class ZemaTheme {
  static ThemeData getLightTheme() => ThemeData.light().copyWith(
        colorScheme: const ColorScheme(
          background: ZemaColors.darkBlue,
          brightness: Brightness.light,
          primary: ZemaColors.primary,
          onPrimary: ZemaColors.primary,
          secondary: ZemaColors.darkYellow,
          onSecondary: ZemaColors.darkYellow,
          error: ZemaColors.error,
          onError: ZemaColors.error,
          surface: ZemaColors.white,
          onSurface: ZemaColors.darkBlue,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          dragHandleColor: ZemaColors.grey,
          surfaceTintColor: ZemaColors.lightGrey,
          backgroundColor: ZemaColors.white,
        ),
        primaryColor: ZemaColors.primary,
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: ZemaColors.grey,
          selectionColor: ZemaColors.grey.withOpacity(0.1),
          selectionHandleColor: ZemaColors.lightBlue,
        ),
        scaffoldBackgroundColor: ZemaColors.white,
        cardColor: ZemaColors.white,
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 1,
          backgroundColor: ZemaColors.primary,
          titleTextStyle: TextStyle(
            color: ZemaColors.white,
            fontSize: ZemaSizes.font.giantic!,
          ),
          iconTheme: const IconThemeData(
            color: ZemaColors.white,
          ),
          actionsIconTheme: const IconThemeData(
            color: ZemaColors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(
            color: ZemaColors.darkGrey,
          ),
          floatingLabelStyle: const TextStyle(
            color: ZemaColors.primary,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ZemaColors.error,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                ZemaSizes.radius.small ?? 0,
              ),
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ZemaColors.error,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                ZemaSizes.radius.small ?? 0,
              ),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ZemaColors.primary,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                ZemaSizes.radius.small ?? 0,
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ZemaColors.darkGrey,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                ZemaSizes.radius.small ?? 0,
              ),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: ZemaColors.white,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(
                ZemaSizes.radius.small ?? 0,
              ),
            ),
          ),
        ),
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        datePickerTheme: DatePickerThemeData(
          surfaceTintColor: ZemaColors.white,
          todayBorder: const BorderSide(
            color: ZemaColors.white,
          ),
          backgroundColor: ZemaColors.white,
          headerBackgroundColor: ZemaColors.primary,
          inputDecorationTheme: InputDecorationTheme(
            fillColor: ZemaColors.white,
            floatingLabelStyle: const TextStyle(
              color: ZemaColors.primary,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: ZemaColors.error,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  ZemaSizes.radius.small ?? 0,
                ),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: ZemaColors.error,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  ZemaSizes.radius.small ?? 0,
                ),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: ZemaColors.primary,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  ZemaSizes.radius.small ?? 0,
                ),
              ),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(
                color: ZemaColors.darkGrey,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  ZemaSizes.radius.small ?? 0,
                ),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: ZemaColors.white,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(
                  ZemaSizes.radius.small ?? 0,
                ),
              ),
            ),
          ),
        ),
      );
}