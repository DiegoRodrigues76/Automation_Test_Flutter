import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:automation_test_flutter/constants/constants.dart';
import 'package:automation_test_flutter/widgets/form_fields.dart';

class FormScreen1 extends StatelessWidget {
  final form = FormGroup({
    'name': FormControl<String>(validators: [Validators.required], asyncValidatorsDebounceTime: 500),
    'email': FormControl<String>(validators: [Validators.required, Validators.email], asyncValidatorsDebounceTime: 500),
    'phone': FormControl<String>(validators: [Validators.required], asyncValidatorsDebounceTime: 500),
  });

  FormScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 1')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              CustomReactiveTextField(
                formControlName: 'name',
                label: 'Nome',
                validationMessages: {
                  ValidationMessage.required: (_) => requiredField,
                },
              ),
              CustomReactiveTextField(
                formControlName: 'email',
                label: 'E-mail',
                keyboardType: TextInputType.emailAddress,
                validationMessages: {
                  ValidationMessage.required: (_) => requiredField,
                  ValidationMessage.email: (_) => invalidEmail,
                },
              ),
              CustomReactiveTextField(
                formControlName: 'phone',
                label: 'Telefone',
                keyboardType: TextInputType.phone,
                validationMessages: {
                  ValidationMessage.required: (_) => requiredField,
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (form.valid) {
                    Navigator.pushNamed(context, '/form2');
                  } else {
                    form.markAllAsTouched();
                  }
                },
                child: const Text('Próximo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}