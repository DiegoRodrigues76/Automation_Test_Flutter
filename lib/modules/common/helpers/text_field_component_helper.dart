import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:automation_test_flutter/modules/common/theme/sizes.dart';
import 'package:flutter/material.dart';
import '../../../presentation/components/text_field_component.dart';

class ZemaTextFieldComponentHelper {
  static TextFieldStyleHelper textFieldStyleHelper =
      const TextFieldStyleHelper();

  static TextFieldDecorationHelper textFieldDecorationHelper =
      const TextFieldDecorationHelper();
}

class TextFieldStyleHelper {
  const TextFieldStyleHelper();

  TextStyle getDarkTextStyle() {
    return const TextStyle(color: ZemaColors.white);
  }

  TextStyle getLightTextStyle() {
    return const TextStyle(color: ZemaColors.darkGrey);
  }

  TextStyle getValueTextStyle() {
    return const TextStyle(
        color: ZemaColors.blue, fontSize: 25.0, fontWeight: FontWeight.bold);
  }
}

class TextFieldDecorationHelper {
  const TextFieldDecorationHelper();

  InputDecoration getDarkDecoration(ZemaTextFieldComponent widget) {
    return InputDecoration(
      helperText: widget.helperText,
      helperStyle: const TextStyle(
        color: ZemaColors.white,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: ZemaSizes.padding.extraLarge ?? 0,
        horizontal: ZemaSizes.padding.huge ?? 0,
      ),
      filled: true,
      fillColor: ZemaColors.blue,
      enabled: widget.isReadOnly,
      errorStyle: const TextStyle(
        color: ZemaColors.darkYellow,
      ),
      floatingLabelStyle: const TextStyle(
        color: ZemaColors.white,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: ZemaColors.darkYellow,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            ZemaSizes.radius.small ?? 0,
          ),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: ZemaColors.darkYellow,
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
          color: ZemaColors.primary,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            ZemaSizes.radius.small ?? 0,
          ),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: ZemaColors.primary,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            ZemaSizes.radius.small ?? 0,
          ),
        ),
      ),
      labelStyle: const TextStyle(
        color: ZemaColors.white,
      ),
      label: widget.validationMessages != null && widget.hasAsterisk == true
          ? Text('${widget.label}*')
          : Text(widget.label),
      suffixIcon: widget.suffix,
    );
  }

  InputDecoration getLightDecoration(ZemaTextFieldComponent widget) {
    return InputDecoration(
      helperText: widget.helperText,
      helperStyle: const TextStyle(
        color: ZemaColors.darkGrey,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: ZemaSizes.padding.extraLarge ?? 0,
        horizontal: ZemaSizes.padding.huge ?? 0,
      ),
      filled: true,
      fillColor: widget.isReadOnly
          ? ZemaColors.grey.withAlpha(40)
          : ZemaColors.lightGrey,
      enabled: widget.isReadOnly,
      label: widget.validationMessages != null && widget.hasAsterisk == true
          ? Text('${widget.label}*')
          : Text(widget.label),
      suffixIcon: widget.suffix,
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: widget.isReadOnly ? Colors.transparent : ZemaColors.lightGrey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            ZemaSizes.radius.small ?? 0,
          ),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: widget.isReadOnly ? Colors.transparent : ZemaColors.white,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            ZemaSizes.radius.small ?? 0,
          ),
        ),
      ),
    );
  }

  InputDecoration getValueDecoration(ZemaTextFieldComponent widget) {
    return InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: ZemaSizes.padding.huge ?? 0,
        ),
        filled: true,
        fillColor: Colors.transparent,
        enabled: widget.isReadOnly,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              ZemaSizes.radius.small ?? 0,
            ),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(
              ZemaSizes.radius.small ?? 0,
            ),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        label: widget.validationMessages != null && widget.hasAsterisk == true
            ? Text('${widget.label}*',
                style: const TextStyle(color: ZemaColors.blue))
            : Text(widget.label,
                style: const TextStyle(color: ZemaColors.blue)),
        suffixIcon: widget.suffix);
  }
}
