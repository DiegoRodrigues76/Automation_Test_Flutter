import 'package:automation_test_flutter/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:automation_test_flutter/domain/entities/payment_info.dart';
import 'package:automation_test_flutter/domain/usecases/create_payment_details_usecase.dart';
import 'package:automation_test_flutter/domain/repositories/payment_code_repository.dart';
import 'package:automation_test_flutter/domain/strategies/payment_strategy.dart';
import 'package:automation_test_flutter/presentation/components/button_component.dart';

class FormScreen4 extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final form = useCase.execute(paymentInfo.paymentMethod);
    final paymentData = {
      'pixCode': codeRepository.generatePixCode(),
      'boletoCode': codeRepository.generateBoletoCode(),
    };
    final strategy = PaymentStrategyFactory.getStrategy(paymentInfo.paymentMethod);

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
                Text('Método de pagamento: ${paymentInfo.paymentMethod}'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context, FormGroup form, Map<String, dynamic> paymentData) {
    if (paymentInfo.paymentMethod != card || form.valid) {
      final paymentDetails = useCase.toEntity(form, pixCode: paymentData['pixCode'], boletoCode: paymentData['boletoCode']);
      Navigator.pushNamed(context, '/form5', arguments: paymentDetails);
    } else {
      form.markAllAsTouched();
    }
  }
}