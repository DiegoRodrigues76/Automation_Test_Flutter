import 'package:automation_test_flutter/presentation/components/button_component.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:automation_test_flutter/constants/constants.dart';
import 'package:automation_test_flutter/widgets/form_fields.dart';

class FormScreen1 extends StatefulWidget {
  const FormScreen1({super.key});

  @override
  State<FormScreen1> createState() => _FormScreen1State();
}

class _FormScreen1State extends State<FormScreen1> {
  final form = FormGroup({
    'name': FormControl<String>(
      validators: [Validators.required],
      asyncValidatorsDebounceTime: 500,
    ),
    'email': FormControl<String>(
      validators: [Validators.required, Validators.email],
      asyncValidatorsDebounceTime: 500,
    ),
    'phone': FormControl<String>(
      validators: [Validators.required],
      asyncValidatorsDebounceTime: 500,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 1')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPersonalInfoTitle(),
              const SizedBox(height: 16),
              _buildNameField(),
              const SizedBox(height: 16),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPhoneField(),
              const SizedBox(height: 32),
              _buildNextButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoTitle() {
    return const Text(
      'Informações Pessoais',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildNameField() {
    return CustomReactiveTextField(
      formControlName: 'name',
      label: 'Nome',
      validationMessages: {
        ValidationMessage.required: (_) => requiredField,
      },
    );
  }

  Widget _buildEmailField() {
    return CustomReactiveTextField(
      formControlName: 'email',
      label: 'E-mail',
      keyboardType: TextInputType.emailAddress,
      validationMessages: {
        ValidationMessage.required: (_) => requiredField,
        ValidationMessage.email: (_) => invalidEmail,
      },
    );
  }

  Widget _buildPhoneField() {
    return CustomReactiveTextField(
      formControlName: 'phone',
      label: 'Telefone',
      keyboardType: TextInputType.phone,
      validationMessages: {
        ValidationMessage.required: (_) => requiredField,
      },
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Center(
      child: ZemaButtonComponent(
        label: 'Próximo',
        buttonName: 'proximo_form1',
        action: () {
          if (form.valid) {
            Navigator.pushNamed(context, '/form2');
          } else {
            form.markAllAsTouched();
          }
        },
      ),
    );
  }
}
