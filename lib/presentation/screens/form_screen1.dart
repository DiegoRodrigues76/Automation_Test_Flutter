import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:automation_test_flutter/domain/usecases/create_personal_info_usecase.dart';
import 'package:automation_test_flutter/presentation/components/button_component.dart';
import 'package:automation_test_flutter/widgets/form_fields.dart';
import 'package:automation_test_flutter/services/logger_service.dart';

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
                ),
                const SizedBox(height: 16),
                CustomReactiveTextField(
                  formControlName: 'email',
                  label: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  validationMessages: widget.useCase.validationMessages('email'),
                ),
                const SizedBox(height: 16),
                CustomReactiveTextField(
                  formControlName: 'phone',
                  label: 'Telefone',
                  keyboardType: TextInputType.phone,
                  validationMessages: widget.useCase.validationMessages('phone'),
                ),
                const SizedBox(height: 32),
                Center(
                  child: ZemaButtonComponent(
                    label: 'Próximo',
                    buttonName: 'proximo_form1',
                    action: () {
                      if (form.valid) {
                        final personalInfo = widget.useCase.toEntity(form);
                        Navigator.pushNamed(context, '/form2', arguments: personalInfo);
                      } else {
                        form.markAllAsTouched();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _captureAndShareScreenshot,
                    child: const Text('Capturar e Compartilhar Tela'),
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
      if (image != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/form1_screenshot_${DateTime.now().millisecondsSinceEpoch}.png';
        final file = File(imagePath);
        await file.writeAsBytes(image);
        LoggerService.info('Screenshot temporária salva em: $imagePath');
        await Share.shareXFiles([XFile(imagePath)], text: 'Captura de tela do Formulário 1');
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