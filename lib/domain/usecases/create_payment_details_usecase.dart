import 'package:reactive_forms/reactive_forms.dart';
import 'package:automation_test_flutter/domain/entities/payment_details.dart';
import 'package:automation_test_flutter/constants/constants.dart';

class CreatePaymentDetailsUseCase {
  FormGroup execute(String paymentMethod) {
    return FormGroup({
      'paymentMethod': FormControl<String>(value: paymentMethod),
      'cardType': FormControl<String>(validators: [Validators.required]),
      'cardNumber': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(16),
      ]),
      'cardExpiry': FormControl<DateTime>(validators: [Validators.required]),
      'cardCVV': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(3),
      ]),
    });
  }

  Map<String, String Function(Object)> validationMessages(String field) {
    switch (field) {
      case 'cardType':
        return {ValidationMessage.required: (_) => cardTypeRequired};
      case 'cardNumber':
        return {
          ValidationMessage.required: (_) => requiredField,
          ValidationMessage.minLength: (_) => cardNumberMinLength,
        };
      case 'cardExpiry':
        return {ValidationMessage.required: (_) => cardExpiryRequired};
      case 'cardCVV':
        return {
          ValidationMessage.required: (_) => requiredField,
          ValidationMessage.minLength: (_) => cardCVVMinLength,
        };
      default:
        return {};
    }
  }

  PaymentDetails toEntity(FormGroup form, {String? pixCode, String? boletoCode}) {
    return PaymentDetails(
      paymentMethod: form.control('paymentMethod').value ?? '',
      cardType: form.control('cardType').value,
      cardNumber: form.control('cardNumber').value,
      cardExpiry: form.control('cardExpiry').value,
      cardCVV: form.control('cardCVV').value,
      pixCode: pixCode,
      boletoCode: boletoCode,
    );
  }
}