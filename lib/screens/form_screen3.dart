import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

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
    initializeDateFormatting('pt_BR', null); // Inicializa o locale

    form = FormGroup({
      'paymentMethod': FormControl<String>(
        validators: [Validators.required],
      ),
      'deliveryDate': FormControl<DateTime>(
        validators: [Validators.required],
      ),
      'receiveEmails': FormControl<bool>(value: false),
      'agreeToTerms': FormControl<bool>(
        value: false,
        validators: [Validators.requiredTrue],
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário 3'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Forma de Pagamento
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReactiveDropdownField<String>(
                    formControlName: 'paymentMethod',
                    decoration: const InputDecoration(
                      labelText: 'Forma de pagamento',
                    ),
                    items: const [
                      DropdownMenuItem(value: 'pix', child: Text('Pix')),
                      DropdownMenuItem(value: 'card', child: Text('Cartão de Crédito/Débito')),
                      DropdownMenuItem(value: 'boleto', child: Text('Boleto')),
                    ],
                    validationMessages: {
                      ValidationMessage.required: (_) => 'Por favor, escolha a forma de pagamento.',
                },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Data de Envio
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
                        );
                        if (selectedDate != null) {
                          field.didChange(selectedDate);
                        }
                      },
                    ),
                    // Mensagem de erro
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

              // Termos
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReactiveCheckboxListTile(
                    formControlName: 'agreeToTerms',
                    title: const Text('Li e concordo com os termos e condições'),
                  ),
                  // Mensagem de erro
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
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Receber e-mails
              ReactiveCheckboxListTile(
                formControlName: 'receiveEmails',
                title: const Text('Gostaria de receber propagandas por e-mail'),
              ),
              const SizedBox(height: 40),

              // Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Voltar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (form.valid) {
                        final paymentMethod = form.control('paymentMethod').value;
                        Navigator.pushNamed(
                          context,
                          '/form4',
                          arguments: {'paymentMethod': paymentMethod},
                        );
                      } else {
                        form.markAllAsTouched(); // Marca todos os campos como tocados para exibir os erros
                      }
                    },
                    child: const Text('Avançar para Pagamento'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
