import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

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
      appBar: AppBar(title: Text('Formulário 1')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              ReactiveTextField<String>(
                formControlName: 'name',
                decoration: InputDecoration(labelText: 'Nome'),
                validationMessages: {
                  ValidationMessage.required: (_) => 'Por favor, insira seu nome.',
                },
              ),
              ReactiveTextField<String>(
                formControlName: 'email',
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validationMessages: {
                  ValidationMessage.required: (_) => 'Por favor, insira seu e-mail.',
                  ValidationMessage.email: (_) => 'Por favor, insira um e-mail válido.',
                },
              ),
              ReactiveTextField<String>(
                formControlName: 'phone',
                decoration: InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
                validationMessages: {
                  ValidationMessage.required: (_) => 'Por favor, insira seu telefone.',
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (form.valid) {
                    Navigator.pushNamed(context, '/form2');
                  } else {
                    form.markAllAsTouched(); // Mostra as mensagens de erro
                  }
                },
                child: Text('Próximo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
