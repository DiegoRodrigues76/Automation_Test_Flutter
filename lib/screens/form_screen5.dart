import 'package:automation_test_flutter/modules/common/components/button_component.dart';
import 'package:flutter/material.dart';
import 'package:automation_test_flutter/constants/constants.dart';

class FormScreen5 extends StatelessWidget {
  final Map<String, dynamic> paymentData;
  const FormScreen5({super.key, required this.paymentData});

  @override
  Widget build(BuildContext context) {
    final pixCode = paymentData['pixCode'];
    final boletoCode = paymentData['boletoCode'];

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return const Scaffold(
        body: Center(child: Text('Dados de pagamento não fornecidos.')),
      );
    }

    final paymentMethod = args['paymentMethod'];
    final cardNumber = args['cardNumber'];
    final cardExpiry = args['cardExpiry'];
    final cardType = args['cardType'];

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmação de Pagamento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumo do Pagamento',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Método de pagamento: ${paymentMethod.toString().toUpperCase()}'),
            if (paymentMethod == card) ...[
              const SizedBox(height: 10),
              Text('Número do Cartão: ${cardNumber ?? "Não informado"}'),
              Text('Validade: ${cardExpiry ?? "Não informado"}'),
              Text('Tipo do Cartão: ${cardType ?? "Não informado"}'),
            ] else if (paymentMethod == pix) ...[
              const SizedBox(height: 10),
              Text('Código Pix: ${pixCode ?? "Não informado"}'),
            ] else if (paymentMethod == boleto) ...[
              Text('Código de Barras: ${boletoCode ?? "Não informado"}'),
            ],
            const SizedBox(height: 40),
            Center(
              child: ZemaButtonComponent(
                label: 'Confirmar Pagamento',
                buttonName: 'proximo_form5',
                action: () {
                  Navigator.pushNamed(context, '/paymentCompleted');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}