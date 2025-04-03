import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'form_screen5.dart';

class FormScreen4 extends StatelessWidget {
  const FormScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    final FormGroup form = FormGroup({
      'credit_card': FormControl<String>(validators: [Validators.required]),
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 4')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              ReactiveTextField<String>(
                formControlName: 'credit_card',
                decoration: const InputDecoration(labelText: 'Cartão de Crédito'),
                keyboardType: TextInputType.number,
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
                            builder: (context) => const FormScreen5(),
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
