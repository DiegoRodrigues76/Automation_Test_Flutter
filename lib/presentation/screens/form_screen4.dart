import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:automation_test_flutter/domain/entities/payment_info.dart';
import 'package:automation_test_flutter/domain/usecases/create_payment_details_usecase.dart';
import 'package:automation_test_flutter/domain/repositories/payment_code_repository.dart';
import 'package:automation_test_flutter/domain/strategies/payment_strategy.dart';
import 'package:automation_test_flutter/presentation/components/button_component.dart';
import 'package:automation_test_flutter/widgets/form_fields.dart';
import 'package:automation_test_flutter/services/logger_service.dart';
import 'package:automation_test_flutter/presentation/routes/app_routes.dart';
import 'package:automation_test_flutter/presentation/routes/form_data_arguments.dart';
import 'package:automation_test_flutter/constants/constants.dart';

class FormScreen4 extends StatefulWidget {
  final PaymentInfo paymentInfo;
  final FormDataArguments? arguments;
  final CreatePaymentDetailsUseCase useCase;
  final PaymentCodeRepository codeRepository;

  const FormScreen4({
    super.key,
    required this.paymentInfo,
    this.arguments,
    required this.useCase,
    required this.codeRepository,
  });

  @override
  _FormScreen4State createState() => _FormScreen4State();
}

class _FormScreen4State extends State<FormScreen4> {
  final _screenshotController = ScreenshotController();
  late FormGroup form;
  bool _isLoading = false;
  String? _errorMessage;
  PaymentStrategy? _paymentStrategy;

  @override
  void initState() {
    super.initState();
    try {
      form = widget.useCase.execute(widget.paymentInfo.paymentMethod);
      _paymentStrategy = PaymentStrategyFactory.getStrategy(widget.paymentInfo.paymentMethod);
      if (widget.paymentInfo.paymentMethod == card) {
        final requiredControls = ['cardNumber', 'cardExpiry', 'cardCVV', 'cardType'];
        for (var control in requiredControls) {
          if (!form.controls.containsKey(control)) {
            throw Exception('Form control missing: $control');
          }
        }
        LoggerService.debug('Card form controls validated: ${form.controls.keys}');
      }
      LoggerService.debug(
        'FormScreen4 initialized with personalInfo: ${widget.arguments?.personalInfo ?? 'none'}, '
        'address: ${widget.arguments?.address ?? 'none'}, '
        'paymentInfo: ${widget.paymentInfo.toMap()}',
      );
    } catch (e, stackTrace) {
      LoggerService.error('Error initializing FormScreen4: $e', stackTrace);
      setState(() {
        _errorMessage = 'Erro ao carregar formulário de pagamento: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Formulário 4')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ZemaButtonComponent(
                label: 'Voltar',
                buttonName: 'voltar_form4',
                action: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 4')),
      body: Screenshot(
        controller: _screenshotController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ReactiveForm(
            formGroup: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.paymentInfo.paymentMethod == card)
                  _paymentStrategy!.buildPaymentWidget(context, form, widget.useCase.validationMessages('card'))
                else ...[
                  CustomReactiveTextField(
                    formControlName: 'code',
                    label: 'Código de Pagamento',
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    validationMessages: widget.useCase.validationMessages('code')['code']!,
                    onChanged: (value) {
                      final codeControl = form.control('code');
                      if (codeControl.invalid && codeControl.touched) {
                        LoggerService.debug('Code validation errors: ${codeControl.errors}');
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : ZemaButtonComponent(
                            label: 'Gerar Código',
                            buttonName: 'gerar_codigo_form4',
                            action: _generateCode,
                          ),
                  ),
                ],
                const SizedBox(height: 20),
                Center(
                  child: ZemaButtonComponent(
                    label: 'Próximo',
                    buttonName: 'proximo_form4',
                    action: () {
                      if (form.valid) {
                        final paymentDetails = widget.useCase.toEntity(
                          form,
                          widget.paymentInfo.paymentMethod,
                        );
                        LoggerService.debug('Navigating to FormScreen5 with paymentDetails: ${paymentDetails.toString()}');
                        Navigator.pushNamed(
                          context,
                          AppRoutes.form5,
                          arguments: FormDataArguments(
                            personalInfo: widget.arguments?.personalInfo,
                            address: widget.arguments?.address,
                            paymentInfo: widget.arguments?.paymentInfo,
                            paymentDetails: paymentDetails,
                          ),
                        );
                      } else {
                        form.markAllAsTouched();
                        LoggerService.debug('Form invalid: ${form.errors}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Por favor, preencha todos os campos corretamente.'),
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
                    buttonName: 'capture_share_form4',
                    action: _captureAndShareScreenshot,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _generateCode() async {
    setState(() => _isLoading = true);
    try {
      final code = await widget.codeRepository.generateCode(widget.paymentInfo.paymentMethod);
      form.control('code').value = code;
      LoggerService.debug('Generated code: $code');
    } catch (e, stackTrace) {
      LoggerService.error('Erro ao gerar código: $e', stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao gerar código: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
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
            name: 'form4_screenshot_${DateTime.now().millisecondsSinceEpoch}.png',
            mimeType: 'image/png',
          ),
        ],
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Screenshot pronto para compartilhamento')),
        );
      }
    } catch (e, stackTrace) {
      LoggerService.error('Erro ao capturar ou compartilhar screenshot: $e', stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao capturar ou compartilhar screenshot: ${e.toString()}')),
        );
      }
    }
  }
}