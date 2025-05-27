// lib/domain/usecases/fetch_address_usecase.dart
import 'package:automation_test_flutter/domain/entities/address.dart';
import 'package:automation_test_flutter/domain/repositories/address_repository.dart';

class FetchAddressUseCase {
  final AddressRepository repository;

  FetchAddressUseCase(this.repository);

  Future<Address?> execute(String cep) async {
    return repository.fetchAddress(cep);
  }
}