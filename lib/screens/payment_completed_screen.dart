// lib/screens/payment_completed_screen.dart

import 'package:flutter/material.dart';

class PaymentCompletedScreen extends StatelessWidget {
  const PaymentCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagamento Concluído'),
      ),
      body: Center(  // Centraliza o conteúdo na tela
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Centraliza verticalmente
            crossAxisAlignment: CrossAxisAlignment.center,  // Centraliza horizontalmente
            children: [
              Icon(
                Icons.check_circle_outline,  // Ícone de confirmação
                color: Colors.green,
                size: 80,
              ),
              SizedBox(height: 20),
              Text(
                'Pagamento Confirmado!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Seu pagamento foi realizado com sucesso.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
