import 'package:automation_test_flutter/domain/entities/crypto_entity.dart';

class CryptoModel {
  final String name;
  final String symbol;
  final double currentPrice;
  final String image;

  CryptoModel({
    required this.name,
    required this.symbol,
    required this.currentPrice,
    required this.image,
  });

  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      currentPrice: (json['current_price'] as num).toDouble(),
      image: json['image'] as String,
    );
  }

  CryptoEntity toEntity() {
    return CryptoEntity(
      name: name,
      symbol: symbol,
      currentPrice: currentPrice,
      image: image,
    );
  }
}