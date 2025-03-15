import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Matching Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animal Memory Game'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Game progress
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Matches: ${gameProvider.matches}/8',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (gameProvider.isGameComplete)
                      const Text(
                        '🎉 You Won! 🎉',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                // Card grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 1,
                    ),
                    itemCount: gameProvider.cards.length,
                    itemBuilder: (context, index) {
                      final card = gameProvider.cards[index];
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.zero,
                        child: InkWell(
                          onTap: () => gameProvider.flipCard(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: card.isMatched
                                  ? Colors.green.shade100
                                  : card.isFlipped
                                      ? Colors.white
                                      : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(4),
                              border: card.isMatched
                                  ? Border.all(color: Colors.green, width: 2)
                                  : null,
                            ),
                            child: Center(
                              child: card.isFlipped || card.isMatched
                                  ? Text(
                                      card.animal,
                                      style: TextStyle(
                                        fontSize: 32,
                                        color: card.isMatched
                                            ? Colors.green
                                            : Colors.black,
                                      ),
                                    )
                                  : const Icon(Icons.question_mark, size: 32),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // New game button
                ElevatedButton.icon(
                  onPressed: gameProvider.initGame,
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Game'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
