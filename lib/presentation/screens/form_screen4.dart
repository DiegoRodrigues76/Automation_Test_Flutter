import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:automation_test_flutter/constants/constants.dart';
import 'package:automation_test_flutter/widgets/form_fields.dart';
import 'package:automation_test_flutter/presentation/components/button_component.dart';

class FormScreen4 extends StatelessWidget {
  final String paymentMethod;

  const FormScreen4({super.key, required this.paymentMethod});

  FormGroup _buildForm() {
    return FormGroup({
      'paymentMethod': FormControl<String>(value: paymentMethod),
      'cardType': FormControl<String>(validators: [Validators.required]),
      'cardNumber': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(16),
      ]),
      'cardExpiry': FormControl<DateTime>(validators: [Validators.required]),
      'cardCVV': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(3),
      ]),
    });
  }

  String _generateRandomCode(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    final form = _buildForm();
    final pixCode = _generateRandomCode(32);
    final boletoCode = List.generate(48, (_) => Random().nextInt(10)).join();

    form.valueChanges
        .debounceTime(const Duration(milliseconds: 500))
        .listen((value) => debugPrint("📝 Form alterado: $value"));

    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 4 - Pagamento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Método de pagamento: $paymentMethod'),
                const SizedBox(height: 20),
                if (paymentMethod == card) _buildCardFields(form, context),
                if (paymentMethod == pix)
                  Center(child: QrImageView(data: pixCode, size: 200)),
                if (paymentMethod == boleto)
                  Center(
                    child: BarcodeWidget(
                      data: boletoCode,
                      barcode: Barcode.code128(),
                      width: 200,
                      height: 80,
                    ),
                  ),
                const SizedBox(height: 24),
                Center(
                  child: ZemaButtonComponent(
                    label: 'Confirmar Pagamento',
                    buttonName: 'proximo_form4',
                    action: () => _onSubmit(context, form, pixCode, boletoCode),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardFields(FormGroup form, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Detalhes do Cartão'),
        const SizedBox(height: 12),
        CustomReactiveTextField(
          formControlName: 'cardNumber',
          label: 'Número do Cartão',
          keyboardType: TextInputType.number,
          validationMessages: {
            ValidationMessage.required: (_) => requiredField,
            ValidationMessage.minLength: (_) => cardNumberMinLength,
          },
        ),
        const SizedBox(height: 12),
        _buildExpiryDateField(),
        const SizedBox(height: 12),
        CustomReactiveTextField(
          formControlName: 'cardCVV',
          label: 'CVV',
          keyboardType: TextInputType.number,
          obscureText: true,
          validationMessages: {
            ValidationMessage.required: (_) => requiredField,
            ValidationMessage.minLength: (_) => cardCVVMinLength,
          },
        ),
        const SizedBox(height: 12),
        ReactiveDropdownField<String>(
          formControlName: 'cardType',
          decoration: const InputDecoration(labelText: 'Tipo de Cartão'),
          items: const [
            DropdownMenuItem(value: 'Crédito', child: Text('Crédito')),
            DropdownMenuItem(value: 'Débito', child: Text('Débito')),
          ],
          validationMessages: {
            ValidationMessage.required: (_) => cardTypeRequired,
          },
        ),
      ],
    );
  }

  Widget _buildExpiryDateField() {
    return ReactiveFormField<DateTime, DateTime>(
      formControlName: 'cardExpiry',
      builder: (field) {
        return GestureDetector(
          onTap: () => _showMonthYearPicker(field.context, field),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Validade do Cartão',
              errorText: field.errorText,
            ),
            isEmpty: field.value == null,
            child: Text(
              field.value != null
                  ? DateFormat('MM/yy').format(field.value!)
                  : '',
              style: TextStyle(
                fontSize: 16,
                color: field.value != null ? Colors.black : Colors.grey,
              ),
            ),
          ),
        );
      },
      validationMessages: {
        ValidationMessage.required: (_) => cardExpiryRequired,
      },
    );
  }

  void _showMonthYearPicker(BuildContext context, ReactiveFormFieldState<DateTime, DateTime> field) async {
    final now = DateTime.now();
    int selectedMonth = now.month;
    int selectedYear = now.year;

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
                    items: List.generate(10, (index) {
                      final year = now.year + index;
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(DateTime(selectedYear, selectedMonth)),
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

  void _onSubmit(BuildContext context, FormGroup form, String pixCode, String boletoCode) {
    if (paymentMethod != card || form.valid) {
      Navigator.pushNamed(
        context,
        '/form5',
        arguments: {
          'paymentMethod': paymentMethod,
          'cardNumber': form.control('cardNumber').value,
          'cardExpiry': form.control('cardExpiry').value != null
              ? DateFormat('MM/yy').format(form.control('cardExpiry').value)
              : null,
          'cardType': form.control('cardType').value,
          'pixCode': pixCode,
          'boletoCode': boletoCode,
        },
      );
    } else {
      form.markAllAsTouched();
    }
  }
}