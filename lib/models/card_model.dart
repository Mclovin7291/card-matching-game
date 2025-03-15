class GameCard {
  final int id;
  final String animal;
  bool isFlipped;

  GameCard({
    required this.id,
    required this.animal,
    this.isFlipped = false,
  });

  GameCard copyWith({
    int? id,
    String? animal,
    bool? isFlipped,
  }) {
    return GameCard(
      id: id ?? this.id,
      animal: animal ?? this.animal,
      isFlipped: isFlipped ?? this.isFlipped,
    );
  }
} 