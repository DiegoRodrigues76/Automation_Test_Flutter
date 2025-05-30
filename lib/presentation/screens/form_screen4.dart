import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:automation_test_flutter/constants/constants.dart';
import 'package:automation_test_flutter/domain/entities/payment_info.dart';
import 'package:automation_test_flutter/domain/usecases/create_payment_details_usecase.dart';
import 'package:automation_test_flutter/domain/repositories/payment_code_repository.dart';
import 'package:automation_test_flutter/domain/strategies/payment_strategy.dart';
import 'package:automation_test_flutter/presentation/components/button_component.dart';
import 'package:automation_test_flutter/services/logger_service.dart';

class FormScreen4 extends StatefulWidget {
  final PaymentInfo paymentInfo;
  final CreatePaymentDetailsUseCase useCase;
  final PaymentCodeRepository codeRepository;

  const FormScreen4({
    super.key,
    required this.paymentInfo,
    required this.useCase,
    required this.codeRepository,
  });

  @override
  _FormScreen4State createState() => _FormScreen4State();
}

class _FormScreen4State extends State<FormScreen4> {
  final _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final form = widget.useCase.execute(widget.paymentInfo.paymentMethod);
    final paymentData = {
      'pixCode': widget.codeRepository.generatePixCode(),
      'boletoCode': widget.codeRepository.generateBoletoCode(),
    };
    final strategy = PaymentStrategyFactory.getStrategy(widget.paymentInfo.paymentMethod);

    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 4 - Pagamento')),
      body: Screenshot(
        controller: _screenshotController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ReactiveForm(
            formGroup: form,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Método de pagamento: ${widget.paymentInfo.paymentMethod}'),
                  const SizedBox(height: 20),
                  strategy.buildPaymentWidget(context, form, paymentData),
                  const SizedBox(height: 24),
                  Center(
                    child: ZemaButtonComponent(
                      label: 'Confirmar Pagamento',
                      buttonName: 'proximo_form4',
                      action: () => _onSubmit(context, form, paymentData),
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
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context, FormGroup form, Map<String, dynamic> paymentData) {
    if (widget.paymentInfo.paymentMethod != card || form.valid) {
      final paymentDetails = widget.useCase.toEntity(form, pixCode: paymentData['pixCode'], boletoCode: paymentData['boletoCode']);
      Navigator.pushNamed(context, '/form5', arguments: paymentDetails);
    } else {
      form.markAllAsTouched();
    }
  }

  Future<void> _captureAndShareScreenshot() async {
    try {
      final image = await _screenshotController.capture();
      if (image != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/form4_screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File(imagePath);
        await file.writeAsBytes(image);
        LoggerService.info('Screenshot temporária salva em: $imagePath');
        await Share.shareXFiles([XFile(imagePath)], text: 'Captura de tela do Formulário 4');
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