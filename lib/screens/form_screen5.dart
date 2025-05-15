// lib/screens/form_screen5.dart
import 'package:flutter/material.dart';
import 'payment_completed_screen.dart';

class FormScreen5 extends StatelessWidget {
  final Map<String, dynamic> paymentData;
  const FormScreen5({super.key, required this.paymentData});

  @override
  Widget build(BuildContext context) {
    final pixCode = paymentData['pixCode'];
    final boletoCode = paymentData['boletoCode'];

    // Recupera os argumentos passados pela rota
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return Scaffold(
        body: Center(child: Text('Dados de pagamento não fornecidos.')),
      );
    }

    final paymentMethod = args['paymentMethod'];
    final cardNumber = args['cardNumber'];
    final cardExpiry = args['cardExpiry'];
    final cardType = args ['cardType'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Confirmação de Pagamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumo do Pagamento',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Método de pagamento: ${paymentMethod.toString().toUpperCase()}'),
            if (paymentMethod == 'cartão' || paymentMethod == 'card') ...[
              SizedBox(height: 10),
              Text('Número do Cartão: ${cardNumber ?? "Não informado"}'),
              Text('Validade: ${cardExpiry ?? "Não informado"}'),
              Text('Tipo do Cartão: ${cardType ?? "Não informado"}'),
            ] else if (paymentMethod == 'pix') ...[
              SizedBox(height: 10),
              Text('Código Pix: ${pixCode ?? "Não informado"}'),
            ] else if (paymentMethod == 'boleto') ...[
              Text('Código de Barras: ${boletoCode ?? "Não informado"}'),
            ],
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PaymentCompletedScreen()),
                  );
                },
                child: Text('Confirmar Pagamento'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
