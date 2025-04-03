import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'form_screen3.dart';

class FormScreen2 extends StatelessWidget {
  const FormScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    final FormGroup form = FormGroup({
      'age': FormControl<int>(
        validators: [Validators.required, Validators.min(18)],
      ),
      'phone': FormControl<String>(
        validators: [Validators.required],
      ),
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 2')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              ReactiveTextField<int>(
                formControlName: 'age',
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number,
              ),
              ReactiveTextField<String>(
                formControlName: 'phone',
                decoration: const InputDecoration(labelText: 'Telefone'),
                keyboardType: TextInputType.phone,
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
                            builder: (context) => const FormScreen3(),
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
