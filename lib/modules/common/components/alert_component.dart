import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:automation_test_flutter/modules/common/theme/sizes.dart';
import 'package:flutter/material.dart';

enum AlertType {
  info,
  success,
  warning,
  error,
}

const int _timerSeconds = 5;

class ZemaAlertComponent {
  static void show({
    required BuildContext context,
    required String message,
    required AlertType type,
    int? timer,
    String? confirmLabel,
    VoidCallback? confirmAction,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            fontSize: ZemaSizes.font.giantic,
            fontWeight: FontWeight.normal,
            color: ZemaColors.white,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: timer ?? _timerSeconds),
        backgroundColor: switch (type) {
          AlertType.success => ZemaColors.success,
          AlertType.error => ZemaColors.error,
          AlertType.info => ZemaColors.primary,
          AlertType.warning => ZemaColors.darkGrey,
        },
        action: SnackBarAction(
          label: confirmLabel ?? '',
          textColor: ZemaColors.white,
          onPressed: confirmAction ?? () {},
        ),
      ),
    );
  }
}
