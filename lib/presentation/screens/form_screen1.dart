import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:automation_test_flutter/domain/usecases/create_personal_info_usecase.dart';
import 'package:automation_test_flutter/presentation/components/button_component.dart';
import 'package:automation_test_flutter/widgets/form_fields.dart';

class FormScreen1 extends StatelessWidget {
  final CreatePersonalInfoUseCase useCase;

  const FormScreen1({super.key, required this.useCase});

  @override
  Widget build(BuildContext context) {
    final form = useCase.execute();

    return Scaffold(
      appBar: AppBar(title: const Text('Formulário 1')),
      body: SingleChildScrollView(
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
                validationMessages: useCase.validationMessages('name'),
              ),
              const SizedBox(height: 16),
              CustomReactiveTextField(
                formControlName: 'email',
                label: 'E-mail',
                keyboardType: TextInputType.emailAddress,
                validationMessages: useCase.validationMessages('email'),
              ),
              const SizedBox(height: 16),
              CustomReactiveTextField(
                formControlName: 'phone',
                label: 'Telefone',
                keyboardType: TextInputType.phone,
                validationMessages: useCase.validationMessages('phone'),
              ),
              const SizedBox(height: 32),
              Center(
                child: ZemaButtonComponent(
                  label: 'Próximo',
                  buttonName: 'proximo_form1',
                  action: () {
                    if (form.valid) {
                      final personalInfo = useCase.toEntity(form);
                      Navigator.pushNamed(context, '/form2', arguments: personalInfo);
                    } else {
                      form.markAllAsTouched();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}