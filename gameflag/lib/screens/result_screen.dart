import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

/// Tela de Encerramento contendo o resumo de desempenho do jogador ao fim do tempo.
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GameProvider>(context, listen: false);

    // Cálculo das estatísticas da partida
    final total = provider.totalQuestions;
    final score = provider.score;
    final percentage = total > 0
        ? ((score / total) * 100).toStringAsFixed(1)
        : '0.0';

    return Scaffold(
      appBar: AppBar(
        title: Text(provider.getText('final_results')),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.assessment, size: 80, color: Colors.indigo),
            const SizedBox(height: 20),
            Text(
              provider.getText('game_over'),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Card exibindo estatísticas detalhadas
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildStatRow(provider.getText('answered'), '$total'),
                    const Divider(),
                    _buildStatRow(provider.getText('hits'), '$score'),
                    const Divider(),
                    _buildStatRow(provider.getText('accuracy'), '$percentage%'),
                  ],
                ),
              ),
            ),
            const Spacer(),

            // Botão para retornar ao menu principal
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Retorna à primeira rota (HomeScreen) da pilha do Navigator
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text(
                provider.getText('back_menu'),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper widget para criar cada linha formatada do cartão de estatísticas
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
