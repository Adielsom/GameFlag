/// Classe Modelo que representa a estrutura de um país no jogo.
class Country {
  final String name; // Nome do país
  final String flagUrl; // URL/caminho da imagem da bandeira
  final String region; // Continente ao qual o país pertence

  // Construtor padrão exigindo todas as propriedades
  Country({required this.name, required this.flagUrl, required this.region});

  /// Factory constructor para converter um objeto Map (vindo do JSON) em uma instância da classe Country.
  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] ?? 'Desconhecido',
      flagUrl: json['flagUrl'] ?? '',
      region: json['region'] ?? 'Desconhecido',
    );
  }
}
