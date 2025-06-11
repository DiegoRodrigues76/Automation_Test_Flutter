import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:automation_test_flutter/services/logger_service.dart';

abstract class AddressDataSource {
  Future<List<String>> fetchCountries();
  Future<Map<String, dynamic>?> fetchAddress(String cep);
}

class AddressDataSourceImpl implements AddressDataSource {
  final http.Client client;

  AddressDataSourceImpl(this.client);

  @override
  Future<List<String>> fetchCountries() async {
    try {
      final uri = Uri.parse('https://restcountries.com/v3.1/all?fields=name,translations');
      LoggerService.debug('Fetching countries from: $uri');
      final response = await client.get(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final countries = data.map<String>((item) {
          if (item.containsKey('translations') && 
              item['translations'].containsKey('por') && 
              item['translations']['por'].containsKey('common')) {
            return item['translations']['por']['common'] as String;
          }
          return item['name']['common'] as String; // Fallback para inglês
        }).toList()
          ..sort();
        LoggerService.debug('Fetched ${countries.length} countries');
        return countries;
      } else {
        LoggerService.error(
          'Failed to fetch countries: ${response.statusCode} - ${response.body}',
          Exception('HTTP ${response.statusCode}'),
        );
        if (response.statusCode == 400) {
          throw Exception('Invalid request to countries API: ${response.body}');
        }
        throw Exception('Failed to fetch countries: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      LoggerService.error('Error fetching countries from API: $e', stackTrace);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchAddress(String cep) async {
    try {
      final response = await client.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['erro'] == true) {
          LoggerService.debug('CEP not found: $cep');
          return null;
        }
        return data;
      } else {
        LoggerService.error(
          'Failed to fetch address: ${response.statusCode} - ${response.body}',
          Exception('HTTP ${response.statusCode}'),
        );
        throw Exception('Failed to fetch address: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      LoggerService.error('Error fetching address for CEP: $cep: $e', stackTrace);
      rethrow;
    }
  }
}