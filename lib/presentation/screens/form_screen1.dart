import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'package:automation_test_flutter/domain/usecases/create_personal_info_usecase.dart';
import 'package:automation_test_flutter/presentation/components/button_component.dart';
import 'package:automation_test_flutter/widgets/form_fields.dart';
import 'package:automation_test_flutter/services/logger_service.dart';
import 'package:automation_test_flutter/presentation/routes/app_routes.dart';
import 'package:automation_test_flutter/presentation/routes/form_data_arguments.dart';

class FormScreen1 extends StatefulWidget {
  final CreatePersonalInfoUseCase useCase;

  const FormScreen1({super.key, required this.useCase});

  @override
  _FormScreen1State createState() => _FormScreen1State();
}

class _FormScreen1State extends State<FormScreen1> {
  final _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final form = widget.useCase.execute();

    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 1')),
      body: Screenshot(
        controller: _screenshotController,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ReactiveForm(
            formGroup: form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informações Pessoais',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                CustomReactiveTextField(
                  formControlName: 'name',
                  label: 'Nome',
                  validationMessages: widget.useCase.validationMessages('name'),
                  obscureText: false,
                  onChanged: (value) {
                    final nameControl = form.control('name');
                    if (nameControl.invalid && nameControl.touched) {
                      LoggerService.debug('Name validation errors: ${nameControl.errors}');
                    }
                  },
                ),
                const SizedBox(height: 16),
                CustomReactiveTextField(
                  formControlName: 'email',
                  label: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  validationMessages: widget.useCase.validationMessages('email'),
                  obscureText: false,
                  onChanged: (value) {
                    final emailControl = form.control('email');
                    if (emailControl.invalid && emailControl.touched) {
                      LoggerService.debug('Email validation errors: ${emailControl.errors}');
                    }
                  },
                ),
                const SizedBox(height: 16),
                CustomReactiveTextField(
                  formControlName: 'phone',
                  label: 'Telefone',
                  keyboardType: TextInputType.phone,
                  validationMessages: widget.useCase.validationMessages('phone'),
                  obscureText: true,
                  onChanged: (value) {
                    final phoneControl = form.control('phone');
                    if (phoneControl.invalid && phoneControl.touched) {
                      LoggerService.debug('Phone validation errors: ${phoneControl.errors}');
                    }
                  },
                ),
                const SizedBox(height: 26),
                Center(
                  child: ZemaButtonComponent(
                    label: 'Próximo',
                    buttonName: 'proximo_form1',
                    action: () {
                      if (form.valid) {
                        final personalInfo = widget.useCase.toEntity(form).toMap();
                        Navigator.pushNamed(
                          context,
                          AppRoutes.form2,
                          arguments: FormDataArguments(personalInfo: personalInfo),
                        );
                      } else {
                        form.markAllAsTouched();
                        LoggerService.debug('Form invalid: ${form.errors}');
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ZemaButtonComponent(
                    label: 'Capturar e Compartilhar Tela',
                    buttonName: 'capture_share_form1',
                    action: _captureAndShareScreenshot,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
            name: 'form1_screenshot_${DateTime.now().millisecondsSinceEpoch}.png',
            mimeType: 'image/png',
          ),
        ],
        text: 'Captura de tela do Formulário 1',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Screenshot pronta para compartilhamento')),
        );
      }
    } catch (e, stackTrace) {
      LoggerService.error('Erro ao capturar ou compartilhar screenshot: $e', e, stackTrace);
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