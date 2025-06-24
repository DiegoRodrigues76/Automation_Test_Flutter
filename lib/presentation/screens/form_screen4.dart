import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
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
  bool _codeGenerated = false;
  String? _generatedCode;

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
      } else {
        if (!form.controls.containsKey('code')) {
          throw Exception('Form control missing: code');
        }
        form.control('code').valueChanges.listen((value) {
          setState(() {
            _generatedCode = value?.toString();
            _codeGenerated = _generatedCode != null && _generatedCode!.isNotEmpty;
          });
        });
        LoggerService.debug('Non-card form controls validated: ${form.controls.keys}');
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
        appBar: AppBar(title: const Text('Formulário 4', key: Key('form4_title'))),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ZemaButtonComponent(
                label: 'Voltar',
                buttonName: 'voltar_form4',
                key: const Key('voltar_form4_button'),
                action: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 4', key: Key('form4_title'))),
      body: Screenshot(
        controller: _screenshotController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ReactiveForm(
            formGroup: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.paymentInfo.paymentMethod == card) ...[
                  CustomReactiveTextField(
                    formControlName: 'cardNumber',
                    label: 'Número do Cartão',
                    key: const Key('card_number_field'),
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    validationMessages: widget.useCase.validationMessages('card')['cardNumber'],
                    onChanged: (value) {
                      final control = form.control('cardNumber');
                      if (control.invalid && control.touched) {
                        LoggerService.debug('Card number errors: ${control.errors}');
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildExpiryDateField(),
                  const SizedBox(height: 16),
                  CustomReactiveTextField(
                    formControlName: 'cardCVV',
                    label: 'CVV',
                    key: const Key('card_cvv_field'),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    validationMessages: widget.useCase.validationMessages('card')['cardCVV'],
                    onChanged: (value) {
                      final control = form.control('cardCVV');
                      if (control.invalid && control.touched) {
                        LoggerService.debug('Card CVV errors: ${control.errors}');
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  ReactiveDropdownField<String>(
                    formControlName: 'cardType',
                    key: const Key('card_type_dropdown'),
                    decoration: const InputDecoration(labelText: 'Tipo de Cartão'),
                    items: const [
                      DropdownMenuItem(value: 'credit', child: Text('Crédito')),
                      DropdownMenuItem(value: 'debit', child: Text('Débito')),
                    ],
                    validationMessages: widget.useCase.validationMessages('card')['cardType'],
                  ),
                ] else ...[
                  _paymentStrategy!.buildPaymentWidget(
                    context,
                    form,
                    {
                      'pixCode': _generatedCode,
                      'boletoCode': _generatedCode,
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomReactiveTextField(
                    formControlName: 'code',
                    label: 'Código de Pagamento',
                    key: const Key('payment_code_field'),
                    keyboardType: TextInputType.text,
                    obscureText: false,
                    readOnly: true,
                    validationMessages: widget.useCase.validationMessages('code')['code']!,
                    onChanged: (value) {
                      final control = form.control('code');
                      if (control.invalid && control.touched) {
                        LoggerService.debug('Code validation errors: ${control.errors}');
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Clique em "Gerar Código" para obter o código de pagamento.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : ZemaButtonComponent(
                            label: 'Gerar Código',
                            buttonName: 'gerar_codigo_form4',
                            key: const Key('gerar_codigo_form4_button'),
                            action: _generateCode,
                          ),
                  ),
                ],
                const SizedBox(height: 20),
                Center(
                  child: ZemaButtonComponent(
                    label: 'Próximo',
                    buttonName: 'proximo_form4',
                    key: const Key('proximo_form4_button'),
                    isEnabled: widget.paymentInfo.paymentMethod == card || _codeGenerated,
                    action: () {
                      if (form.valid) {
                        final paymentDetails = widget.useCase.toEntity(
                          form,
                          widget.paymentInfo.paymentMethod,
                        );
                        LoggerService.debug('Navigating to FormScreen5 with paymentDetails: ${paymentDetails.toMap()}');
                        Navigator.pushNamed(
                          context,
                          AppRoutes.form5,
                          arguments: FormDataArguments(
                            personalInfo: widget.arguments?.personalInfo,
                            address: widget.arguments?.address,
                            paymentInfo: widget.paymentInfo,
                            paymentDetails: paymentDetails,
                          ),
                        );
                      } else {
                        form.markAllAsTouched();
                        LoggerService.debug('Form invalid: ${form.errors}');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              widget.paymentInfo.paymentMethod == card
                                  ? 'Por favor, preencha os campos do cartão corretamente.'
                                  : 'Por favor, gere o código antes de prosseguir.',
                            ),
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
                    key: const Key('capture_share_form4_button'),
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

  Widget _buildExpiryDateField() {
    return ReactiveFormField<DateTime, DateTime>(
      formControlName: 'cardExpiry',
      key: const Key('card_expiry_field'),
      builder: (field) {
        return GestureDetector(
          onTap: () => _showMonthYearPicker(context, field),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Validade do Cartão',
              errorText: field.errorText,
              border: const OutlineInputBorder(),
            ),
            isEmpty: field.value == null,
            child: Text(
              field.value != null ? DateFormat('MM/yy').format(field.value!) : '',
              style: TextStyle(
                fontSize: 16,
                color: field.value != null ? Colors.black : Colors.grey,
              ),
            ),
          ),
        );
      },
      validationMessages: widget.useCase.validationMessages('card')['cardExpiry'],
    );
  }

  void _showMonthYearPicker(BuildContext context, ReactiveFormFieldState<DateTime, DateTime> field) async {
    final now = DateTime.now();
    int selectedMonth = field.value?.month ?? now.month;
    int selectedYear = field.value?.year ?? now.year;

    final picked = await showDialog<DateTime>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Row(
              children: [
                Expanded(
                  child: DropdownButton<int>(
                    value: selectedMonth,
                    onChanged: (value) => setState(() => selectedMonth = value!),
                    items: List.generate(12, (index) {
                      final month = index + 1;
                      return DropdownMenuItem(
                        value: month,
                        child: Text(month.toString().padLeft(2, '0')),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButton<int>(
                    value: selectedYear,
                    onChanged: (value) => setState(() => selectedYear = value!),
                    items: List.generate(101, (index) {
                      final year = now.year + index - 50; // Range de 50 anos antes e 50 anos depois
                      if (year >= 2000 && year <= 2100) {
                        return DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        );
                      }
                      return null;
                    }).whereType<DropdownMenuItem<int>>().toList(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(DateTime(selectedYear, selectedMonth)),
                child: const Text('OK'),
              ),
            ],
          );
        },
      ),
    );

    if (picked != null) {
      field.didChange(picked);
    }
  }

  Future<void> _generateCode() async {
    setState(() => _isLoading = true);
    try {
      final code = await widget.codeRepository.generateCode(widget.paymentInfo.paymentMethod);
      form.control('code').value = code;
      setState(() {
        _generatedCode = code;
        _codeGenerated = true;
      });
      LoggerService.debug('Generated code: $code');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            key: Key('code_generated_snackbar'),
            content: Text('Código gerado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stackTrace) {
      LoggerService.error('Erro ao gerar código: $e', stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao gerar código: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
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