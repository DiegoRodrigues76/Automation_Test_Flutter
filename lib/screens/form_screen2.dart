import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'form_screen3.dart';

// Tela do segundo formulário
class FormScreen2 extends StatelessWidget {
  const FormScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    // Criação do formulário reativo com validações
    final form = FormGroup({
      'age': FormControl<int>(validators: [Validators.required, Validators.min(18)]), // Campo obrigatório para idade, mínimo 18 anos
      'phone': FormControl<String>(validators: [Validators.required]), // Campo obrigatório para telefone
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 2')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              // Campo de entrada para idade
              ReactiveTextField<int>(
                formControlName: 'age',
                decoration: const InputDecoration(labelText: 'Idade'),
                keyboardType: TextInputType.number, // Define o teclado numérico para a entrada
              ),
              // Campo de entrada para telefone
              ReactiveTextField<String>(
                formControlName: 'phone',
                decoration: const InputDecoration(labelText: 'Telefone'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (form.valid) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FormScreen3()),
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
