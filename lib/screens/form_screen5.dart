import 'package:flutter/material.dart';

// Tela final do formulário, exibindo um resumo ou mensagem de conclusão
class FormScreen5 extends StatelessWidget {
  const FormScreen5({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resumo')),
      body: const Center(
        child: Text('Formulário finalizado!'),
      ),
    );
  }
}
