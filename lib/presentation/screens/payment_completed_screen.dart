import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:automation_test_flutter/services/logger_service.dart';

class PaymentCompletedScreen extends StatefulWidget {
  const PaymentCompletedScreen({super.key});

  @override
  _PaymentCompletedScreenState createState() => _PaymentCompletedScreenState();
}

class _PaymentCompletedScreenState extends State<PaymentCompletedScreen> {
  final _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pagamento Concluído')),
      body: Screenshot(
        controller: _screenshotController,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 80,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Pagamento Confirmado!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Seu pagamento foi realizado com sucesso.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _captureAndShareScreenshot,
                  child: const Text('Capturar e Compartilhar Tela'),
                ),
              ],
            ),
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
        final imagePath = '${directory.path}/payment_completed_screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File(imagePath);
        await file.writeAsBytes(image);
        LoggerService.info('Screenshot temporária salva em: $imagePath');
        await Share.shareXFiles([XFile(imagePath)], text: 'Captura de tela de Pagamento Concluído');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Screenshot pronta para compartilhamento')),
          );
        }
      }
    } catch (e, stackTrace) {
      LoggerService.error('Erro ao capturar ou compartilhar screenshot', e, stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao capturar ou compartilhar screenshot')),
        );
      }
    }
  }
}