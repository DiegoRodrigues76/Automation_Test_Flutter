// lib/data/models/address_model.dart
import 'package:automation_test_flutter/domain/entities/address.dart';

class AddressModel {
  final String cep;
  final String logradouro;
  final String bairro;
  final String localidade;
  final String uf;

  AddressModel({
    required this.cep,
    required this.logradouro,
    required this.bairro,
    required this.localidade,
    required this.uf,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      cep: json['cep'] ?? '',
      logradouro: json['logradouro'] ?? '',
      bairro: json['bairro'] ?? '',
      localidade: json['localidade'] ?? '',
      uf: json['uf'] ?? '',
    );
  }

  AddressEntity toEntity() {
    return AddressEntity(
      country: 'Brasil', // Fixed since ViaCEP is Brazil-specific
      cep: cep,
      street: logradouro,
      neighborhood: bairro,
      city: localidade,
      state: uf,
    );
  }
}