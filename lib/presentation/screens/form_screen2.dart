import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:automation_test_flutter/domain/usecases/fetch_address_usecase.dart';
import 'package:automation_test_flutter/domain/usecases/create_address_usecase.dart';
import 'package:automation_test_flutter/presentation/components/button_component.dart';
import 'package:automation_test_flutter/widgets/form_fields.dart';
import 'package:automation_test_flutter/services/logger_service.dart';
import 'package:automation_test_flutter/presentation/routes/app_routes.dart';
import 'package:automation_test_flutter/presentation/routes/form_data_arguments.dart';

class FormScreen2 extends StatefulWidget {
  final FetchAddressUseCase fetchAddressUseCase;
  final CreateAddressUseCase createAddressUseCase;
  final FormDataArguments? arguments;

  const FormScreen2({
    super.key,
    required this.fetchAddressUseCase,
    required this.createAddressUseCase,
    this.arguments,
  });

  @override
  _FormScreen2State createState() => _FormScreen2State();
}

class _FormScreen2State extends State<FormScreen2> {
  late final FormGroup form;
  bool _shouldShowAddress = false;
  final _screenshotController = ScreenshotController();
  List<String> _countries = [];
  bool _isLoadingCountries = true;
  String? _countryError;

  @override
  void initState() {
    super.initState();
    form = widget.createAddressUseCase.execute();
    _loadCountries();
    LoggerService.debug('FormScreen2 initialized with personalInfo: ${widget.arguments?.personalInfo ?? 'none'}');
  }

  Future<void> _loadCountries() async {
    setState(() => _isLoadingCountries = true);
    try {
      _countries = await widget.fetchAddressUseCase.repository.fetchCountries();
      LoggerService.debug('Loaded ${_countries.length} countries');
      setState(() => _countryError = null);
    } catch (e, stackTrace) {
      LoggerService.error('Failed to load countries: $e', stackTrace);
      setState(() {
        _countryError = 'Unable to load countries. Please select manually or retry.';
        _countries = ['Brazil', 'N/A'];
      });
    } finally {
      setState(() => _isLoadingCountries = false);
    }
  }

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
                if (_countryError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _countryError!,
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                        TextButton(
                          onPressed: _loadCountries,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                DropdownSearch<String>(
                  asyncItems: (_) async => _isLoadingCountries ? [] : _countries,
                  selectedItem: form.control('country').value as String?,
                  onChanged: (value) => form.control('country').value = value,
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: 'Nacionalidade',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    loadingBuilder: (_, __) => const Center(child: CircularProgressIndicator()),
                    errorBuilder: (_, __, ___) => const Center(child: Text('Error loading countries')),
                  ),
                ),
                const SizedBox(height: 16),
                CustomReactiveTextField(
                  formControlName: 'cep',
                  label: 'CEP',
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  onChanged: (value) {
                    _handleCepChanged();
                    final cepControl = form.control('cep');
                    if (cepControl.invalid && cepControl.touched) {
                      LoggerService.debug('CEP validation errors: ${cepControl.errors}');
                    }
                  },
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
                      Navigator.pushNamed(
                        context,
                        AppRoutes.form3,
                        arguments: FormDataArguments(
                          personalInfo: widget.arguments?.personalInfo,
                          address: address.toMap(),
                        ),
                      );
                    } else {
                      form.markAllAsTouched();
                      LoggerService.debug('Form invalid: ${form.errors}');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, preencha todos os campos corretamente.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                ZemaButtonComponent(
                  label: 'Capturar e Compartilhar Tela',
                  buttonName: 'capture_share_form2',
                  action: _captureAndShareScreenshot,
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
        obscureText: false,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }

  Future<void> _handleCepChanged() async {
    final cep = form.control('cep').value as String?;
    if (cep == null || cep.replaceAll(RegExp(r'[^0-9]'), '').length != 8) {
      setState(() => _shouldShowAddress = false);
      return;
    }

    try {
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
    } catch (e, stackTrace) {
      LoggerService.error('Error fetching address for CEP: $cep: $e', stackTrace);
      setState(() => _shouldShowAddress = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao buscar endereço: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _captureAndShareScreenshot() async {
    try {
      final image = await _screenshotController.capture();
      if (image == null) {
        throw Exception('Falha ao capturar a imagem');
      }

      await Share.shareXFiles(
        [
          XFile.fromData(
            image,
            name: 'form2_screenshot_${DateTime.now().millisecondsSinceEpoch}.png',
            mimeType: 'image/png',
          ),
        ],
        text: 'Captura de tela do Formulário 2',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Screenshot pronta para compartilhamento')),
        );
      }
    } catch (e, stackTrace) {
      LoggerService.error('Erro ao capturar ou compartilhar screenshot: $e', stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao capturar ou compartilhar screenshot: ${e.toString()}'),
          ),
        );
      }
    }
  }
}