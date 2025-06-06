import 'package:automation_test_flutter/data/datasources/address_datasource.dart';
import 'package:automation_test_flutter/domain/entities/address.dart';
import 'package:automation_test_flutter/domain/repositories/address_repository.dart';
import 'package:automation_test_flutter/services/logger_service.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressDataSource dataSource;

  AddressRepositoryImpl(this.dataSource);

  @override
  Future<List<String>> fetchCountries() async {
    try {
      final countries = await dataSource.fetchCountries();
      LoggerService.debug('Fetched countries: $countries');
      return countries;
    } catch (e, stackTrace) {
      LoggerService.error('Error fetching countries', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<AddressEntity?> fetchAddress(String cep) async {
    try {
      final data = await dataSource.fetchAddress(cep);
      if (data == null) {
        LoggerService.debug('No address found for CEP: $cep');
        return null;
      }
      final address = AddressEntity(
        country: '',
        cep: cep,
        street: data['logradouro'] ?? '',
        neighborhood: data['bairro'] ?? '',
        city: data['localidade'] ?? '',
        state: data['uf'] ?? '',
      );
      LoggerService.debug('Fetched address for CEP $cep: ${address.toMap()}');
      return address;
    } catch (e, stackTrace) {
      LoggerService.error('Error fetching address for CEP: $cep', e, stackTrace);
      rethrow;
    }
  }
}