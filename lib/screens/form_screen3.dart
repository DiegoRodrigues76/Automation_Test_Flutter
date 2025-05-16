import 'package:automation_test_flutter/modules/common/components/button_component.dart';
import 'package:automation_test_flutter/modules/common/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:automation_test_flutter/constants/constants.dart';

class FormScreen3 extends StatefulWidget {
  const FormScreen3({super.key});

  @override
  _FormScreen3State createState() => _FormScreen3State();
}

class _FormScreen3State extends State<FormScreen3> {
  late FormGroup form;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);

    form = FormGroup({
      'paymentMethod': FormControl<String>(validators: [Validators.required]),
      'deliveryDate': FormControl<DateTime>(validators: [Validators.required]),
      'receiveEmails': FormControl<bool>(value: false),
      'agreeToTerms': FormControl<bool>(value: false, validators: [Validators.requiredTrue]),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 3')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
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
                    validationMessages: {
                      ValidationMessage.required: (_) => requiredField,
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ReactiveFormField<DateTime, DateTime>(
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
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                          locale: const Locale('pt', 'BR'),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: ZemaColors.primary, // Cor do botão de seleção e do círculo
                                  onPrimary: Colors.white, // Cor do texto dentro do círculo
                                  onSurface: Colors.black, // Cor do texto normal
                                ),
                                dialogBackgroundColor: Theme.of(context).dialogBackgroundColor,
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                  ),
                                ),
                                textTheme: const TextTheme(
                                  titleLarge: TextStyle(color: Colors.white),
                                )
                              ),
                              child: child!,
                            );
                          }
                        );
                        if (selectedDate != null) {
                          field.didChange(selectedDate);
                        }
                      },
                    ),
                    if (field.control.invalid && field.control.touched)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Você precisa escolher uma data de envio.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReactiveCheckboxListTile(
                    formControlName: 'agreeToTerms',
                    title: const Text('Li e concordo com os termos e condições'),
                  ),
                  Builder(
                    builder: (context) {
                      final control = form.control('agreeToTerms');
                      if (control.invalid && control.touched) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Você precisa concordar com os termos e condições.',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ReactiveCheckboxListTile(
                formControlName: 'receiveEmails',
                title: const Text('Gostaria de receber propagandas por e-mail'),
              ),
              const SizedBox(height: 40),
              ZemaButtonComponent(
                label: 'Avançar para Pagamento',
                buttonName: 'proximo_form3',
                action: () {
                  if (form.valid) {
                    final paymentMethod = form.control('paymentMethod').value;
                    Navigator.pushNamed(
                      context,
                      '/form4',
                      arguments: {'paymentMethod': paymentMethod},
                    );
                  } else {
                    form.markAllAsTouched();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}