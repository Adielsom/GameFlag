import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/country.dart';
import '../providers/game_provider.dart';
import 'result_screen.dart';

/// Tela do Jogo em tempo real com a bandeira, opções de resposta e o cronômetro.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Country?
  _selectedAnswer; // Guarda a opção clicada para controlar o feedback de cores
  bool _isAnswered =
      false; // Bloqueia novos cliques enquanto exibe o acerto/erro

  /// Lida com a seleção da resposta, exibindo feedback colorido antes da próxima pergunta
  void _handleOptionClick(GameProvider provider, Country selected) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswer = selected;
      _isAnswered = true;
    });

    provider.checkAnswer(selected);

    // Pequeno atraso (700ms) para que o jogador veja se acertou (verde) ou errou (vermelho)
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;

      if (provider.isGameOver) {
        // Redireciona para a ResultScreen se o tempo tiver acabado
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResultScreen()),
        );
      } else {
        setState(() {
          _isAnswered = false;
          _selectedAnswer = null;
        });
        provider.nextQuestion();
      }
    });
  }

  /// Retorna a cor do botão da opção: Verde (correta), Vermelho (erro) ou Padrão
  Color _getButtonColor(Country option, Country correct) {
    if (!_isAnswered) {
      return Theme.of(context).colorScheme.surfaceContainerHighest;
    }
    if (option.name == correct.name) {
      return Colors.green.shade400; // Opção correta sempre acende em verde
    }
    if (option.name == _selectedAnswer?.name) {
      return Colors.red.shade400; // Opção incorreta clicada acende em vermelho
    }
    return Theme.of(context).colorScheme.surfaceContainerHighest;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context);

    // Caso o timer zere no provider, redireciona automaticamente para a tela de resultado
    if (provider.isGameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ResultScreen()),
        );
      });
    }

    final currentCountry = provider.currentCountry;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${provider.getText('time_left')}: ${provider.remainingTime}s',
        ),
        centerTitle: true,
        automaticallyImplyLeading:
            false, // Oculta o botão voltar nativo durante a partida
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                '${provider.getText('pts')}: ${provider.score}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: currentCountry == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Barra visual do progresso do tempo restante
                  LinearProgressIndicator(
                    value: provider.remainingTime / provider.selectedDuration,
                    color: provider.remainingTime <= 5
                        ? Colors.red
                        : Colors.indigo,
                  ),
                  const SizedBox(height: 20),

                  // Container de Exibição da Bandeira do País
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          currentCountry.flagUrl,
                          fit: BoxFit.contain,
                          gaplessPlayback:
                              true, // Mantém a imagem visível até a próxima carregar sem piscar
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                                child: Icon(Icons.broken_image, size: 50),
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Mapeia e renderiza os 4 botões de opções de resposta
                  ...provider.options.map((option) {
                    final isCorrect = currentCountry.name == option.name;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getButtonColor(
                              option,
                              currentCountry,
                            ),
                            foregroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _handleOptionClick(provider, option),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  option.name,
                                  style: const TextStyle(fontSize: 16),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Ícone visual indicando o acerto ou erro
                              if (_isAnswered && isCorrect)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                              else if (_isAnswered &&
                                  _selectedAnswer?.name == option.name)
                                const Icon(Icons.cancel, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
