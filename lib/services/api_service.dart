// lib/service/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Método para buscar o endereço a partir do CEP
  static Future<Map<String, String>?> fetchAddress(String cep) async {
    final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['erro'] == null) {
        return {
          'logradouro': data['logradouro'],
          'bairro': data['bairro'],
          'localidade': data['localidade'],
          'uf': data['uf'],
        };
      }
    }
    return null;
  }

  // Método para buscar a lista de países
  static Future<List<String>> fetchCountries() async {
    final response = await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

    if (response.statusCode == 200) {
      final List countries = jsonDecode(response.body);

      // Pega o nome traduzido para português, se disponível, senão o nome comum
      final List<String> translatedCountries = countries.map<String>((country) {
        try {
          return country['translations']['por']['common'] as String;
        } catch (_) {
          return country['name']['common'] as String;
        }
      }).toList();

      translatedCountries.sort((a, b) => a.compareTo(b));
      return translatedCountries;
    } else {
      throw Exception('Falha ao carregar países');
    }
  }
}

//       return countries.map((country) => country['name']['common'] as String).toList()..sort();
//     } else {
//       throw Exception('Falha ao carregar países');
//     }
//   }
// }