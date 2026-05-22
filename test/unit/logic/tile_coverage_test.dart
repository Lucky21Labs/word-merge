import 'package:flutter_test/flutter_test.dart';
import 'package:word_merge/src/logic/tile.dart';

void main() {
  group('Tile coverage', () {
    test('copyWith preserves all fields when no changes', () {
      final tile = Tile(letter: 'A', row: 0, column: 0, locked: false);
      final copy = tile.copyWith();
      expect(copy.letter, 'A');
      expect(copy.row, 0);
      expect(copy.column, 0);
      expect(copy.locked, false);
      expect(copy.specialModifier, isNull);
    });

    test('copyWith overrides specified fields', () {
      final tile = Tile(letter: 'A', row: 0, column: 0);
      final copy = tile.copyWith(row: 2, column: 3);
      expect(copy.row, 2);
      expect(copy.column, 3);
      expect(copy.letter, 'A');
    });

    test('equality works correctly', () {
      final tile1 = Tile(letter: 'A', row: 0, column: 0);
      final tile2 = Tile(letter: 'A', row: 0, column: 0);
      final tile3 = Tile(letter: 'B', row: 0, column: 0);
      expect(tile1, equals(tile2));
      expect(tile1, isNot(equals(tile3)));
    });

    test('hashCode is consistent', () {
      final tile1 = Tile(letter: 'A', row: 0, column: 0);
      final tile2 = Tile(letter: 'A', row: 0, column: 0);
      expect(tile1.hashCode, equals(tile2.hashCode));
    });

    test('tileToString returns readable format', () {
      final tile = Tile(letter: 'A', row: 1, column: 2);
      final str = tile.toString();
      expect(str, contains('A'));
      expect(str, contains('1'));
      expect(str, contains('2'));
    });

    test('tile with modifier', () {
      final tile = Tile(
        letter: 'B',
        row: 0,
        column: 0,
        specialModifier: SpecialModifier.doublePoints,
      );
      expect(tile.specialModifier, SpecialModifier.doublePoints);
    });

    test('locked tile', () {
      final tile = Tile(letter: 'C', row: 0, column: 0, locked: true);
      expect(tile.locked, true);
    });

    test('tiles with different row are not equal', () {
      final tile1 = Tile(letter: 'A', row: 0, column: 0);
      final tile2 = Tile(letter: 'A', row: 1, column: 0);
      expect(tile1, isNot(equals(tile2)));
    });

    test('tiles with different column are not equal', () {
      final tile1 = Tile(letter: 'A', row: 0, column: 0);
      final tile2 = Tile(letter: 'A', row: 0, column: 1);
      expect(tile1, isNot(equals(tile2)));
    });
  });
}
