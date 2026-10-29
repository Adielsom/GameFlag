# Flag Game - Aplicativo Flutter

O **Flag Game** é um jogo interativo desenvolvido em Flutter para testar os conhecimentos dos jogadores sobre as bandeiras dos países de todo o mundo. O projeto permite partidas personalizadas por continentes ou de modo aleatório global, com tempos de resposta customizáveis.

---

## Funcionalidades

* **Jogo por Continente:** Seleção de bandeiras da África, América, Ásia, Europa ou Oceania.
* **Jogo Aleatório:** Sorteio com países de todo o mundo.
* **Cronômetro Ajustável:** Opções de tempo total de jogo em 30s, 60s, 3 min ou 5 min.
* **Recorde Pessoal (Leaderboard):** Armazenamento local da maior pontuação atingida.
* **Suporte Multi-idioma:** Interface disponível em Português (🇧🇷), Inglês (🇺🇸) e Espanhol (🇪🇸).
* **Feedback Visual:** Indicação imediata de acerto (verde) ou erro (vermelho).
* **Tela de Estatísticas:** Resumo com perguntas respondidas, acertos e taxa de aproveitamento (%).

---

## Tecnologias e Recursos Utilizados

* **Flutter & Dart:** Framework de interface e linguagem oficial.
* **Provider:** Gerenciamento de estado reativo e controle do timer.
* **Shared Preferences:** Armazenamento local persistente para o recorde.
* **JSON Local & Asset Precaching:** Carregamento instantâneo das bandeiras com pré-carregamento em memória.
* **Material Design 3:** Componentes visuais modernos e responsivos.

---

## Estrutura do Projeto

```text
lib/
├── models/
│   └── country.dart          # Modelo de dados do país
├── services/
│   └── api_service.dart      # Leitura e parse do arquivo JSON local
├── providers/
│   └── game_provider.dart    # Gerenciador de estado, tempo, idiomas e pontuação
├── screens/
│   ├── home_screen.dart      # Menu principal e configurações
│   ├── game_screen.dart      # Interface da partida em tempo real
│   └── result_screen.dart    # Tela de encerramento com estatísticas
└── main.dart                 # Ponto de entrada e configuração do Provider
```

Como Executar o Projeto
Pré-requisitos: Ter o SDK do Flutter instalado e configurado na máquina.

Clonar o repositório: git clone git clone https://github.com/Adielsom/GameFlag.git)
----
cd gameflag
---
Instalar as dependências: flutter pub get
---

LINK PARA VIDEO NO YOUTUBE, JOGANDO GAME FLAG: https://www.youtube.com/watch?v=PNPTMijePhA
