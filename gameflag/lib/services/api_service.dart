import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/country.dart';

/// Classe de serviço responsável pelo carregamento de dados externos/locais.
class ApiService {
  /// Lê o arquivo JSON local contendo as informações das bandeiras.
  /// Retorna uma lista de objetos do tipo [Country].
  static Future<List<Country>> fetchCountries() async {
    try {
      // Carrega o conteúdo do arquivo assets/data/countries.json como String
      final String response = await rootBundle.loadString(
        'assets/data/countries.json',
      );

      // Decodifica a String em uma estrutura de lista dinâmica em memória
      final List<dynamic> data = json.decode(response);

      // Mapeia cada elemento do JSON criando uma lista de objetos Country
      return data.map((json) => Country.fromJson(json)).toList();
    } catch (e) {
      // Lança exceção com mensagem clara caso haja falha na leitura do arquivo
      throw Exception('Erro ao carregar o banco de dados de bandeiras: $e');
    }
  }
}
