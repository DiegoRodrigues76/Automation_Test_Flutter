import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:automation_test_flutter/services/api_service.dart';

class FormScreen2 extends StatefulWidget {
  const FormScreen2({super.key});

  @override
  _FormScreen2State createState() => _FormScreen2State();
}

class _FormScreen2State extends State<FormScreen2> {
  final form = FormGroup({
    'country': FormControl<String>(validators: [Validators.required]),
    'cep': FormControl<String>(validators: [Validators.required], asyncValidatorsDebounceTime: 500),
    'street': FormControl<String>(validators: [Validators.required]),
    'neighborhood': FormControl<String>(validators: [Validators.required]),
    'city': FormControl<String>(validators: [Validators.required]),
    'state': FormControl<String>(validators: [Validators.required]),
  });

  bool _isAddressFound = false;

  Future<void> _fetchAddress() async {
    final cep = form.control('cep').value;
    if (cep == null || cep.isEmpty || cep.length < 8) {
      setState(() => _isAddressFound = false);
      return;
    }

    final address = await ApiService.fetchAddress(cep);
    if (address != null) {
      setState(() => _isAddressFound = true);
      form.control('street').value = address['logradouro'];
      form.control('neighborhood').value = address['bairro'];
      form.control('city').value = address['localidade'];
      form.control('state').value = address['uf'];
    } else {
      setState(() => _isAddressFound = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CEP inválido!'), backgroundColor: Colors.red),
      );
    }
  }

  Future<List<String>> _fetchCountries() async {
    final countries = await ApiService.fetchCountries();
    return countries;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulário 2')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              // Campo de seleção de País com DropdownSearch atualizado
              DropdownSearch<String>(
                asyncItems: (String filter) => _fetchCountries(),
                selectedItem: form.control('country').value,
                onChanged: (value) {
                  form.control('country').value = value;
                },
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Nacionalidade',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Campo CEP
              ReactiveTextField<String>(
                formControlName: 'cep',
                decoration: InputDecoration(labelText: 'CEP'),
                keyboardType: TextInputType.number,
                onChanged: (value) => _fetchAddress(),
                validationMessages: {
                  ValidationMessage.required: (_) => 'Por favor, insira o CEP.',
                },
              ),

              if (_isAddressFound) ...[
                SizedBox(height: 16),
                ReactiveTextField<String>(
                  formControlName: 'street',
                  decoration: InputDecoration(labelText: 'Rua'),
                  readOnly: true,
                ),
                ReactiveTextField<String>(
                  formControlName: 'neighborhood',
                  decoration: InputDecoration(labelText: 'Bairro'),
                  readOnly: true,
                ),
                ReactiveTextField<String>(
                  formControlName: 'city',
                  decoration: InputDecoration(labelText: 'Cidade'),
                  readOnly: true,
                ),
                ReactiveTextField<String>(
                  formControlName: 'state',
                  decoration: InputDecoration(labelText: 'Estado'),
                  readOnly: true,
                ),
              ],

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (form.valid) {
                    Navigator.pushNamed(context, '/form3');
                  } else {
                    form.markAllAsTouched();
                  }
                },
                child: Text('Próximo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
