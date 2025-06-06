import 'package:automation_test_flutter/data/datasources/crypto_remote_data_source.dart';
import 'package:automation_test_flutter/domain/entities/crypto_entity.dart';
import 'package:automation_test_flutter/domain/repositories/crypto_repository.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRemoteDataSource remoteDataSource;

  CryptoRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<CryptoEntity>> getCryptoList() async {
    try {
      final models = await remoteDataSource.fetchCryptoData();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }
}