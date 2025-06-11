import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:automation_test_flutter/modules/common/theme/sizes.dart';
import 'package:flutter/material.dart';

const double _loadingSize = 17;
const double _defaultWidth = 200;

class ZemaButtonComponent extends StatefulWidget {
  final String label;
  final VoidCallback action;
  final bool isOutlined;
  final bool isLoading;
  final bool isDisabled;
  final bool isEnabled; // Added isEnabled
  final bool isFullWidth;
  final double width;
  final bool isCircularRadius;
  final Color backgroundColor;
  final Color labelColor;
  final Color outlinedLabelColor;
  final String buttonName;
  final Color outlinedBorderColor;
  final IconData? suffix;

  const ZemaButtonComponent({
    required this.label,
    required this.action,
    this.isLoading = false,
    this.isOutlined = false,
    this.isDisabled = false,
    this.isEnabled = true, // Default to enabled
    this.isFullWidth = true,
    this.width = _defaultWidth,
    this.isCircularRadius = true,
    this.backgroundColor = ZemaColors.primary,
    this.labelColor = ZemaColors.white,
    this.outlinedBorderColor = ZemaColors.primary,
    this.outlinedLabelColor = ZemaColors.primary,
    this.suffix,
    super.key,
    required this.buttonName,
  });

  @override
  State<ZemaButtonComponent> createState() => _ZemaButtonComponentState();
}

class _ZemaButtonComponentState extends State<ZemaButtonComponent> {
  bool get _effectiveIsDisabled => widget.isDisabled || !widget.isEnabled;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ZemaSizes.padding.tiny ?? 0,
        ),
        width: widget.isFullWidth ? double.infinity : widget.width,
        child: Semantics(
          button: true,
          label: widget.label,
          child: widget.isOutlined ? _getOutlinedButton : _getElevatedButton,
        ),
      ),
    );
  }

  Color get _getLabelColor {
    if (_effectiveIsDisabled) {
      return ZemaColors.disableGray;
    }
    return widget.isOutlined
        ? widget.outlinedLabelColor
        : (widget.backgroundColor == ZemaColors.darkYellow
            ? ZemaColors.primary
            : widget.labelColor);
  }

  Text get _getLabel {
    return Text(
      widget.label.toUpperCase(),
      style: TextStyle(
        fontSize: ZemaSizes.font.medium,
        fontWeight: FontWeight.w700,
        color: _getLabelColor,
      ),
    );
  }

  Row get _getLabelWithSuffix {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: _getLabel),
        Icon(
          widget.suffix!,
          size: ZemaSizes.icons.small,
          color: _getLabelColor,
        ),
      ],
    );
  }

  SizedBox get _getLoading {
    return SizedBox(
      height: _loadingSize,
      width: _loadingSize,
      child: CircularProgressIndicator(
        color: _getLabelColor,
        strokeWidth: 2,
      ),
    );
  }

  EdgeInsets get _getPadding {
    return EdgeInsets.all(ZemaSizes.padding.large ?? 0);
  }

  RoundedRectangleBorder get _getButtonShape {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(_getCircularRadius),
    );
  }

  double get _getCircularRadius {
    return widget.isCircularRadius
        ? ZemaSizes.radius.extraLarge!
        : ZemaSizes.radius.tiny!;
  }

  Widget get _getButtonContent {
    return widget.isLoading
        ? _getLoading
        : widget.suffix != null
            ? _getLabelWithSuffix
            : _getLabel;
  }

  ElevatedButton get _getElevatedButton {
    return ElevatedButton(
      key: Key(widget.buttonName),
      onPressed: (_effectiveIsDisabled || widget.isLoading)
          ? null
          : widget.action,
      style: ElevatedButton.styleFrom(
        padding: _getPadding,
        shape: _getButtonShape,
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor:
            _effectiveIsDisabled ? ZemaColors.lightGrey : widget.backgroundColor,
      ),
      child: _getButtonContent,
    );
  }

  OutlinedButton get _getOutlinedButton {
    return OutlinedButton(
      key: Key(widget.buttonName),
      onPressed: (_effectiveIsDisabled || widget.isLoading)
          ? null
          : widget.action,
      style: OutlinedButton.styleFrom(
        backgroundColor:
            _effectiveIsDisabled ? ZemaColors.lightGrey : widget.backgroundColor,
        foregroundColor: widget.outlinedBorderColor.withAlpha(252),
        padding: _getPadding,
        side: BorderSide(
          color: _effectiveIsDisabled
              ? ZemaColors.accentGray
              : widget.outlinedBorderColor,
        ),
        shape: _getButtonShape,
      ),
      child: _getButtonContent,
    );
  }
}