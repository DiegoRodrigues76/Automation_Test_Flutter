// lib/data/datasources/address_datasource.dart
import 'package:automation_test_flutter/services/api_service.dart';

abstract class AddressDataSource {
  Future<List<String>> fetchCountries();
  Future<Map<String, dynamic>?> fetchAddress(String cep);
}

class AddressDataSourceImpl implements AddressDataSource {
  @override
  Future<List<String>> fetchCountries() async {
    return ApiService.fetchCountries();
  }

  @override
  Future<Map<String, dynamic>?> fetchAddress(String cep) async {
    return ApiService.fetchAddress(cep);
  }
}