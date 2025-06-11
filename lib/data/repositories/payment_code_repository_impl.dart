import 'dart:math';
import 'package:automation_test_flutter/domain/repositories/payment_code_repository.dart';

class PaymentCodeRepositoryImpl implements PaymentCodeRepository {
  @override
  Future<String> generateCode(String paymentMethod) async {
    await Future.delayed(const Duration(milliseconds: 500));
    switch (paymentMethod.toLowerCase()) {
      case 'pix':
        return generatePixCode();
      case 'boleto':
        return generateBoletoCode();
      case 'credit card':
        throw Exception('Credit Card does not use generated codes');
      default:
        throw Exception('Método de pagamento não suportado: $paymentMethod');
    }
  }

  String generatePixCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return List.generate(32, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  String generateBoletoCode() {
    return List.generate(48, (_) => Random().nextInt(10).toString()).join();
  }
}