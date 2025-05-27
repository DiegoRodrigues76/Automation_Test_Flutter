import 'package:flutter/material.dart';
import 'package:automation_test_flutter/domain/entities/payment_details.dart';
import 'package:automation_test_flutter/domain/strategies/payment_strategy.dart';
import 'package:automation_test_flutter/presentation/components/button_component.dart';

class FormScreen5 extends StatelessWidget {
  final PaymentDetails paymentDetails;

  const FormScreen5({super.key, required this.paymentDetails});

  @override
  Widget build(BuildContext context) {
    final strategy = PaymentStrategyFactory.getStrategy(paymentDetails.paymentMethod);

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
            Text('Método de pagamento: ${paymentDetails.paymentMethod.toUpperCase()}'),
            const SizedBox(height: 10),
            strategy.buildPaymentDetails(context, paymentDetails.toMap()),
            const SizedBox(height: 40),
            Center(
              child: ZemaButtonComponent(
                label: 'Confirmar Pagamento',
                buttonName: 'proximo_form5',
                action: () => Navigator.pushNamed(context, '/paymentCompleted'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}