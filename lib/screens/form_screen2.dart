import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:automation_test_flutter/services/api_service.dart';
import 'package:automation_test_flutter/constants/constants.dart';
import 'package:automation_test_flutter/widgets/form_fields.dart';

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
        const SnackBar(content: Text('CEP inválido!'), backgroundColor: Colors.red),
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
      appBar: AppBar(title: const Text('Formulário 2')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReactiveForm(
          formGroup: form,
          child: Column(
            children: [
              DropdownSearch<String>(
                asyncItems: (String filter) => _fetchCountries(),
                selectedItem: form.control('country').value,
                onChanged: (value) {
                  form.control('country').value = value;
                },
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Nacionalidade',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomReactiveTextField(
                formControlName: 'cep',
                label: 'CEP',
                keyboardType: TextInputType.number,
                onChanged: (value) => _fetchAddress(),
                validationMessages: {
                  ValidationMessage.required: (_) => requiredField,
                },
              ),
              if (_isAddressFound) ...[
                const SizedBox(height: 16),
                CustomReactiveTextField(
                  formControlName: 'street',
                  label: 'Rua',
                  readOnly: true,
                ),
                CustomReactiveTextField(
                  formControlName: 'neighborhood',
                  label: 'Bairro',
                  readOnly: true,
                ),
                CustomReactiveTextField(
                  formControlName: 'city',
                  label: 'Cidade',
                  readOnly: true,
                ),
                CustomReactiveTextField(
                  formControlName: 'state',
                  label: 'Estado',
                  readOnly: true,
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (form.valid) {
                    Navigator.pushNamed(context, '/form3');
                  } else {
                    form.markAllAsTouched();
                  }
                },
                child: const Text('Próximo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}