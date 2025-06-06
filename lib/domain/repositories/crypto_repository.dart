import 'package:automation_test_flutter/domain/entities/crypto_entity.dart';

abstract class CryptoRepository {
  Future<List<CryptoEntity>> getCryptoList();
}