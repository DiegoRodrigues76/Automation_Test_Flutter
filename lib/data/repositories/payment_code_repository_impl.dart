// lib/data/repositories/payment_code_repository_impl.dart
import 'dart:math';
import 'package:automation_test_flutter/domain/repositories/payment_code_repository.dart';

class PaymentCodeRepositoryImpl implements PaymentCodeRepository {
  @override
  String generatePixCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    return List.generate(32, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  @override
  String generateBoletoCode() {
    return List.generate(48, (_) => Random().nextInt(10).toString()).join();
  }
}