import 'package:reactive_forms/reactive_forms.dart';
import 'package:automation_test_flutter/domain/entities/payment_details.dart';
import 'package:automation_test_flutter/constants/constants.dart';

class CreatePaymentDetailsUseCase {
  FormGroup execute(String paymentMethod) {
    if (paymentMethod.toLowerCase() == 'credit card') {
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
    } else {
      return FormGroup({
        'paymentMethod': FormControl<String>(value: paymentMethod),
        'code': FormControl<String>(validators: [Validators.required]),
      });
    }
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
      case 'code':
        return {ValidationMessage.required: (_) => requiredField};
      default:
        return {};
    }
  }

  PaymentDetails toEntity(FormGroup form, String paymentMethod) {
    return PaymentDetails(
      paymentMethod: paymentMethod,
      cardType: form.control('cardType').value as String?,
      cardNumber: form.control('cardNumber').value as String? ?? form.control('code').value as String?,
      cardExpiry: form.control('cardExpiry').value as DateTime?,
      cardCVV: form.control('cardCVV').value as String?,
      pixCode: paymentMethod.toLowerCase() == 'pix' ? form.control('code').value as String? : null,
      boletoCode: paymentMethod.toLowerCase() == 'boleto' ? form.control('code').value as String? : null,
    );
  }
}