import 'dart:math';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:automation_test_flutter/constants/constants.dart';

class FormScreen4 extends StatelessWidget {
  final String paymentMethod;

  const FormScreen4({super.key, required this.paymentMethod});

  String _generatePixCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return List.generate(32, (index) => chars[rand.nextInt(chars.length)]).join();
  }

  String _generateBoletoCode() {
    final rand = Random();
    return List.generate(48, (_) => rand.nextInt(10)).join();
  }

  FormGroup createForm() {
    return FormGroup({
      'paymentMethod': FormControl<String>(value: paymentMethod),
      'cardType': FormControl<String>(validators: [Validators.required]),
      'cardNumber': FormControl<String>(
        validators: [Validators.required, Validators.minLength(16)],
      ),
      'cardExpiry': FormControl<String>(validators: [Validators.required]),
      'cardCVV': FormControl<String>(
        validators: [Validators.required, Validators.minLength(3)],
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    final form = createForm();

    form.valueChanges
        .debounceTime(Duration(milliseconds: 500))
        .listen((value) {
      debugPrint("📝 Form alterado: $value");
    });

    // Gere os códigos uma única vez e reaproveite
    final String pixCode = _generatePixCode();
    final String boletoCode = _generateBoletoCode();

    return Scaffold(
      appBar: AppBar(
        title: Text('Formulário 4 - Pagamento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Método de pagamento: $paymentMethod'),
              SizedBox(height: 20),

              if (paymentMethod == card) ...[
                Text('Detalhes do Cartão'),
                ReactiveTextField<String>(
                  formControlName: 'cardNumber',
                  decoration: InputDecoration(labelText: 'Número do Cartão'),
                  keyboardType: TextInputType.number,
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Insira o número do cartão.',
                    ValidationMessage.minLength: (_) => 'O cartão deve conter 16 dígitos.',
                  },
                ),
                ReactiveTextField<String>(
                  formControlName: 'cardExpiry',
                  decoration: InputDecoration(labelText: 'Validade (MM/AA)'),
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Insira a validade do cartão.',
                  },
                ),
                ReactiveTextField<String>(
                  formControlName: 'cardCVV',
                  decoration: InputDecoration(labelText: 'CVV'),
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Insira o código CVV.',
                    ValidationMessage.minLength: (_) => 'O CVV deve conter pelo menos 3 dígitos.',
                  },
                ),
                ReactiveDropdownField<String>(
                  formControlName: 'cardType',
                  decoration: InputDecoration(labelText: 'Tipo de Cartão'),
                  items: const [
                    DropdownMenuItem(value: 'credito', child: Text('Crédito')),
                    DropdownMenuItem(value: 'debito', child: Text('Débito')),
                  ],
                  validationMessages: {
                    ValidationMessage.required: (_) => 'Selecione uma das opções.',
                  },
                ),
              ] else if (paymentMethod == pix) ...[
                Center(
                  child: QrImageView(
                    data: pixCode,
                    size: 200,
                  ),
                ),
              ] else if (paymentMethod == boleto) ...[
                Center(
                  child: BarcodeWidget(
                    data: boletoCode,
                    barcode: Barcode.code128(),
                    width: 200,
                    height: 80,
                  ),
                ),
              ],

              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (paymentMethod != card || form.valid) {
                      Navigator.pushNamed(
                        context,
                        '/form5',
                        arguments: {
                          'paymentMethod': paymentMethod,
                          'cardNumber': form.control('cardNumber').value,
                          'cardExpiry': form.control('cardExpiry').value,
                          'cardCVV': form.control('cardCVV').value,
                          'pixCode': pixCode,
                          'boletoCode': boletoCode,
                        },
                      );
                    } else {
                      form.markAllAsTouched();
                    }
                  },
                  child: Text('Confirmar Pagamento'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
