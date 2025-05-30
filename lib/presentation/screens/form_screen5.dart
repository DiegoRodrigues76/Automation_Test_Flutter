import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:automation_test_flutter/domain/entities/payment_details.dart';
import 'package:automation_test_flutter/domain/strategies/payment_strategy.dart';
import 'package:automation_test_flutter/presentation/components/button_component.dart';
import 'package:automation_test_flutter/services/logger_service.dart';

class FormScreen5 extends StatefulWidget {
  final PaymentDetails paymentDetails;

  const FormScreen5({super.key, required this.paymentDetails});

  @override
  _FormScreen5State createState() => _FormScreen5State();
}

class _FormScreen5State extends State<FormScreen5> {
  final _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final strategy = PaymentStrategyFactory.getStrategy(widget.paymentDetails.paymentMethod);

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmação de Pagamento')),
      body: Screenshot(
        controller: _screenshotController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Resumo do Pagamento',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text('Método de pagamento: ${widget.paymentDetails.paymentMethod.toUpperCase()}'),
              const SizedBox(height: 10),
              strategy.buildPaymentDetails(context, widget.paymentDetails.toMap()),
              const SizedBox(height: 40),
              Center(
                child: ZemaButtonComponent(
                  label: 'Confirmar Pagamento',
                  buttonName: 'proximo_form5',
                  action: () => Navigator.pushNamed(context, '/paymentCompleted'),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _captureAndShareScreenshot,
                  child: const Text('Capturar e Compartilhar Tela'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _captureAndShareScreenshot() async {
    try {
      final image = await _screenshotController.capture();
      if (image != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/form5_screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File(imagePath);
        await file.writeAsBytes(image);
        LoggerService.info('Screenshot temporária salva em: $imagePath');
        await Share.shareXFiles([XFile(imagePath)], text: 'Captura de tela do Formulário 5');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Screenshot pronta para compartilhamento')),
        );
      }
    } catch (e, stackTrace) {
      LoggerService.error('Erro ao capturar ou compartilhar screenshot', e, stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao capturar ou compartilhar screenshot')),
      );
    }
  }
}