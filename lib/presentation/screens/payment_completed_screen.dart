import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:automation_test_flutter/presentation/components/button_component.dart';
import 'package:automation_test_flutter/services/logger_service.dart';
import 'package:automation_test_flutter/presentation/routes/app_routes.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 100, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                'Pagamento realizado com sucesso!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ZemaButtonComponent(
                label: 'Voltar ao Menu',
                buttonName: 'voltar_menu',
                action: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.menu,
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 16),
              ZemaButtonComponent(
                label: 'Capturar e Compartilhar Tela',
                buttonName: 'capture_share_payment_completed',
                action: _captureAndShareScreenshot,
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
      if (image == null) {
        throw Exception('Falha ao capturar a imagem');
      }

      await Share.shareXFiles(
        [
          XFile.fromData(
            image,
            name: 'payment_completed_screenshot_${DateTime.now().millisecondsSinceEpoch}.png',
            mimeType: 'image/png',
          ),
        ],
        text: 'Captura de tela de Pagamento Concluído',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Screenshot pronta para compartilhamento')),
        );
      }
    } catch (e, stackTrace) {
      LoggerService.error('Erro ao capturar ou compartilhar screenshot: $e', e, stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao capturar ou compartilhar screenshot: ${e.toString()}'),
          ),
        );
      }
    }
  }
}