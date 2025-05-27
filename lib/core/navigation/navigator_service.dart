import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class NavigatorService {
  static void navigateToForm(BuildContext context, String route, FormGroup form) {
    if (form.valid) {
      Navigator.pushNamed(context, route);
    } else {
      form.markAllAsTouched();
    }
  }
}