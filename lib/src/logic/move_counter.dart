/// Tracks the number of moves remaining in a level.
class MoveCounter {
  final int maxMoves;
  int _movesRemaining;
  int _movesUsed;

  MoveCounter({required int maxMoves})
    : maxMoves = maxMoves,
      _movesRemaining = maxMoves,
      _movesUsed = 0;

  /// The number of moves remaining.
  int get movesRemaining => _movesRemaining;

  /// The number of moves used so far.
  int get movesUsed => _movesUsed;

  /// Whether there are moves remaining.
  bool get canMove => _movesRemaining > 0;

  /// Uses one move. Throws StateError if no moves remaining.
  void useMove() {
    if (_movesRemaining <= 0) {
      throw StateError('No moves remaining');
    }
    _movesRemaining--;
    _movesUsed++;
  }

  /// Resets the counter to the initial max moves.
  void reset() {
    _movesRemaining = maxMoves;
    _movesUsed = 0;
  }
}
