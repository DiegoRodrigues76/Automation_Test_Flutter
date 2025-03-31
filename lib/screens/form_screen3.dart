import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'form_screen4.dart';

// Tela do terceiro formulário
class FormScreen3 extends StatelessWidget {
  const FormScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final form = FormGroup({
      'address': FormControl<String>(validators: [Validators.required]),
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 3')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              // Campo de entrada para endereço
              ReactiveTextField<String>(
                formControlName: 'address',
                decoration: const InputDecoration(labelText: 'Endereço'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (form.valid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FormScreen4()),
                    );
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
