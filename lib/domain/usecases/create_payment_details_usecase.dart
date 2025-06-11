import 'package:reactive_forms/reactive_forms.dart';
import 'package:automation_test_flutter/domain/entities/payment_details.dart';
import 'package:automation_test_flutter/constants/constants.dart';
import 'package:automation_test_flutter/services/logger_service.dart';

class CreatePaymentDetailsUseCase {
  FormGroup execute(String paymentMethod) {
    LoggerService.debug('Initializing form for paymentMethod: $paymentMethod');
    if (paymentMethod == card) {
      final form = FormGroup({
        'paymentMethod': FormControl<String>(value: paymentMethod),
        'cardType': FormControl<String>(validators: [Validators.required]),
        'cardNumber': FormControl<String>(validators: [
          Validators.required,
          Validators.minLength(16),
          Validators.maxLength(16),
          Validators.pattern(r'^\d{16}$'),
        ]),
        'cardExpiry': FormControl<DateTime>(validators: [Validators.required]),
        'cardCVV': FormControl<String>(validators: [
          Validators.required,
          Validators.minLength(3),
          Validators.maxLength(4),
          Validators.pattern(r'^\d{3,4}$'),
        ]),
      });
      LoggerService.debug('Card form initialized with controls: ${form.controls.keys}');
      return form;
    } else if (paymentMethod == pix || paymentMethod == boleto) {
      final form = FormGroup({
        'paymentMethod': FormControl<String>(value: paymentMethod),
        'code': FormControl<String>(validators: [Validators.required]),
      });
      LoggerService.debug('Non-card form initialized with controls: ${form.controls.keys}');
      return form;
    } else {
      LoggerService.error('Invalid payment method in execute: $paymentMethod');
      throw Exception('Invalid payment method: $paymentMethod');
    }
  }

  Map<String, Map<String, String Function(Object)>> validationMessages(String field) {
    switch (field) {
      case 'card':
        return {
          'cardType': {ValidationMessage.required: (_) => cardTypeRequired},
          'cardNumber': {
            ValidationMessage.required: (_) => requiredField,
            ValidationMessage.minLength: (_) => cardNumberMinLength,
            ValidationMessage.maxLength: (_) => cardNumberMaxLength,
            ValidationMessage.pattern: (_) => 'Número do cartão inválido (16 dígitos)',
          },
          'cardExpiry': {ValidationMessage.required: (_) => cardExpiryRequired},
          'cardCVV': {
            ValidationMessage.required: (_) => requiredField,
            ValidationMessage.minLength: (_) => cardCVVMinLength,
            ValidationMessage.maxLength: (_) => cardCVVMaxLength,
            ValidationMessage.pattern: (_) => 'CVV inválido (3 ou 4 dígitos)',
          },
        };
      case 'code':
        return {
          'code': {ValidationMessage.required: (_) => requiredField},
        };
      default:
        return {};
    }
  }

  PaymentDetails toEntity(FormGroup form, String paymentMethod) {
    LoggerService.debug('Converting form to PaymentDetails for paymentMethod: $paymentMethod');
    if (paymentMethod == card) {
      final details = PaymentDetails(
        paymentMethod: paymentMethod,
        cardType: form.control('cardType').value as String?,
        cardNumber: form.control('cardNumber').value as String?,
        cardExpiry: form.control('cardExpiry').value as DateTime?,
        cardCVV: form.control('cardCVV').value as String?,
        pixCode: null,
        boletoCode: null,
      );
      LoggerService.debug('Created PaymentDetails: ${details.toMap()}');
      return details;
    } else if (paymentMethod == pix || paymentMethod == boleto) {
      final code = form.control('code').value as String?;
      final details = PaymentDetails(
        paymentMethod: paymentMethod,
        cardType: null,
        cardNumber: null,
        cardExpiry: null,
        cardCVV: null,
        pixCode: paymentMethod == pix ? code : null,
        boletoCode: paymentMethod == boleto ? code : null,
      );
      LoggerService.debug('Created PaymentDetails: ${details.toMap()}');
      return details;
    }
    LoggerService.error('Invalid payment method in toEntity: $paymentMethod');
    throw Exception('Invalid payment method: $paymentMethod');
  }
}