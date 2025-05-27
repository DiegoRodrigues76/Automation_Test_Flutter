// lib/presentation/screens/form_screen3.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:automation_test_flutter/domain/usecases/create_payment_info_usecase.dart';
import 'package:automation_test_flutter/presentation/components/button_component.dart';
import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:automation_test_flutter/constants/constants.dart';

class FormScreen3 extends StatelessWidget {
  final CreatePaymentInfoUseCase useCase;

  const FormScreen3({super.key, required this.useCase});

  @override
  Widget build(BuildContext context) {
    final form = useCase.execute();

    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 3')),
      body: Padding(
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
                  validationMessages: useCase.validationMessages('paymentMethod'),
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
                        final paymentInfo = useCase.toEntity(form);
                        Navigator.pushNamed(context, '/form4', arguments: paymentInfo);
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
              ],
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
                useCase.validationMessages('deliveryDate')[ValidationMessage.required]!(null),
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
              useCase.validationMessages('agreeToTerms')[ValidationMessage.requiredTrue]!(null),
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}