import 'package:reactive_forms/reactive_forms.dart';
import 'package:automation_test_flutter/domain/entities/personal_info.dart';

class CreatePersonalInfoUseCase {
  FormGroup execute() {
    return FormGroup({
      'name': FormControl<String>(
        validators: [Validators.required],
      ),
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
      'phone': FormControl<String>(
        validators: [
          Validators.required,
        ],
      ),
    });
  }

  Map<String, String Function(Object)> validationMessages(String field) {
    switch (field) {
      case 'name':
        return {
          ValidationMessage.required: (error) => 'Nome é obrigatório',
        };
      case 'email':
        return {
          ValidationMessage.required: (error) => 'E-mail é obrigatório',
          ValidationMessage.email: (error) => 'Formato de e-mail inválido',
        };
      case 'phone':
        return {
          ValidationMessage.required: (error) => 'Telefone é obrigatório',
          'pattern': (error) => 'Formato de telefone inválido (ex: (11) 91234-5678)',
        };
      default:
        return {};
    }
  }

  PersonalInfoEntity toEntity(FormGroup form) {
    return PersonalInfoEntity(
      name: form.control('name').value as String,
      email: form.control('email').value as String,
      phone: form.control('phone').value as String,
    );
  }
}