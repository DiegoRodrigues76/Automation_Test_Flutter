import 'package:automation_test_flutter/presentation/components/button_component.dart';
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
    'cep': FormControl<String>(validators: [Validators.required]),
    'street': FormControl<String>(validators: [Validators.required]),
    'neighborhood': FormControl<String>(validators: [Validators.required]),
    'city': FormControl<String>(validators: [Validators.required]),
    'state': FormControl<String>(validators: [Validators.required]),
  });

  bool _shouldShowAddress = false;

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
              _buildCountryDropdown(),
              const SizedBox(height: 16),
              _buildCepField(),
              if (_shouldShowAddress) _buildAddressFields(),
              const SizedBox(height: 20),
              _buildNextButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return DropdownSearch<String>(
      asyncItems: (_) => ApiService.fetchCountries(),
      selectedItem: form.control('country').value,
      onChanged: (value) => form.control('country').value = value,
      dropdownDecoratorProps: const DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: 'Nacionalidade',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCepField() {
    return CustomReactiveTextField(
      formControlName: 'cep',
      label: 'CEP',
      keyboardType: TextInputType.number,
      onChanged: (_) => _handleCepChanged(),
      validationMessages: {
        ValidationMessage.required: (_) => requiredField,
      },
    );
  }

  Widget _buildAddressFields() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildReadOnlyField('street', 'Rua'),
        _buildReadOnlyField('neighborhood', 'Bairro'),
        _buildReadOnlyField('city', 'Cidade'),
        _buildReadOnlyField('state', 'Estado'),
      ],
    );
  }

  Widget _buildReadOnlyField(String name, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: CustomReactiveTextField(
        formControlName: name,
        label: label,
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return ZemaButtonComponent(
      label: 'Próximo',
      buttonName: 'proximo_form2',
      action: () {
        if (form.valid) {
          Navigator.pushNamed(context, '/form3');
        } else {
          form.markAllAsTouched();
        }
      },
    );
  }

  Future<void> _handleCepChanged() async {
    final cep = form.control('cep').value;
    if (cep == null || cep.length < 8) {
      setState(() => _shouldShowAddress = false);
      return;
    }

    final address = await ApiService.fetchAddress(cep);
    if (address != null) {
      form.control('street').value = address['logradouro'];
      form.control('neighborhood').value = address['bairro'];
      form.control('city').value = address['localidade'];
      form.control('state').value = address['uf'];
      setState(() => _shouldShowAddress = true);
    } else {
      setState(() => _shouldShowAddress = false);
      _showInvalidCepSnackBar();
    }
  }

  void _showInvalidCepSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('CEP inválido!'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
