import 'package:reactive_forms/reactive_forms.dart';
import 'package:automation_test_flutter/domain/entities/payment_info.dart';
import 'package:automation_test_flutter/constants/constants.dart';

class CreatePaymentInfoUseCase {
  FormGroup execute() {
    return FormGroup({
      'paymentMethod': FormControl<String>(validators: [Validators.required]),
      'deliveryDate': FormControl<DateTime>(validators: [Validators.required]),
      'receiveEmails': FormControl<bool>(value: false),
      'agreeToTerms': FormControl<bool>(
        value: false,
        validators: [Validators.requiredTrue],
      ),
    });
  }

  Map<String, String Function(Object?)> validationMessages(String field) {
    switch (field) {
      case 'paymentMethod':
      case 'deliveryDate':
        return {
          ValidationMessage.required: (_) => requiredField,
        };
      case 'agreeToTerms':
        return {
          ValidationMessage.requiredTrue: (_) => 'Você precisa concordar com os termos.',
        };
      default:
        return {};
    }
  }

  PaymentInfo toEntity(FormGroup form) {
    return PaymentInfo(
      paymentMethod: form.control('paymentMethod').value as String? ?? '',
      deliveryDate: form.control('deliveryDate').value as DateTime?,
      termsAccepted: form.control('agreeToTerms').value as bool? ?? false,
    );
  }
}
//   PaymentInfo toEntity(FormGroup form) {
//     return PaymentInfo(
//       paymentMethod: form.control('paymentMethod').value ?? '',
//       deliveryDate: form.control('deliveryDate').value ?? DateTime.now(),
//       receiveEmails: form.control('receiveEmails').value ?? false,
//       agreeToTerms: form.control('agreeToTerms').value ?? false,
//     );
//   }
// }