import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:automation_test_flutter/data/models/crypto_model.dart';

class CryptoRemoteDataSource {
  final http.Client client;

  CryptoRemoteDataSource(this.client);

  Future<List<CryptoModel>> fetchCryptoData() async {
    final response = await client.get(
      Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => CryptoModel.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar dados: ${response.statusCode}');
    }
  }
}