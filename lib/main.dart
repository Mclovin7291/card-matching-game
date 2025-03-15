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
        title: const Text('Animal Cards'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Tap to Flip Cards',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // Card grid
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: gameProvider.cards.length,
                    itemBuilder: (context, index) {
                      final card = gameProvider.cards[index];
                      return Card(
                        elevation: 4,
                        child: InkWell(
                          onTap: () => gameProvider.flipCard(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: card.isFlipped ? Colors.white : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: card.isFlipped
                                  ? Text(
                                      card.animal,
                                      style: const TextStyle(fontSize: 40),
                                    )
                                  : const Icon(Icons.question_mark, size: 40),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                // Shuffle button
                ElevatedButton.icon(
                  onPressed: gameProvider.initGame,
                  icon: const Icon(Icons.shuffle),
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
