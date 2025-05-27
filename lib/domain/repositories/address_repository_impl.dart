import 'package:automation_test_flutter/domain/entities/address.dart';
import 'package:automation_test_flutter/domain/repositories/address_repository.dart';
import 'package:automation_test_flutter/services/api_service.dart';

class AddressRepositoryImpl implements AddressRepository {
  @override
  Future<List<String>> fetchCountries() async {
    return ApiService.fetchCountries();
  }

  @override
  Future<Address?> fetchAddress(String cep) async {
    final data = await ApiService.fetchAddress(cep);
    if (data == null) return null;
    return Address(
      country: '',
      cep: cep,
      street: data['logradouro'] ?? '',
      neighborhood: data['bairro'] ?? '',
      city: data['localidade'] ?? '',
      state: data['uf'] ?? '',
    );
  }
}