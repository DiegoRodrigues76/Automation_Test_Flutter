import 'dart:math';
import 'package:automation_test_flutter/domain/repositories/payment_code_repository.dart';

class PaymentCodeRepositoryImpl implements PaymentCodeRepository {
  @override
  Future<String> generateCode(String paymentMethod) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final random = Random();
    final code = List.generate(10, (_) => random.nextInt(10)).join();
    switch (paymentMethod.toLowerCase()) {
      case 'pix':
        return 'PIX-$code';
      case 'boleto':
        return 'BOL-$code';
      case 'credit card':
        return 'CC-$code';
      default:
        throw Exception('Método de pagamento não suportado: $paymentMethod');
    }
  }
}