// lib/domain/entities/address.dart
class Address {
  final String country;
  final String cep;
  final String street;
  final String neighborhood;
  final String city;
  final String state;

  Address({
    required this.country,
    required this.cep,
    required this.street,
    required this.neighborhood,
    required this.city,
    required this.state,
  });
}