// lib/widgets/form_fields.dart

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class CustomReactiveTextField extends StatelessWidget {
  final String label;
  final String formControlName;
  final TextInputType keyboardType;

  const CustomReactiveTextField({super.key,
    required this.label,
    required this.formControlName,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveTextField<String>(
      formControlName: formControlName,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
    );
  }
}
