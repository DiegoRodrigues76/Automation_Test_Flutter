import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:automation_test_flutter/widgets/form_fields.dart';
import 'package:automation_test_flutter/domain/usecases/create_payment_details_usecase.dart';
import 'package:automation_test_flutter/constants/constants.dart';

abstract class PaymentStrategy {
  Widget buildPaymentWidget(BuildContext context, FormGroup form, Map<String, dynamic> paymentData);
  Widget buildPaymentDetails(BuildContext context, Map<String, dynamic> paymentData);
}

class CardPaymentStrategy implements PaymentStrategy {
  @override
  Widget buildPaymentWidget(BuildContext context, FormGroup form, Map<String, dynamic> paymentData) {
    final useCase = CreatePaymentDetailsUseCase();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Detalhes do Cartão'),
        const SizedBox(height: 12),
        CustomReactiveTextField(
          formControlName: 'cardNumber',
          label: 'Número do Cartão',
          keyboardType: TextInputType.number,
          validationMessages: useCase.validationMessages('cardNumber'),
        ),
        const SizedBox(height: 12),
        _buildExpiryDateField(form, useCase),
        const SizedBox(height: 12),
        CustomReactiveTextField(
          formControlName: 'cardCVV',
          label: 'CVV',
          keyboardType: TextInputType.number,
          obscureText: true,
          validationMessages: useCase.validationMessages('cardCVV'),
        ),
        const SizedBox(height: 12),
        ReactiveDropdownField<String>(
          formControlName: 'cardType',
          decoration: const InputDecoration(labelText: 'Tipo de Cartão'),
          items: const [
            DropdownMenuItem(value: 'Crédito', child: Text('Crédito')),
            DropdownMenuItem(value: 'Débito', child: Text('Débito')),
          ],
          validationMessages: useCase.validationMessages('cardType'),
        ),
      ],
    );
  }

  Widget _buildExpiryDateField(FormGroup form, CreatePaymentDetailsUseCase useCase) {
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
      validationMessages: useCase.validationMessages('cardExpiry'),
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

  @override
  Widget buildPaymentDetails(BuildContext context, Map<String, dynamic> paymentData) {
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

class PixPaymentStrategy implements PaymentStrategy {
  @override
  Widget buildPaymentWidget(BuildContext context, FormGroup form, Map<String, dynamic> paymentData) {
    return Center(child: QrImageView(data: paymentData['pixCode'], size: 200));
  }

  @override
  Widget buildPaymentDetails(BuildContext context, Map<String, dynamic> paymentData) {
    return Text('Código Pix: ${paymentData['pixCode'] ?? "Não informado"}');
  }
}

class BoletoPaymentStrategy implements PaymentStrategy {
  @override
  Widget buildPaymentWidget(BuildContext context, FormGroup form, Map<String, dynamic> paymentData) {
    return Center(
      child: BarcodeWidget(
        data: paymentData['boletoCode'],
        barcode: Barcode.code128(),
        width: 200,
        height: 80,
      ),
    );
  }

  @override
  Widget buildPaymentDetails(BuildContext context, Map<String, dynamic> paymentData) {
    return Text('Código de Barras: ${paymentData['boletoCode'] ?? "Não informado"}');
  }
}

class PaymentStrategyFactory {
  static PaymentStrategy getStrategy(String paymentMethod) {
    switch (paymentMethod) {
      case card:
        return CardPaymentStrategy();
      case pix:
        return PixPaymentStrategy();
      case boleto:
        return BoletoPaymentStrategy();
      default:
        throw Exception('Método de pagamento não suportado');
    }
  }
}