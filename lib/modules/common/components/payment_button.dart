
import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:automation_test_flutter/modules/common/theme/sizes.dart';
import 'package:flutter/material.dart';

const double _buttonHeight = 135.0;
const double _smallButtonWidth = 135.0;
const double _largeButtonWidht = 170.0;

class ZemaPaymentButton extends StatefulWidget {
  final bool isLarge;
  final String title;
  final IconData icon;
  final double? iconSize;
  final Color? backgroundIconColor;
  final Color backgroundColor;
  final VoidCallback action;

  const ZemaPaymentButton({
    required this.icon,
    required this.title,
    required this.action,
    this.isLarge = false,
    this.backgroundIconColor,
    this.backgroundColor = ZemaColors.lightGrey,
    this.iconSize,
    super.key,
  });

  @override
  State<ZemaPaymentButton> createState() => _ZemaPaymentButtonState();
}

class _ZemaPaymentButtonState extends State<ZemaPaymentButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.action,
      child: Container(
        height: _buttonHeight,
        width: _width,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(ZemaSizes.radius.small ?? 0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: widget.backgroundColor,
              child: Icon(
                widget.icon,
                size: widget.iconSize ?? ZemaSizes.icons.large,
                color: widget.backgroundIconColor ?? _backgroundIconColor,
              ),
            ),
            SizedBox(
              height: ZemaSizes.sizeComponents.extraLarge,
            ),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: ZemaSizes.font.large,
                fontWeight: _fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  FontWeight get _fontWeight {
    return widget.isLarge ? FontWeight.bold : FontWeight.normal;
  }

  Color get _backgroundIconColor {
    return ZemaColors.primary;
  }

  double get _width {
    return widget.isLarge ? _largeButtonWidht : _smallButtonWidth;
  }
}
