import 'package:automation_test_flutter/domain/entities/crypto_entity.dart';
import 'package:automation_test_flutter/domain/repositories/crypto_repository.dart';

class FetchCryptoDataUseCase {
  final CryptoRepository repository;

  FetchCryptoDataUseCase(this.repository);

  Future<List<CryptoEntity>> execute() {
    return repository.getCryptoList();
  }
}