import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import 'game_screen.dart';

/// Tela Inicial (Menu Principal) onde o usuário escolhe idioma, continente e tempo de partida.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isPreparingGame = false;

  /// Método chamado ao clicar em "Iniciar Jogo". Pre-carrega imagens e navega para a GameScreen.
  Future<void> _onStartGame(GameProvider provider) async {
    setState(() {
      _isPreparingGame = true;
    });

    // Pré-carregamento na memória RAM
    await provider.precacheFlags(context);

    if (!mounted) return;

    final started = provider.startGame();
    setState(() {
      _isPreparingGame = false;
    });

    if (started) {
      // Navegação usando Navigator.push
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const GameScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Acesso ao GameProvider para obter o estado reativo da aplicação
    final provider = Provider.of<GameProvider>(context);

    final List<String> continents = [
      'Todos',
      'África',
      'América',
      'Ásia',
      'Europa',
      'Oceania',
    ];

    final Map<int, String> durations = {
      30: '30 ${provider.getText('sec')}',
      60: '60 ${provider.getText('sec')}',
      180: '3 ${provider.getText('min')}',
      300: '5 ${provider.getText('min')}',
    };

    final Map<String, String> languages = {
      'pt': '🇧🇷 Português',
      'en': '🇺🇸 English',
      'es': '🇪🇸 Español',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.getText('title')),
        centerTitle: true,
        elevation: 2,
      ),
      body: provider.isLoading || _isPreparingGame
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(provider.getText('loading')),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Exibição do Recorde Pessoal
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.emoji_events,
                              color: Colors.amber,
                              size: 36,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${provider.getText('high_score')}: ${provider.highScore} ${provider.getText('pts')}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Seleção de Idioma (Funcionalidade Extra)
                    Text(
                      provider.getText('lang_label'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: provider.selectedLanguage,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: languages.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) provider.setLanguage(value);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Seleção do Continente (Modo de Jogo)
                    Text(
                      provider.getText('mode_label'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: provider.selectedContinent,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: continents.map((continent) {
                        return DropdownMenuItem(
                          value: continent,
                          child: Text(
                            continent == 'Todos'
                                ? provider.getText('random_mode')
                                : continent,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) provider.setContinent(value);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Configuração de Tempo do Jogo
                    Text(
                      provider.getText('time_label'),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<int>(
                      initialValue: provider.selectedDuration,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: durations.entries.map((entry) {
                        return DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) provider.setDuration(value);
                      },
                    ),
                    const SizedBox(height: 32),

                    // Botão principal de Início da Partida
                    SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _onStartGame(provider),
                        child: Text(
                          provider.getText('start_btn'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
