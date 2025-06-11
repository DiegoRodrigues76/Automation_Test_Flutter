import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:automation_test_flutter/domain/entities/payment_details.dart';
import 'package:automation_test_flutter/presentation/components/button_component.dart';
import 'package:automation_test_flutter/services/logger_service.dart';
import 'package:automation_test_flutter/presentation/routes/app_routes.dart';
import 'package:automation_test_flutter/presentation/routes/form_data_arguments.dart';

class FormScreen5 extends StatefulWidget {
  final PaymentDetails paymentDetails;
  final FormDataArguments? arguments;

  const FormScreen5({
    super.key,
    required this.paymentDetails,
    this.arguments,
  });

  @override
  _FormScreen5State createState() => _FormScreen5State();
}

class _FormScreen5State extends State<FormScreen5> {
  final _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    LoggerService.debug('Personal Info: ${widget.arguments?.personalInfo}');
    LoggerService.debug('Address: ${widget.arguments?.address}');
    LoggerService.debug('Payment Details: ${widget.paymentDetails.toMap()}');
  }

  @override
  Widget build(BuildContext context) {
    final paymentCode = widget.paymentDetails.pixCode ??
        widget.paymentDetails.boletoCode ??
        widget.paymentDetails.cardNumber ??
        'N/A';
    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 5')),
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
              const SizedBox(height: 16),
              Text('Nome: ${widget.arguments?.personalInfo?['name'] ?? 'N/A'}'),
              Text('E-mail: ${widget.arguments?.personalInfo?['email'] ?? 'N/A'}'),
              Text('Telefone: ${widget.arguments?.personalInfo?['phone'] ?? 'N/A'}'),
              const SizedBox(height: 16),
              Text('País: ${widget.arguments?.address?['country'] ?? 'N/A'}'),
              Text('CEP: ${widget.arguments?.address?['cep'] ?? 'N/A'}'),
              Text('Rua: ${widget.arguments?.address?['street'] ?? 'N/A'}'),
              Text('Bairro: ${widget.arguments?.address?['neighborhood'] ?? 'N/A'}'),
              Text('Cidade: ${widget.arguments?.address?['city'] ?? 'N/A'}'),
              Text('Estado: ${widget.arguments?.address?['state'] ?? 'N/A'}'),
              const SizedBox(height: 16),
              Text('Código de Pagamento: $paymentCode'),
              Text('Tipo de Pagamento: ${widget.paymentDetails.paymentMethod}'),
              const SizedBox(height: 32),
              Center(
                child: ZemaButtonComponent(
                  label: 'Confirmar',
                  buttonName: 'confirmar_form5',
                  action: () {
                    Navigator.pushNamed(context, AppRoutes.paymentCompleted);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: ZemaButtonComponent(
                  label: 'Capturar e Compartilhar Tela',
                  buttonName: 'capture_share_form2',
                  action: _captureAndShareScreenshot,
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
      if (image == null) {
        throw Exception('Falha ao capturar a imagem');
      }

      await Share.shareXFiles(
        [
          XFile.fromData(
            image,
            name: 'form5_screenshot_${DateTime.now().millisecondsSinceEpoch}.png',
            mimeType: 'image/png',
          ),
        ],
        text: 'Captura de tela do Formulário 5',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Screenshot pronta para compartilhamento')),
        );
      }
    } catch (e, stackTrace) {
      LoggerService.error('Erro ao capturar ou compartilhar imagem: $e', stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao capturar ou compartilhar screenshot: ${e.toString()}'),
        ),
      );
    }
  }
}