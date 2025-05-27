import 'package:reactive_forms/reactive_forms.dart';
import 'package:automation_test_flutter/domain/entities/personal_info.dart';
import 'package:automation_test_flutter/constants/constants.dart';

class CreatePersonalInfoUseCase {
  FormGroup execute() {
    return FormGroup({
      'name': FormControl<String>(
        validators: [Validators.required],
        asyncValidatorsDebounceTime: 500,
      ),
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
        asyncValidatorsDebounceTime: 500,
      ),
      'phone': FormControl<String>(
        validators: [Validators.required],
        asyncValidatorsDebounceTime: 500,
      ),
    });
  }

  Map<String, String Function(Object)> validationMessages(String field) {
    switch (field) {
      case 'name':
      case 'phone':
        return {ValidationMessage.required: (_) => requiredField};
      case 'email':
        return {
          ValidationMessage.required: (_) => requiredField,
          ValidationMessage.email: (_) => invalidEmail,
        };
      default:
        return {};
    }
  }

  PersonalInfo toEntity(FormGroup form) {
    return PersonalInfo(
      name: form.control('name').value ?? '',
      email: form.control('email').value ?? '',
      phone: form.control('phone').value ?? '',
    );
  }
}