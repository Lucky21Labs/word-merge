/// Enumeration of special tile modifiers
enum SpecialModifier {
  /// Double points for this tile
  doublePoints,

  /// Triple points for this tile
  triplePoints,

  /// Bomb - clears adjacent tiles when merged
  bomb,

  /// Freeze - prevents adjacent tiles from being moved
  freeze,

  /// Wildcard - can be used as any letter
  wildcard,
}

/// Immutable representation of a tile on the game board.
class Tile {
  final String letter;
  final int row;
  final int column;
  final bool locked;
  final SpecialModifier? specialModifier;

  const Tile({
    required this.letter,
    required this.row,
    required this.column,
    this.locked = false,
    this.specialModifier,
  });

  /// Creates a copy of this tile with optional modifications.
  Tile copyWith({
    String? letter,
    int? row,
    int? column,
    bool? locked,
    SpecialModifier? specialModifier,
  }) {
    return Tile(
      letter: letter ?? this.letter,
      row: row ?? this.row,
      column: column ?? this.column,
      locked: locked ?? this.locked,
      specialModifier: specialModifier ?? this.specialModifier,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tile &&
          letter == other.letter &&
          row == other.row &&
          column == other.column &&
          locked == other.locked &&
          specialModifier == other.specialModifier;

  @override
  int get hashCode =>
      letter.hashCode ^
      row.hashCode ^
      column.hashCode ^
      locked.hashCode ^
      specialModifier.hashCode;

  @override
  String toString() =>
      'Tile(letter: $letter, row: $row, column: $column, locked: $locked, modifier: $specialModifier)';
}
