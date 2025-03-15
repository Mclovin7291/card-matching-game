class GameCard {
  final int id;
  final String animal;
  bool isFlipped;
  bool isMatched;

  GameCard({
    required this.id,
    required this.animal,
    this.isFlipped = false,
    this.isMatched = false,
  });

  GameCard copyWith({
    int? id,
    String? animal,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return GameCard(
      id: id ?? this.id,
      animal: animal ?? this.animal,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
} 