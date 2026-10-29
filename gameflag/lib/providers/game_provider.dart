import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/country.dart';
import '../services/api_service.dart';

/// Gerenciador de Estado Principal do Jogo (usando a arquitetura Provider/ChangeNotifier).
/// Controla pontuação, tempo, filtro por continente, idiomas e persistência de dados.
class GameProvider extends ChangeNotifier {
  // Lista com todos os países carregados do JSON
  List<Country> _allCountries = [];

  // Lista de países filtrados e embaralhados para a partida atual
  List<Country> _gameCountries = [];

  Country? _currentCountry; // País da pergunta atual
  List<Country> _options = []; // As 4 opções de resposta para a pergunta

  int _score = 0; // Quantidade de acertos na partida
  int _totalQuestions = 0; // Total de perguntas exibidas
  int _selectedDuration =
      30; // Duração total configurada (30s, 60s, 180s, 300s)
  int _remainingTime = 30; // Contagem regressiva em tempo real
  Timer? _timer; // Objeto do cronômetro regressivo

  String _selectedContinent = 'Todos'; // Filtro de continente selecionado
  String _selectedLanguage =
      'pt'; // Idioma selecionado na interface ('pt', 'en', 'es')
  bool _isLoading = true; // Flag para indicador de carregamento inicial
  String? _errorMessage; // Mensagem de erro em caso de falhas
  bool _isGameOver = false; // Estado indicando se a partida encerrou
  int _highScore = 0; // Recorde salvo com SharedPreferences

  // Getters públicos para expor o estado do jogo para as telas sem permitir alteração direta
  List<Country> get allCountries => _allCountries;
  Country? get currentCountry => _currentCountry;
  List<Country> get options => _options;
  int get score => _score;
  int get totalQuestions => _totalQuestions;
  int get selectedDuration => _selectedDuration;
  int get remainingTime => _remainingTime;
  String get selectedContinent => _selectedContinent;
  String get selectedLanguage => _selectedLanguage;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isGameOver => _isGameOver;
  int get highScore => _highScore;

  /// Mapeamento das palavras da interface gráfica para suporte a 3 idiomas
  static final Map<String, Map<String, String>> _localizedTexts = {
    'pt': {
      'title': 'Flag Game',
      'high_score': 'Recorde',
      'pts': 'pontos',
      'mode_label': 'Modo de Jogo (Continente):',
      'random_mode': 'Jogo Aleatório (Mundo)',
      'time_label': 'Tempo Total de Jogo:',
      'lang_label': 'Idioma da Interface:',
      'start_btn': 'INICIAR JOGO',
      'time_left': 'Tempo',
      'final_results': 'Resultado Final',
      'game_over': 'Fim de Jogo!',
      'answered': 'Perguntas Respondidas:',
      'hits': 'Total de Acertos:',
      'accuracy': 'Aproveitamento (%):',
      'back_menu': 'VOLTAR AO MENU PRINCIPAL',
      'loading': 'Carregando bandeiras...',
      'sec': 'segundos',
      'min': 'minutos',
    },
    'en': {
      'title': 'Flag Game',
      'high_score': 'High Score',
      'pts': 'points',
      'mode_label': 'Game Mode (Continent):',
      'random_mode': 'Random Game (World)',
      'time_label': 'Total Game Time:',
      'lang_label': 'Interface Language:',
      'start_btn': 'START GAME',
      'time_left': 'Time',
      'final_results': 'Final Result',
      'game_over': 'Game Over!',
      'answered': 'Questions Answered:',
      'hits': 'Total Hits:',
      'accuracy': 'Accuracy (%):',
      'back_menu': 'BACK TO MAIN MENU',
      'loading': 'Loading flags...',
      'sec': 'seconds',
      'min': 'minutes',
    },
    'es': {
      'title': 'Flag Game',
      'high_score': 'Récord',
      'pts': 'puntos',
      'mode_label': 'Modo de Juego (Continente):',
      'random_mode': 'Juego Aleatorio (Mundo)',
      'time_label': 'Tiempo Total de Juego:',
      'lang_label': 'Idioma de la Interfaz:',
      'start_btn': 'COMENZAR JUEGO',
      'time_left': 'Tiempo',
      'final_results': 'Resultado Final',
      'game_over': '¡Juego Terminado!',
      'answered': 'Preguntas Respondidas:',
      'hits': 'Aciertos Totales:',
      'accuracy': 'Rendimiento (%):',
      'back_menu': 'VOLVER AL MENÚ PRINCIPAL',
      'loading': 'Cargando banderas...',
      'sec': 'segundos',
      'min': 'minutos',
    },
  };

  /// Retorna o texto traduzido conforme o idioma atualmente selecionado
  String getText(String key) {
    return _localizedTexts[_selectedLanguage]?[key] ?? key;
  }

  /// Altera o idioma da aplicação e atualiza a UI
  void setLanguage(String lang) {
    _selectedLanguage = lang;
    notifyListeners();
  }

  /// Carrega o banco de dados inicial e busca o recorde salvo localmente
  Future<void> loadInitialData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _allCountries = await ApiService.fetchCountries();
      await loadHighScore();
    } catch (e) {
      _errorMessage =
          'Não foi possível carregar as bandeiras. Tente novamente.';
      debugPrint('Erro ao carregar dados: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Baixa previamente as imagens das bandeiras para a memória RAM.
  /// Isso garante transição instantânea entre as perguntas sem gastar o tempo do jogador.
  Future<void> precacheFlags(BuildContext context) async {
    final targets = _gameCountries.take(25);
    for (var country in targets) {
      if (country.flagUrl.isNotEmpty) {
        try {
          await precacheImage(NetworkImage(country.flagUrl), context);
        } catch (_) {}
      }
    }
  }

  /// Atualiza o tempo configurado para a partida
  void setDuration(int seconds) {
    _selectedDuration = seconds;
    _remainingTime = seconds;
    notifyListeners();
  }

  /// Atualiza o continente selecionado
  void setContinent(String continent) {
    _selectedContinent = continent;
    notifyListeners();
  }

  /// Prepara as variáveis e inicia uma nova partida
  bool startGame() {
    if (_allCountries.isEmpty) return false;

    _score = 0;
    _totalQuestions = 0;
    _isGameOver = false;
    _remainingTime = _selectedDuration;

    final Map<String, String> continentMap = {
      'África': 'áfrica',
      'América': 'américa',
      'Ásia': 'ásia',
      'Europa': 'europa',
      'Oceania': 'oceania',
    };

    // Filtra os países por continente ou seleciona todos
    if (_selectedContinent == 'Todos' || _selectedContinent.isEmpty) {
      _gameCountries = List.from(_allCountries);
    } else {
      final target =
          continentMap[_selectedContinent] ?? _selectedContinent.toLowerCase();
      _gameCountries = _allCountries.where((country) {
        return country.region.toLowerCase().contains(target);
      }).toList();
    }

    if (_gameCountries.isEmpty) {
      _gameCountries = List.from(_allCountries);
    }

    _gameCountries.shuffle(); // Embaralha a lista para ordem aleatória
    _startTimer();
    nextQuestion();
    return true;
  }

  /// Inicializa o cronômetro regressivo de 1 em 1 segundo
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        endGame(); // Encerra o jogo quando o tempo zerar
      }
    });
  }

  /// Sorteia a próxima pergunta e 3 opções incorretas distintas
  void nextQuestion() {
    if (_gameCountries.isEmpty) {
      endGame();
      return;
    }

    _currentCountry = _gameCountries.removeLast();
    _totalQuestions++;

    // Busca 3 alternativas incorretas
    final List<Country> otherCountries = _allCountries
        .where((c) => c.name != _currentCountry!.name)
        .toList();
    otherCountries.shuffle();

    // Combina a resposta correta com as 3 incorretas e embaralha a exibição
    _options = [_currentCountry!, ...otherCountries.take(3)];
    _options.shuffle();

    notifyListeners();
  }

  /// Verifica se a opção clicada pelo jogador é a correta e soma a pontuação
  bool checkAnswer(Country selected) {
    final bool isCorrect = (selected.name == _currentCountry?.name);
    if (isCorrect) {
      _score++;
    }
    notifyListeners();
    return isCorrect;
  }

  /// Finaliza a partida e grava o novo recorde se a pontuação for superior
  void endGame() {
    _timer?.cancel();
    _isGameOver = true;
    _updateHighScore();
    notifyListeners();
  }

  /// Busca a pontuação máxima salva localmente usando o pacote shared_preferences
  Future<void> loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    _highScore = prefs.getInt('high_score') ?? 0;
    notifyListeners();
  }

  /// Salva o novo recorde no armazenamento interno do aparelho
  Future<void> _updateHighScore() async {
    if (_score > _highScore) {
      _highScore = _score;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('high_score', _highScore);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
