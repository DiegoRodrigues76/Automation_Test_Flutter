import 'package:automation_test_flutter/domain/entities/payment_details.dart';
import 'package:automation_test_flutter/domain/entities/payment_info.dart';

class FormDataArguments {
  final Map<String, dynamic>? personalInfo;
  final Map<String, dynamic>? address;
  final PaymentInfo? paymentInfo;
  final PaymentDetails? paymentDetails;

  const FormDataArguments({
    this.personalInfo,
    this.address,
    this.paymentInfo,
    this.paymentDetails,
  });
}