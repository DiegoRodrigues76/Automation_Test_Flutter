class AddressEntity {
  final String country;
  final String cep;
  final String? street;
  final String? neighborhood;
  final String? city;
  final String? state;

  AddressEntity({
    required this.country,
    required this.cep,
    this.street,
    this.neighborhood,
    this.city,
    this.state,
  });

  Map<String, dynamic> toMap() {
    return {
      'country': country,
      'cep': cep,
      'street': street,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
    };
  }
}