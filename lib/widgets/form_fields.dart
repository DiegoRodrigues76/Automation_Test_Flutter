import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomReactiveTextField extends StatelessWidget {
  final String formControlName;
  final String label;
  final bool readOnly;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Map<String, String Function(Object)>? validationMessages;
  final void Function(String)? onChanged;
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;

  const CustomReactiveTextField({
    super.key,
    required this.formControlName,
    required this.label,
    this.readOnly = false,
    this.keyboardType,
    this.obscureText = false,
    this.validationMessages,
    this.onChanged,
    this.decoration,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: formControlName,
      validationMessages: validationMessages,
      onChanged: onChanged != null
          ? (control) {
              final value = control.value;
              if (value != null) {
                onChanged!(value);
              }
            }
          : null,
      readOnly: readOnly,
      keyboardType: keyboardType,
      obscureText: obscureText,
      inputFormatters: inputFormatters,
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
    );
  }
}