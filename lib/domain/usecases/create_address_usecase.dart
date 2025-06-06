import 'package:automation_test_flutter/constants/constants.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:automation_test_flutter/domain/entities/address.dart';

class CreateAddressUseCase {
  FormGroup execute() {
    return FormGroup({
      'country': FormControl<String>(validators: [Validators.required]),
      'cep': FormControl<String>(
        validators: [Validators.required, Validators.pattern(r'^\d{8}$')],
      ),
      'street': FormControl<String>(validators: [Validators.required]),
      'neighborhood': FormControl<String>(validators: [Validators.required]),
      'city': FormControl<String>(validators: [Validators.required]),
      'state': FormControl<String>(validators: [Validators.required]),
    });
  }

  Map<String, String Function(Object)> validationMessages() {
    return {
      ValidationMessage.required: (error) => requiredField,
      ValidationMessage.pattern: (error) => 'CEP inválido. Use 8 dígitos sem hífen',
    };
  }

  void updateAddress(FormGroup form, AddressEntity address) {
    form.control('street').value = address.street;
    form.control('neighborhood').value = address.neighborhood;
    form.control('city').value = address.city;
    form.control('state').value = address.state;
  }

  AddressEntity toEntity(FormGroup form) {
    return AddressEntity(
      country: form.control('country').value as String,
      cep: form.control('cep').value as String? ?? '',
      street: form.control('street').value as String?,
      neighborhood: form.control('neighborhood').value as String?,
      city: form.control('city').value as String?,
      state: form.control('state').value as String?,
    );
  }
}