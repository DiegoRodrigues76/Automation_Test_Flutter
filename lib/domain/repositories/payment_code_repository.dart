abstract class PaymentCodeRepository {
  Future<String> generateCode(String paymentMethod);
}