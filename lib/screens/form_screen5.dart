import 'package:automation_test_flutter/modules/common/components/button_component.dart';
import 'package:flutter/material.dart';
import 'package:automation_test_flutter/constants/constants.dart';

class FormScreen5 extends StatelessWidget {
  final Map<String, dynamic> paymentData;

  const FormScreen5({super.key, required this.paymentData});

  @override
  Widget build(BuildContext context) {
    final String? paymentMethod = paymentData['paymentMethod'];

    if (paymentMethod == null) {
      return const Scaffold(
        body: Center(
          child: Text('Dados de pagamento não fornecidos.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmação de Pagamento'),
      ),
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
            Text('Método de pagamento: ${paymentMethod.toUpperCase()}'),
            const SizedBox(height: 10),
            _buildPaymentDetails(paymentMethod),
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

  Widget _buildPaymentDetails(String method) {
    switch (method) {
      case card:
        return _CardPaymentDetails(paymentData: paymentData);
      case pix:
        return _PixPaymentDetails(code: paymentData['pixCode']);
      case boleto:
        return _BoletoPaymentDetails(code: paymentData['boletoCode']);
      default:
        return const Text('Método de pagamento não reconhecido.');
    }
  }
}

class _CardPaymentDetails extends StatelessWidget {
  final Map<String, dynamic> paymentData;

  const _CardPaymentDetails({required this.paymentData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Número do Cartão: ${paymentData['cardNumber'] ?? "Não informado"}'),
        Text('Validade: ${paymentData['cardExpiry'] ?? "Não informado"}'),
        Text('Tipo do Cartão: ${paymentData['cardType'] ?? "Não informado"}'),
      ],
    );
  }
}

class _PixPaymentDetails extends StatelessWidget {
  final String? code;

  const _PixPaymentDetails({required this.code});

  @override
  Widget build(BuildContext context) {
    return Text('Código Pix: ${code ?? "Não informado"}');
  }
}

class _BoletoPaymentDetails extends StatelessWidget {
  final String? code;

  const _BoletoPaymentDetails({required this.code});

  @override
  Widget build(BuildContext context) {
    return Text('Código de Barras: ${code ?? "Não informado"}');
  }
}
