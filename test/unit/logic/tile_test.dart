import 'package:flutter_test/flutter_test.dart';
import 'package:word_merge/src/logic/tile.dart';

void main() {
  group('Tile', () {
    test('creates tile with letter and position', () {
      final tile = Tile(letter: 'A', row: 0, column: 1);
      expect(tile.letter, 'A');
      expect(tile.row, 0);
      expect(tile.column, 1);
      expect(tile.locked, false);
      expect(tile.specialModifier, null);
    });

    test('creates locked tile', () {
      final tile = Tile(letter: 'B', row: 1, column: 2, locked: true);
      expect(tile.locked, true);
    });

    test('creates tile with special modifier', () {
      final tile = Tile(
        letter: 'C',
        row: 2,
        column: 3,
        specialModifier: SpecialModifier.doublePoints,
      );
      expect(tile.specialModifier, SpecialModifier.doublePoints);
    });

    test('copyWith creates modified copy', () {
      final tile = Tile(letter: 'A', row: 0, column: 1);
      final modified = tile.copyWith(letter: 'B', locked: true);
      expect(modified.letter, 'B');
      expect(modified.row, 0);
      expect(modified.column, 1);
      expect(modified.locked, true);
    });

    test('tiles with same data are equal', () {
      final tile1 = Tile(letter: 'A', row: 0, column: 1);
      final tile2 = Tile(letter: 'A', row: 0, column: 1);
      expect(tile1, equals(tile2));
    });

    test('tiles with different data are not equal', () {
      final tile1 = Tile(letter: 'A', row: 0, column: 1);
      final tile2 = Tile(letter: 'B', row: 0, column: 1);
      expect(tile1, isNot(equals(tile2)));
    });
  });
}
