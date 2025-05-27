// lib/data/repositories/address_repository_impl.dart
import 'package:automation_test_flutter/data/datasources/address_datasource.dart';
import 'package:automation_test_flutter/data/models/address_model.dart';
import 'package:automation_test_flutter/domain/entities/address.dart';
import 'package:automation_test_flutter/domain/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressDataSource dataSource;

  AddressRepositoryImpl(this.dataSource);

  @override
  Future<List<String>> fetchCountries() async {
    return dataSource.fetchCountries();
  }

  @override
  Future<Address?> fetchAddress(String cep) async {
    final data = await dataSource.fetchAddress(cep);
    if (data == null) return null;
    return AddressModel.fromJson(data).toEntity();
  }
}