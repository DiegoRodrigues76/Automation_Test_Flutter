import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'form_screen4.dart';

class FormScreen3 extends StatelessWidget {
  const FormScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    final FormGroup form = FormGroup({
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
              ReactiveTextField<String>(
                formControlName: 'address',
                decoration: const InputDecoration(labelText: 'Endereço'),
                keyboardType: TextInputType.streetAddress,
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
                            builder: (context) => const FormScreen4(),
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
