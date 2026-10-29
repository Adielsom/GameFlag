import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/home_screen.dart';

/// Ponto de entrada principal do aplicativo Flutter.
void main() {
  // Assegura a inicialização dos bindings do Flutter antes de executar a aplicação
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    // Injeção de dependência do GameProvider no topo da árvore de Widgets
    ChangeNotifierProvider(
      create: (_) => GameProvider()..loadInitialData(),
      child: const FlagGameApp(),
    ),
  );
}

/// Widget raiz da aplicação
class FlagGameApp extends StatelessWidget {
  const FlagGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flag Game',
      debugShowCheckedModeBanner: false, // Oculta a faixa de Debug no canto
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true, // Ativa o design Material 3
      ),
      home: const HomeScreen(), // Define a HomeScreen como tela inicial
    );
  }
}
