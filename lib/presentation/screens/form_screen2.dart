import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:automation_test_flutter/domain/usecases/fetch_address_usecase.dart';
import 'package:automation_test_flutter/domain/usecases/create_address_usecase.dart';
import 'package:automation_test_flutter/presentation/components/button_component.dart';
import 'package:automation_test_flutter/widgets/form_fields.dart';
import 'package:automation_test_flutter/services/logger_service.dart';

class FormScreen2 extends StatefulWidget {
  final FetchAddressUseCase fetchAddressUseCase;
  final CreateAddressUseCase createAddressUseCase;

  const FormScreen2({
    super.key,
    required this.fetchAddressUseCase,
    required this.createAddressUseCase,
  });

  @override
  _FormScreen2State createState() => _FormScreen2State();
}

class _FormScreen2State extends State<FormScreen2> {
  final form = CreateAddressUseCase().execute();
  bool _shouldShowAddress = false;
  final _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 2')),
      body: Screenshot(
        controller: _screenshotController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ReactiveForm(
            formGroup: form,
            child: Column(
              children: [
                DropdownSearch<String>(
                  asyncItems: (_) => widget.fetchAddressUseCase.repository.fetchCountries(),
                  selectedItem: form.control('country').value,
                  onChanged: (value) => form.control('country').value = value,
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
                  onChanged: (_) => _handleCepChanged(),
                  validationMessages: widget.createAddressUseCase.validationMessages(),
                ),
                if (_shouldShowAddress) _buildAddressFields(),
                const SizedBox(height: 20),
                ZemaButtonComponent(
                  label: 'Próximo',
                  buttonName: 'proximo_form2',
                  action: () {
                    if (form.valid) {
                      final address = widget.createAddressUseCase.toEntity(form);
                      Navigator.pushNamed(context, '/form3', arguments: address);
                    } else {
                      form.markAllAsTouched();
                    }
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _captureAndShareScreenshot,
                  child: const Text('Capturar e Compartilhar Tela'),
                ),
              ],
            ),
          ),
        ),
      ),
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

  Future<void> _handleCepChanged() async {
    final cep = form.control('cep').value;
    if (cep == null || cep.replaceAll(RegExp(r'[^0-9]'), '').length != 8) {
      setState(() => _shouldShowAddress = false);
      return;
    }

    final address = await widget.fetchAddressUseCase.execute(cep);
    if (address != null) {
      widget.createAddressUseCase.updateAddress(form, address);
      setState(() => _shouldShowAddress = true);
    } else {
      setState(() => _shouldShowAddress = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('CEP inválido!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _captureAndShareScreenshot() async {
    try {
      final image = await _screenshotController.capture();
      if (image != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/form2_screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File(imagePath);
        await file.writeAsBytes(image);
        LoggerService.info('Screenshot temporária salva em: $imagePath');
        await Share.shareXFiles([XFile(imagePath)], text: 'Captura de tela do Formulário 2');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Screenshot pronta para compartilhamento')),
        );
      }
    } catch (e, stackTrace) {
      LoggerService.error('Erro ao capturar ou compartilhar screenshot', e, stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao capturar ou compartilhar screenshot')),
      );
    }
  }
}