import 'dart:math';
import 'package:flutter/material.dart';
import '../models/card_model.dart';

class GameProvider extends ChangeNotifier {
  List<GameCard> cards = [];
  GameCard? firstCard;
  GameCard? secondCard;
  bool canFlip = true;
  int matches = 0;
  int moves = 0;

  // List of animal emojis for cards
  final List<String> animals = [
    '🐶', '🐱', '🐭', '🐹',
    '🐰', '🦊', '🐻', '🐼'
  ];

  GameProvider() {
    initGame();
  }

  void initGame() {
    // Create pairs of animals
    final cardPairs = [...animals, ...animals];
    cardPairs.shuffle(Random());
    
    // Create cards with shuffled pairs
    cards = List.generate(
      16, // 4x4 grid
      (index) => GameCard(
        id: index,
        animal: cardPairs[index],
      ),
    );
    
    // Reset game state
    firstCard = null;
    secondCard = null;
    canFlip = true;
    matches = 0;
    moves = 0;
    
    notifyListeners();
  }

  void flipCard(int index) {
    if (!canFlip) return;  // Prevent flipping while checking match
    if (cards[index].isMatched) return;  // Prevent flipping matched cards
    if (cards[index].isFlipped) return;  // Prevent flipping already flipped card
    if (firstCard != null && secondCard != null) return;  // Prevent flipping third card

    // Flip the card
    cards[index] = cards[index].copyWith(isFlipped: true);

    // Assign to first or second card
    if (firstCard == null) {
      firstCard = cards[index];
    } else {
      secondCard = cards[index];
      moves++;  // Increment moves when second card is flipped
      canFlip = false;  // Prevent further flips while checking
      checkMatch();
    }

    notifyListeners();
  }

  Future<void> checkMatch() async {
    if (firstCard == null || secondCard == null) return;

    // Check if animals match
    final isMatch = firstCard!.animal == secondCard!.animal;

    // Wait a moment before processing the result
    await Future.delayed(const Duration(milliseconds: 1000));

    if (isMatch) {
      // Mark both cards as matched
      cards[firstCard!.id] = cards[firstCard!.id].copyWith(isMatched: true);
      cards[secondCard!.id] = cards[secondCard!.id].copyWith(isMatched: true);
      matches++;
    } else {
      // Flip both cards back
      cards[firstCard!.id] = cards[firstCard!.id].copyWith(isFlipped: false);
      cards[secondCard!.id] = cards[secondCard!.id].copyWith(isFlipped: false);
    }

    // Reset selected cards
    firstCard = null;
    secondCard = null;
    canFlip = true;

    notifyListeners();
  }

  bool get isGameComplete => matches == animals.length;
} 