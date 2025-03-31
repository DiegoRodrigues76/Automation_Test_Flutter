import 'package:flutter/material.dart'; 
import 'package:reactive_forms/reactive_forms.dart'; 
import 'form_screen2.dart'; 

// Tela do primeiro formulário
class FormScreen1 extends StatelessWidget {
  const FormScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    // Criação do formulário reativo com validações
    final form = FormGroup({
      'name': FormControl<String>(validators: [Validators.required]),
      'email': FormControl<String>(validators: [Validators.required, Validators.email]),
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 1')), // Barra de navegação com título
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adiciona um espaçamento ao redor do formulário
        child: ReactiveForm(
          formGroup: form, // Define o grupo de controle do formulário
          child: Column(
            children: [
              // Campo de entrada para o nome
              ReactiveTextField<String>(
                formControlName: 'name', // Conecta o campo ao formGroup
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              // Campo de entrada para o email
              ReactiveTextField<String>(
                formControlName: 'email', // Conecta o campo ao formGroup
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (form.valid) { // Verifica se o formulário é válido antes de navegar
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FormScreen2()), // Navega para a próxima tela
                    );
                  }
                },
                child: const Text('Próximo'), // Texto do botão
              ),
            ],
          ),
        ),
      ),
    );
  }
}
