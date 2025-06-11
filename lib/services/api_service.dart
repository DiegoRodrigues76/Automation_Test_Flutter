import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:automation_test_flutter/services/logger_service.dart';

class ApiService {
  static const _viaCepBaseUrl = 'https://viacep.com.br/ws';
  static const _restCountriesUrl = 'https://restcountries.com/v3.1/all?fields=name,translations';

  static Future<Map<String, String>?> fetchAddress(String cep) async {
    LoggerService.info('Buscando endereço para CEP: $cep');
    try {
      final response = await http.get(Uri.parse('$_viaCepBaseUrl/$cep/json/'));

      if (response.statusCode != 200) {
        LoggerService.error('Falha na requisição ViaCEP: Status ${response.statusCode}');
        return null;
      }

      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody.containsKey('erro') && responseBody['erro'] == true) {
        LoggerService.warning('CEP $cep inválido');
        return null;
      }

      // Verifica se os campos esperados estão presentes
      if (!responseBody.containsKey('logradouro') || 
          !responseBody.containsKey('bairro') || 
          !responseBody.containsKey('localidade') || 
          !responseBody.containsKey('uf')) {
        LoggerService.error('Resposta incompleta da API ViaCEP para CEP: $cep');
        return null;
      }

      LoggerService.debug('Endereço encontrado: ${responseBody['logradouro']}');
      return {
        'logradouro': responseBody['logradouro'] as String,
        'bairro': responseBody['bairro'] as String,
        'localidade': responseBody['localidade'] as String,
        'uf': responseBody['uf'] as String,
      };
    } catch (e, stackTrace) {
      LoggerService.error('Erro ao buscar endereço', e, stackTrace);
      return null;
    }
  }

  static Future<List<String>> fetchCountries() async {
    LoggerService.info('Buscando lista de países');
    try {
      final response = await http.get(Uri.parse(_restCountriesUrl));

      if (response.statusCode != 200) {
        LoggerService.error('Falha ao carregar países: Status ${response.statusCode}');
        throw Exception('Falha ao carregar países');
      }

      final List<dynamic> countries = jsonDecode(response.body);
      final List<String> translatedCountries = countries.map<String>((country) {
        try {
          // Verifica se a estrutura esperada está presente
          if (country.containsKey('translations') && 
              country['translations'].containsKey('por') && 
              country['translations']['por'].containsKey('common')) {
            return country['translations']['por']['common'] as String;
          } else {
            return country['name']['common'] as String;
          }
        } catch (_) {
          return country['name']['common'] as String;
        }
      }).toList();

      translatedCountries.sort((a, b) => a.compareTo(b));
      LoggerService.debug('Países carregados: ${translatedCountries.length}');
      return translatedCountries;
    } catch (e, stackTrace) {
      LoggerService.error('Erro ao buscar países', e, stackTrace);
      throw Exception('Erro ao buscar países: $e');
    }
  }
}