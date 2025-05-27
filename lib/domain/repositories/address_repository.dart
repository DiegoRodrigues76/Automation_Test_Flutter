// lib/domain/repositories/address_repository.dart
import 'package:automation_test_flutter/domain/entities/address.dart';

abstract class AddressRepository {
  Future<List<String>> fetchCountries();
  Future<Address?> fetchAddress(String cep);
}