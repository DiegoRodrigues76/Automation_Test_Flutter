import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomReactiveTextField extends StatelessWidget {
  final String label;
  final String formControlName;
  final TextInputType keyboardType;
  final bool readOnly;
  final bool obscureText;
  final Map<String, String Function(dynamic)>? validationMessages;
  final void Function(String)? onChanged;

  const CustomReactiveTextField({
    super.key,
    required this.label,
    required this.formControlName,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.obscureText = false,
    this.validationMessages,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: formControlName,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
      readOnly: readOnly,
      obscureText: obscureText,
      validationMessages: validationMessages,
      onChanged: onChanged != null
      ? (control) => onChanged! (control.value ?? '')
      : null,
    );
  }
}