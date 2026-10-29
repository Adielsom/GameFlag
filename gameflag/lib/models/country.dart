/// Classe Modelo que representa a estrutura de um país no jogo.
class Country {
  final String name; // Nome original do país (em português)
  final String flagUrl; // URL da imagem da bandeira
  final String region; // Continente do país

  Country({required this.name, required this.flagUrl, required this.region});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'] ?? 'Desconhecido',
      flagUrl: json['flagUrl'] ?? json['flag'] ?? '',
      region: json['region'] ?? 'Desconhecido',
    );
  }

  /// Retorna o nome do país traduzido de acordo com o idioma selecionado ('pt', 'en', 'es')
  String getName(String langCode) {
    if (langCode == 'pt') return name;

    final cleanName = name.trim();
    final entry = _countryTranslations.entries.firstWhere(
      (e) => e.key.toLowerCase() == cleanName.toLowerCase(),
      orElse: () => MapEntry('', {}),
    );

    if (entry.value.containsKey(langCode)) {
      return entry.value[langCode]!;
    }

    return name; // Retorna o nome padrão caso não encontre tradução específica
  }

  // Dicionário de tradução dos nomes dos países
  static final Map<String, Map<String, String>> _countryTranslations = {
    // América
    'Brasil': {'en': 'Brazil', 'es': 'Brasil'},
    'Argentina': {'en': 'Argentina', 'es': 'Argentina'},
    'Estados Unidos': {'en': 'United States', 'es': 'Estados Unidos'},
    'Canadá': {'en': 'Canada', 'es': 'Canadá'},
    'México': {'en': 'Mexico', 'es': 'México'},
    'Colômbia': {'en': 'Colombia', 'es': 'Colombia'},
    'Chile': {'en': 'Chile', 'es': 'Chile'},
    'Uruguai': {'en': 'Uruguay', 'es': 'Uruguay'},
    'Paraguai': {'en': 'Paraguay', 'es': 'Paraguay'},
    'Peru': {'en': 'Peru', 'es': 'Perú'},
    'Bolívia': {'en': 'Bolivia', 'es': 'Bolivia'},
    'Equador': {'en': 'Ecuador', 'es': 'Ecuador'},
    'Venezuela': {'en': 'Venezuela', 'es': 'Venezuela'},
    'Cuba': {'en': 'Cuba', 'es': 'Cuba'},
    'Costa Rica': {'en': 'Costa Rica', 'es': 'Costa Rica'},
    'Panamá': {'en': 'Panama', 'es': 'Panamá'},
    'Jamaica': {'en': 'Jamaica', 'es': 'Jamaica'},
    'Haiti': {'en': 'Haiti', 'es': 'Haití'},
    'República Dominicana': {
      'en': 'Dominican Republic',
      'es': 'República Dominicana',
    },
    'Honduras': {'en': 'Honduras', 'es': 'Honduras'},
    'Guatemala': {'en': 'Guatemala', 'es': 'Guatemala'},

    // Europa
    'Alemanha': {'en': 'Germany', 'es': 'Alemania'},
    'França': {'en': 'France', 'es': 'Francia'},
    'Itália': {'en': 'Italy', 'es': 'Italia'},
    'Espanha': {'en': 'Spain', 'es': 'España'},
    'Portugal': {'en': 'Portugal', 'es': 'Portugal'},
    'Reino Unido': {'en': 'United Kingdom', 'es': 'Reino Unido'},
    'Holanda': {'en': 'Netherlands', 'es': 'Países Bajos'},
    'Suíça': {'en': 'Switzerland', 'es': 'Suiza'},
    'Bélgica': {'en': 'Belgium', 'es': 'Bélgica'},
    'Áustria': {'en': 'Austria', 'es': 'Austria'},
    'Grécia': {'en': 'Greece', 'es': 'Grecia'},
    'Suécia': {'en': 'Sweden', 'es': 'Suecia'},
    'Noruega': {'en': 'Norway', 'es': 'Noruega'},
    'Dinamarca': {'en': 'Denmark', 'es': 'Dinamarca'},
    'Finlândia': {'en': 'Finland', 'es': 'Finlandia'},
    'Polônia': {'en': 'Poland', 'es': 'Polonia'},
    'Rússia': {'en': 'Russia', 'es': 'Rusia'},
    'Ucrânia': {'en': 'Ukraine', 'es': 'Ucrania'},
    'Croácia': {'en': 'Croatia', 'es': 'Croacia'},
    'Irlanda': {'en': 'Ireland', 'es': 'Irlanda'},
    'República Tcheca': {'en': 'Czech Republic', 'es': 'República Checa'},
    'Hungria': {'en': 'Hungary', 'es': 'Hungría'},
    'Romênia': {'en': 'Romania', 'es': 'Rumanía'},

    // África
    'Angola': {'en': 'Angola', 'es': 'Angola'},
    'Moçambique': {'en': 'Mozambique', 'es': 'Mozambique'},
    'Egito': {'en': 'Egypt', 'es': 'Egipto'},
    'África do Sul': {'en': 'South Africa', 'es': 'Sudáfrica'},
    'Nigéria': {'en': 'Nigeria', 'es': 'Nigeria'},
    'Marrocos': {'en': 'Morocco', 'es': 'Marruecos'},
    'Gana': {'en': 'Ghana', 'es': 'Ghana'},
    'Quênia': {'en': 'Kenya', 'es': 'Kenia'},
    'Senegal': {'en': 'Senegal', 'es': 'Senegal'},
    'Camarões': {'en': 'Cameroon', 'es': 'Camerún'},
    'Costa do Marfim': {'en': 'Ivory Coast', 'es': 'Costa de Marfil'},
    'Argélia': {'en': 'Algeria', 'es': 'Argelia'},
    'Tunísia': {'en': 'Tunisia', 'es': 'Túnez'},
    'Etiópia': {'en': 'Ethiopia', 'es': 'Etiopía'},
    'Cabo Verde': {'en': 'Cape Verde', 'es': 'Cabo Verde'},
    'Madagascar': {'en': 'Madagascar', 'es': 'Madagascar'},

    // Ásia
    'Japão': {'en': 'Japan', 'es': 'Japón'},
    'China': {'en': 'China', 'es': 'China'},
    'Coreia do Sul': {'en': 'South Korea', 'es': 'Corea del Sur'},
    'Índia': {'en': 'India', 'es': 'India'},
    'Arábia Saudita': {'en': 'Saudi Arabia', 'es': 'Arabia Saudita'},
    'Emirados Árabes Unidos': {
      'en': 'United Arab Emirates',
      'es': 'Emiratos Árabes Unidos',
    },
    'Catar': {'en': 'Qatar', 'es': 'Catar'},
    'Tailândia': {'en': 'Thailand', 'es': 'Tailandia'},
    'Indonésia': {'en': 'Indonesia', 'es': 'Indonesia'},
    'Vietnã': {'en': 'Vietnam', 'es': 'Vietnam'},
    'Filipinas': {'en': 'Philippines', 'es': 'Filipinas'},
    'Turquia': {'en': 'Turkey', 'es': 'Turquía'},
    'Israel': {'en': 'Israel', 'es': 'Israel'},
    'Paquistão': {'en': 'Pakistan', 'es': 'Paquistán'},

    // Oceania
    'Austrália': {'en': 'Australia', 'es': 'Australia'},
    'Nova Zelândia': {'en': 'New Zealand', 'es': 'Nueva Zelanda'},
    'Fiji': {'en': 'Fiji', 'es': 'Fiyi'},
    'Papua Nova Guiné': {'en': 'Papua New Guinea', 'es': 'Papúa Nueva Guinea'},
    'Samoa': {'en': 'Samoa', 'es': 'Samoa'},
    'Tonga': {'en': 'Tonga', 'es': 'Tonga'},
    'Vanuatu': {'en': 'Vanuatu', 'es': 'Vanuatu'},
    'Ilhas Salomão': {'en': 'Solomon Islands', 'es': 'Islas Salomón'},
  };
}
