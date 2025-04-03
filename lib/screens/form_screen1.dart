import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'form_screen2.dart';

class FormScreen1 extends StatelessWidget {
  const FormScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    final FormGroup form = FormGroup({
      'name': FormControl<String>(validators: [Validators.required]),
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 1')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              ReactiveTextField<String>(
                formControlName: 'name',
                decoration: const InputDecoration(labelText: 'Nome'),
                keyboardType: TextInputType.text,
              ),
              ReactiveTextField<String>(
                formControlName: 'email',
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Voltar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (form.valid) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FormScreen2(),
                          ),
                        );
                      }
                    },
                    child: const Text('Próximo'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
