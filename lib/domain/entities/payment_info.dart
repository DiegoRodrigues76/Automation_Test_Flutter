class PaymentInfo {
  final String paymentMethod;
  final DateTime? deliveryDate;
  final bool termsAccepted;

  PaymentInfo({
    required this.paymentMethod,
    this.deliveryDate,
    required this.termsAccepted,
  });

  Map<String, dynamic> toMap() {
    return {
      'paymentMethod': paymentMethod,
      'deliveryDate': deliveryDate?.toIso8601String(),
      'termsAccepted': termsAccepted,
    };
  }
}