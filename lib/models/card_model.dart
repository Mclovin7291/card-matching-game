class GameCard {
  final int id;
  final String animal;

  GameCard({
    required this.id,
    required this.animal,
  });

  GameCard copyWith({
    int? id,
    String? animal,
  }) {
    return GameCard(
      id: id ?? this.id,
      animal: animal ?? this.animal,
    );
  }
} 