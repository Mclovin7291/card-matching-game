import 'dart:math';
import 'package:flutter/material.dart';
import '../models/card_model.dart';

class GameProvider extends ChangeNotifier {
  List<GameCard> cards = [];

  // List of animal emojis for cards
  final List<String> animals = [
    '🐶', '🐱', '🐭', '🐹',
    '🐰', '🦊', '🐻', '🐼',
    '🦁', '🐯', '🐮', '🐷',
    '🐸', '🐙', '🦋', '🦒',
  ];

  GameProvider() {
    initGame();
  }

  void initGame() {
    // Shuffle the animals list
    final shuffledAnimals = [...animals];
    shuffledAnimals.shuffle(Random());
    
    // Create cards with shuffled animals
    cards = List.generate(
      16, // 4x4 grid
      (index) => GameCard(
        id: index,
        animal: shuffledAnimals[index],
      ),
    );
    
    notifyListeners();
  }
} 