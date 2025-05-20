// lib/service/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const _viaCepBaseUrl = 'https://viacep.com.br/ws';
  static const _restCountriesUrl = 'https://restcountries.com/v3.1/all';

  // Busca o endereço a partir do CEP informado.
  static Future<Map<String, String>?> fetchAddress(String cep) async {
    try {
      final response = await http.get(Uri.parse('$_viaCepBaseUrl/$cep/json/'));

      if (response.statusCode != 200) return null;

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['erro'] == true) return null;

      return {
        'logradouro': responseBody['logradouro'] ?? '',
        'bairro': responseBody['bairro'] ?? '',
        'localidade': responseBody['localidade'] ?? '',
        'uf': responseBody['uf'] ?? '',
      };
    } catch (e) {
      // Log ou rethrow podem ser usados aqui conforme necessidade
      return null;
    }
  }

  // Busca e retorna uma lista de nomes de países (preferencialmente traduzidos para o português).
  static Future<List<String>> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse(_restCountriesUrl));

      if (response.statusCode != 200) {
        throw Exception('Falha ao carregar países');
      }

      final List<dynamic> countries = jsonDecode(response.body);
      final List<String> translatedCountries = countries.map<String>((country) {
        try {
          final translatedName = country['translations']['por']['common'];
          return translatedName is String ? translatedName : country['name']['common'];
        } catch (_) {
          return country['name']['common'] as String;
        }
      }).toList();

      translatedCountries.sort((a, b) => a.compareTo(b));
      return translatedCountries;
    } catch (e) {
      throw Exception('Erro ao buscar países: $e');
    }
  }
}