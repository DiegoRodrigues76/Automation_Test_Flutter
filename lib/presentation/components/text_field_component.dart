import 'package:automation_test_flutter/modules/common/enums/text_field_component_enum.dart';
import 'package:automation_test_flutter/modules/common/helpers/text_field_component_helper.dart';
import 'package:automation_test_flutter/modules/common/theme/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ZemaTextFieldComponent extends StatefulWidget {
  final String label;
  final String formControlName;
  final TextInputType keyboardType;
  final Map<String, String Function(Object)>? validationMessages;
  final bool isReadOnly;
  final bool isObscure;
  final bool enableSuggestions;
  final List<TextInputFormatter>? masks;
  final Widget? suffix;
  final bool isDark;
  final bool isTextArea;
  final bool hasAsterisk;
  final String? helperText;
  final ZemaTextFieldComponentEnum? textFieldEnum;
  final int? maxLines;
  final void Function(FormControl<dynamic>)? onChanged;

  const ZemaTextFieldComponent({
    required this.label,
    required this.formControlName,
    this.keyboardType = TextInputType.text,
    this.isReadOnly = false,
    this.isObscure = false,
    this.enableSuggestions = false,
    this.validationMessages,
    this.masks,
    this.suffix,
    this.isDark = false,
    this.isTextArea = false,
    this.hasAsterisk = true,
    this.maxLines,
    this.onChanged,
    this.helperText,
    this.textFieldEnum,
    super.key,
  });

  @override
  State<ZemaTextFieldComponent> createState() => _ZemaTextFieldComponentState();
}

class _ZemaTextFieldComponentState extends State<ZemaTextFieldComponent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ZemaSizes.padding.medium,
      ),
      child: ReactiveTextField(
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        maxLines: widget.isTextArea ? (widget.maxLines ?? 5) : 1,
        style: _getTextStyle(_getTextFieldEnum()),
        inputFormatters: widget.masks,
        formControlName: widget.formControlName,
        obscureText: widget.isObscure,
        readOnly: widget.isReadOnly,
        enableSuggestions: widget.enableSuggestions,
        autocorrect: false,
        validationMessages: widget.validationMessages,
        decoration: _getDecoration(_getTextFieldEnum()),
      ),
    );
  }

  ZemaTextFieldComponentEnum _getTextFieldEnum() {
    return widget.textFieldEnum ??
        (widget.isDark
            ? ZemaTextFieldComponentEnum.isDark
            : ZemaTextFieldComponentEnum.isLight);
  }

  TextStyle _getTextStyle(ZemaTextFieldComponentEnum textStyleEnum) {
    switch (textStyleEnum) {
      case ZemaTextFieldComponentEnum.isDark:
        return ZemaTextFieldComponentHelper.textFieldStyleHelper
            .getDarkTextStyle();
      case ZemaTextFieldComponentEnum.isLight:
        return ZemaTextFieldComponentHelper.textFieldStyleHelper
            .getLightTextStyle();
      case ZemaTextFieldComponentEnum.isValue:
        return ZemaTextFieldComponentHelper.textFieldStyleHelper
            .getValueTextStyle();
      default:
        return ZemaTextFieldComponentHelper.textFieldStyleHelper
            .getLightTextStyle();
    }
  }

  InputDecoration _getDecoration(ZemaTextFieldComponentEnum decorationEnum) {
    switch (decorationEnum) {
      case ZemaTextFieldComponentEnum.isDark:
        return ZemaTextFieldComponentHelper.textFieldDecorationHelper
            .getDarkDecoration(widget);
      case ZemaTextFieldComponentEnum.isLight:
        return ZemaTextFieldComponentHelper.textFieldDecorationHelper
            .getLightDecoration(widget);
      case ZemaTextFieldComponentEnum.isValue:
        return ZemaTextFieldComponentHelper.textFieldDecorationHelper
            .getValueDecoration(widget);
      default:
        return ZemaTextFieldComponentHelper.textFieldDecorationHelper
            .getLightDecoration(widget);
    }
  }
}
