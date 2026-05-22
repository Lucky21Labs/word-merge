import 'package:flutter_test/flutter_test.dart';
import 'package:word_merge/src/logic/move_counter.dart';

void main() {
  group('MoveCounter', () {
    test('initializes with given move limit', () {
      final counter = MoveCounter(maxMoves: 10);
      expect(counter.movesRemaining, 10);
      expect(counter.canMove, true);
    });

    test('decrements moves on use', () {
      final counter = MoveCounter(maxMoves: 5);
      counter.useMove();
      expect(counter.movesRemaining, 4);
    });

    test('canMove returns false when no moves left', () {
      final counter = MoveCounter(maxMoves: 1);
      counter.useMove();
      expect(counter.canMove, false);
    });

    test('throws when using move with no moves remaining', () {
      final counter = MoveCounter(maxMoves: 0);
      expect(() => counter.useMove(), throwsStateError);
    });

    test('resets to max moves', () {
      final counter = MoveCounter(maxMoves: 5);
      counter.useMove();
      counter.useMove();
      counter.useMove();
      expect(counter.movesRemaining, 2);

      counter.reset();
      expect(counter.movesRemaining, 5);
    });

    test('tracks moves used', () {
      final counter = MoveCounter(maxMoves: 10);
      counter.useMove();
      counter.useMove();
      expect(counter.movesUsed, 2);
    });
  });
}
