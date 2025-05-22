import 'package:automation_test_flutter/presentation/components/button_component.dart';
import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:automation_test_flutter/modules/common/theme/sizes.dart';
import 'package:flutter/material.dart';

enum ModalType {
  primary,
  success,
  error,
}

class ZemaModalComponent extends StatelessWidget {
  final ModalType type;
  final IconData icon;
  final String title;
  final String description;
  final String confirmLabel;
  final VoidCallback confirmAction;
  final String? cancelLabel;
  final VoidCallback? cancelAction;

  const ZemaModalComponent({
    this.type = ModalType.primary,
    required this.title,
    required this.icon,
    required this.description,
    required this.confirmLabel,
    required this.confirmAction,
    this.cancelLabel,
    this.cancelAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(ZemaSizes.radius.large ?? 0),
          topRight: Radius.circular(ZemaSizes.radius.large ?? 0),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ZemaSizes.padding.large ?? 0,
        vertical: ZemaSizes.padding.extraLarge ?? 0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _getTitle,
          _getDescription,
          _getConfirmButton,
          cancelLabel != null ? _getCancelButton : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Row get _getTitle {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            right: ZemaSizes.padding.extraSmall ?? 0,
          ),
          child: Icon(
            icon,
            color: ZemaColors.coolGray,
            size: ZemaSizes.icons.medium,
          ),
        ),
        Flexible(
          child: Text(
            title,
            style: TextStyle(
              color: ZemaColors.coolGray,
              fontWeight: FontWeight.bold,
              fontSize: ZemaSizes.font.extraLarge ?? 0,
            ),
          ),
        ),
      ],
    );
  }

  Padding get _getDescription {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ZemaSizes.padding.large ?? 0,
      ),
      child: Text(
        description,
        style: TextStyle(
          color: ZemaColors.coolGray,
          fontSize: ZemaSizes.font.large ?? 0,
        ),
      ),
    );
  }

  Padding get _getConfirmButton {
    return Padding(
      padding: EdgeInsets.only(
        bottom: cancelLabel != null ? 0 : ZemaSizes.padding.medium,
      ),
      child: ZemaButtonComponent(
        isOutlined: true,
        backgroundColor:
            type == ModalType.error ? ZemaColors.white : ZemaColors.primary,
        outlinedBorderColor: ZemaColors.white,
        outlinedLabelColor:
            type == ModalType.error ? ZemaColors.primary : ZemaColors.white,
        label: confirmLabel,
        action: () {
          confirmAction.call();
        }, buttonName: '',
      ),
    );
  }

  Padding get _getCancelButton {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ZemaSizes.padding.medium,
      ),
      child: ZemaButtonComponent(
        buttonName: '',
        isOutlined: true,
        backgroundColor: _getColor,
        outlinedBorderColor: ZemaColors.white,
        outlinedLabelColor: ZemaColors.white,
        label: cancelLabel ?? '',
        action: () {
          cancelAction?.call();
        },
      ),
    );
  }

  Color get _getColor {
    return switch (type) {
      ModalType.success => ZemaColors.primary,
      ModalType.error => ZemaColors.error,
      ModalType.primary => ZemaColors.primary,
    };
  }
}
