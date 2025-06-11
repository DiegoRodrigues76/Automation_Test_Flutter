import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:automation_test_flutter/domain/usecases/create_payment_info_usecase.dart';
import 'package:automation_test_flutter/presentation/components/button_component.dart';
import 'package:automation_test_flutter/constants/constants.dart';
import 'package:automation_test_flutter/services/logger_service.dart';
import 'package:automation_test_flutter/presentation/routes/app_routes.dart';
import 'package:automation_test_flutter/presentation/routes/form_data_arguments.dart';

class FormScreen3 extends StatefulWidget {
  final CreatePaymentInfoUseCase useCase;
  final FormDataArguments? arguments;

  const FormScreen3({
    super.key,
    required this.useCase,
    this.arguments,
  });

  @override
  _FormScreen3State createState() => _FormScreen3State();
}

class _FormScreen3State extends State<FormScreen3> {
  final _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    LoggerService.debug('Personal Info: ${widget.arguments?.personalInfo}');
    LoggerService.debug('Address: ${widget.arguments?.address}');
  }

  @override
  Widget build(BuildContext context) {
    final form = widget.useCase.execute();

    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 3')),
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
                  ReactiveDropdownField<String>(
                    formControlName: 'paymentMethod',
                    decoration: const InputDecoration(labelText: 'Forma de pagamento'),
                    items: const [
                      DropdownMenuItem(value: pix, child: Text('Pix')),
                      DropdownMenuItem(value: card, child: Text('Cartão de Crédito/Débito')),
                      DropdownMenuItem(value: boleto, child: Text('Boleto')),
                    ],
                    validationMessages: widget.useCase.validationMessages('paymentMethod'),
                  ),
                  const SizedBox(height: 20),
                  _buildDeliveryDateField(form),
                  const SizedBox(height: 20),
                  _buildTermsCheckbox(form),
                  const SizedBox(height: 20),
                  ReactiveCheckboxListTile(
                    formControlName: 'receiveEmails',
                    title: const Text('Gostaria de receber propagandas por e-mail'),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ZemaButtonComponent(
                      label: 'Avançar para Pagamento',
                      buttonName: 'proximo_form3',
                      action: () {
                        if (form.valid) {
                          final paymentInfo = widget.useCase.toEntity(form);
                          Navigator.pushNamed(
                            context,
                            AppRoutes.form4,
                            arguments: FormDataArguments(
                              personalInfo: widget.arguments?.personalInfo,
                              address: widget.arguments?.address,
                              paymentInfo: paymentInfo,
                            ),
                          );
                        } else {
                          form.markAllAsTouched();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Por favor, corrija os erros no formulário.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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
        ),
      ),
    );
  }

  Widget _buildDeliveryDateField(FormGroup form) {
    return ReactiveFormField<DateTime, DateTime>(
      formControlName: 'deliveryDate',
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Data de Envio'),
            subtitle: Text(
              field.value != null
                  ? DateFormat('dd/MM/yyyy', 'pt_BR').format(field.value!)
                  : 'Escolha a data',
            ),
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: field.context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                locale: const Locale('pt', 'BR'),
                builder: (BuildContext context, Widget? child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: ZemaColors.primary,
                        onPrimary: Colors.white,
                        onSurface: Colors.black,
                      ),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(foregroundColor: Colors.black),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (selectedDate != null) {
                field.didChange(selectedDate);
              }
            },
          ),
          if (field.control.invalid && field.control.touched)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.useCase.validationMessages('deliveryDate')[ValidationMessage.required]!(null),
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox(FormGroup form) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReactiveCheckboxListTile(
          formControlName: 'agreeToTerms',
          title: const Text('Li e concordo com os termos e condições'),
        ),
        if (form.control('agreeToTerms').invalid && form.control('agreeToTerms').touched)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              widget.useCase.validationMessages('agreeToTerms')[ValidationMessage.requiredTrue]!(null),
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
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
            name: 'form3_screenshot_${DateTime.now().millisecondsSinceEpoch}.png',
            mimeType: 'image/png',
          ),
        ],
        text: 'Captura de tela do Formulário 3',
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