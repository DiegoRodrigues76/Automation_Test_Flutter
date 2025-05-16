import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:automation_test_flutter/modules/common/theme/sizes.dart';
import 'package:flutter/material.dart';

class ZemaHorizontalButtonComponent extends StatelessWidget {
  final String route;
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? iconSize;
  final VoidCallback? action;
  final BoxBorder? border;

  const ZemaHorizontalButtonComponent({
    required this.route,
    required this.label,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.backgroundColor,
    this.action,
    super.key,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (action != null && route == '') {
          action?.call();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: ZemaSizes.padding.extraLarge ?? 0,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ZemaSizes.padding.large ?? 0,
            vertical: ZemaSizes.padding.giantic ?? 0,
          ),
          width: double.maxFinite,
          decoration: BoxDecoration(
            border: border,
            color: backgroundColor ?? ZemaColors.lightGrey,
            borderRadius: BorderRadius.circular(
              ZemaSizes.radius.small ?? 0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  icon != null
                      ? Padding(
                          padding: EdgeInsets.only(
                            right: ZemaSizes.padding.tiny ?? 0,
                          ),
                          child: Icon(
                            icon,
                            size: iconSize ?? ZemaSizes.icons.large,
                            color: iconColor ?? ZemaColors.darkYellow,
                          ),
                        )
                      : const SizedBox.shrink(),
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.chevron_right_outlined,
                size: ZemaSizes.icons.medium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
