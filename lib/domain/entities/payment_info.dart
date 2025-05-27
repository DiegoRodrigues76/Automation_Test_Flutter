// lib/domain/entities/payment_info.dart
class PaymentInfo {
  final String paymentMethod;
  final DateTime deliveryDate;
  final bool receiveEmails;
  final bool agreeToTerms;

  PaymentInfo({
    required this.paymentMethod,
    required this.deliveryDate,
    required this.receiveEmails,
    required this.agreeToTerms,
  });
}