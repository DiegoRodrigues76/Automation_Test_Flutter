// lib/domain/usecases/create_address_usecase.dart
import 'package:reactive_forms/reactive_forms.dart';
import 'package:automation_test_flutter/domain/entities/address.dart';
import 'package:automation_test_flutter/constants/constants.dart';

class CreateAddressUseCase {
  FormGroup execute() {
    return FormGroup({
      'country': FormControl<String>(validators: [Validators.required]),
      'cep': FormControl<String>(validators: [
        Validators.required,
        Validators.pattern(r'^\d{5}-?\d{3}$'), // Supports 12345-678 or 12345678
      ]),
      'street': FormControl<String>(validators: [Validators.required]),
      'neighborhood': FormControl<String>(validators: [Validators.required]),
      'city': FormControl<String>(validators: [Validators.required]),
      'state': FormControl<String>(validators: [Validators.required]),
    });
  }

  Map<String, String Function(Object)> validationMessages() {
    return {
      ValidationMessage.required: (_) => requiredField,
      ValidationMessage.pattern: (_) => 'CEP inválido (use 12345-678 ou 12345678)',
    };
  }

  void updateAddress(FormGroup form, Address address) {
    form.control('street').value = address.street;
    form.control('neighborhood').value = address.neighborhood;
    form.control('city').value = address.city;
    form.control('state').value = address.state;
  }

  Address toEntity(FormGroup form) {
    return Address(
      country: form.control('country').value ?? '',
      cep: form.control('cep').value ?? '',
      street: form.control('street').value ?? '',
      neighborhood: form.control('neighborhood').value ?? '',
      city: form.control('city').value ?? '',
      state: form.control('state').value ?? '',
    );
  }
}