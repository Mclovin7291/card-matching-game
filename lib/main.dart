import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'models/card_model.dart';

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
                // Game stats
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceAround,
                    spacing: 20,
                    runSpacing: 10,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Matches',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${gameProvider.matches}/8',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Moves',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${gameProvider.moves}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (gameProvider.isGameComplete)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            '🎉 Congratulations! Game completed in ${gameProvider.moves} moves! 🎉',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            textAlign: TextAlign.center,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
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
                      return FlipCard(
                        card: card,
                        onTap: () => gameProvider.flipCard(index),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                // New game button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  onPressed: gameProvider.initGame,
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    'New Game',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class FlipCard extends StatefulWidget {
  final GameCard card;
  final VoidCallback onTap;

  const FlipCard({
    super.key,
    required this.card,
    required this.onTap,
  });

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFrontVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -pi / 2),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: pi / 2, end: 0.0),
        weight: 50,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.card.isFlipped != _isFrontVisible) {
      _isFrontVisible = widget.card.isFlipped;
      _controller.forward();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(_animation.value),
          alignment: Alignment.center,
          child: Card(
            elevation: 2,
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: widget.onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: widget.card.isMatched
                      ? Colors.green.shade100
                      : widget.card.isFlipped
                          ? Colors.white
                          : Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(4),
                  border: widget.card.isMatched
                      ? Border.all(color: Colors.green, width: 2)
                      : null,
                ),
                child: Center(
                  child: widget.card.isFlipped || widget.card.isMatched
                      ? Text(
                          widget.card.animal,
                          style: TextStyle(
                            fontSize: 32,
                            color: widget.card.isMatched
                                ? Colors.green
                                : Colors.black,
                          ),
                        )
                      : const Icon(Icons.question_mark, size: 32),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
