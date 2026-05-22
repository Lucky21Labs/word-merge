import 'package:flutter_test/flutter_test.dart';
import 'package:word_merge/src/logic/board_state.dart';
import 'package:word_merge/src/logic/tile.dart';
import 'package:word_merge/src/logic/merge_logic.dart';

void main() {
  group('MergeLogic', () {
    late MergeLogic mergeLogic;

    setUp(() {
      mergeLogic = MergeLogic();
    });

    test('can merge two identical letters', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'A', row: 0, column: 0),
        Tile(letter: 'A', row: 0, column: 1),
      ]);

      final result = mergeLogic.canMerge(board, Position(0, 0), Position(0, 1));
      expect(result, true);
    });

    test('cannot merge different letters', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'A', row: 0, column: 0),
        Tile(letter: 'B', row: 0, column: 1),
      ]);

      final result = mergeLogic.canMerge(board, Position(0, 0), Position(0, 1));
      expect(result, false);
    });

    test('cannot merge if tiles are not adjacent', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'A', row: 0, column: 0),
        Tile(letter: 'A', row: 2, column: 2),
      ]);

      final result = mergeLogic.canMerge(board, Position(0, 0), Position(2, 2));
      expect(result, false);
    });

    test('cannot merge if source tile is locked', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'A', row: 0, column: 0, locked: true),
        Tile(letter: 'A', row: 0, column: 1),
      ]);

      final result = mergeLogic.canMerge(board, Position(0, 0), Position(0, 1));
      expect(result, false);
    });

    test('cannot merge if target tile is locked', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'A', row: 0, column: 0),
        Tile(letter: 'A', row: 0, column: 1, locked: true),
      ]);

      final result = mergeLogic.canMerge(board, Position(0, 0), Position(0, 1));
      expect(result, false);
    });

    test('cannot merge same position', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'A', row: 0, column: 0),
      ]);

      final result = mergeLogic.canMerge(board, Position(0, 0), Position(0, 0));
      expect(result, false);
    });

    test('merge produces next letter in alphabet', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'A', row: 0, column: 0),
        Tile(letter: 'A', row: 0, column: 1),
      ]);

      final result = mergeLogic.performMerge(
        board,
        Position(0, 0),
        Position(0, 1),
      );

      expect(result.newBoard.getTile(0, 0), isNull);
      expect(result.newBoard.getTile(0, 1)?.letter, 'B');
    });

    test('merge preserves locked state of target tile', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'A', row: 0, column: 0),
        Tile(letter: 'A', row: 0, column: 1, locked: true),
      ]);

      final result = mergeLogic.performMerge(
        board,
        Position(0, 0),
        Position(0, 1),
      );

      expect(result.newBoard.getTile(0, 1)?.locked, true);
    });

    test('merge preserves special modifiers from target tile', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'A', row: 0, column: 0),
        Tile(
          letter: 'A',
          row: 0,
          column: 1,
          specialModifier: SpecialModifier.doublePoints,
        ),
      ]);

      final result = mergeLogic.performMerge(
        board,
        Position(0, 0),
        Position(0, 1),
      );

      expect(
        result.newBoard.getTile(0, 1)?.specialModifier,
        SpecialModifier.doublePoints,
      );
    });

    test('Y + Y = Z', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'Y', row: 0, column: 0),
        Tile(letter: 'Y', row: 0, column: 1),
      ]);

      final result = mergeLogic.performMerge(
        board,
        Position(0, 0),
        Position(0, 1),
      );

      expect(result.newBoard.getTile(0, 1)?.letter, 'Z');
    });

    test('Z + Z cannot merge (max letter)', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'Z', row: 0, column: 0),
        Tile(letter: 'Z', row: 0, column: 1),
      ]);

      final result = mergeLogic.canMerge(board, Position(0, 0), Position(0, 1));
      expect(result, false);
    });

    test('merge returns correct positions', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'A', row: 0, column: 0),
        Tile(letter: 'A', row: 0, column: 1),
      ]);

      final result = mergeLogic.performMerge(
        board,
        Position(0, 0),
        Position(0, 1),
      );

      expect(result.sourcePosition, Position(0, 0));
      expect(result.targetPosition, Position(0, 1));
    });

    test('merge returns merged tile', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'A', row: 0, column: 0),
        Tile(letter: 'A', row: 0, column: 1),
      ]);

      final result = mergeLogic.performMerge(
        board,
        Position(0, 0),
        Position(0, 1),
      );

      expect(result.mergedTile?.letter, 'B');
      expect(result.mergedTile?.row, 0);
      expect(result.mergedTile?.column, 1);
    });

    test('cannot merge tiles that are not adjacent (diagonal)', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'A', row: 0, column: 0),
        Tile(letter: 'A', row: 1, column: 1),
      ]);

      final result = mergeLogic.canMerge(board, Position(0, 0), Position(1, 1));
      expect(result, false);
    });

    test('cannot merge when board is empty', () {
      final board = BoardState.empty();
      final result = mergeLogic.canMerge(board, Position(0, 0), Position(0, 1));
      expect(result, false);
    });

    test('cannot merge with out-of-bounds position', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'A', row: 0, column: 0),
        Tile(letter: 'A', row: 0, column: 1),
      ]);

      final result = mergeLogic.canMerge(
        board,
        Position(0, 0),
        Position(5, 5), // out of bounds
      );
      expect(result, false);
    });

    test('merge on larger board (5x5)', () {
      // Note: BoardState uses fixed gridSize = 6, so we test within that
      final board = BoardState.empty();
      final board2 = board.setTile(2, 2, Tile(letter: 'A', row: 2, column: 2));
      final board3 = board2.setTile(2, 3, Tile(letter: 'A', row: 2, column: 3));

      final result = mergeLogic.performMerge(
        board3,
        Position(2, 2),
        Position(2, 3),
      );

      expect(result.mergedTile?.letter, 'B');
      expect(result.newBoard.getTile(2, 3)?.letter, 'B');
      expect(result.newBoard.getTile(2, 2), isNull);
    });
  });
}
