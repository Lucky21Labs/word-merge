import 'package:flutter_test/flutter_test.dart';
import 'package:word_merge/src/logic/board_state.dart';
import 'package:word_merge/src/logic/tile.dart';

void main() {
  group('BoardState coverage', () {
    test('board equality with identical grids', () {
      final board1 = BoardState.empty();
      final board2 = BoardState.empty();
      expect(board1, equals(board2));
    });

    test('board equality with different grids', () {
      final board1 = BoardState.empty();
      final board2 = board1.setTile(0, 0, Tile(letter: 'A', row: 0, column: 0));
      expect(board1, isNot(equals(board2)));
    });

    test('board hashCode consistency', () {
      final board1 = BoardState.empty();
      final board2 = BoardState.empty();
      expect(board1.hashCode, equals(board2.hashCode));
    });

    test('isFull returns false when board has empty cells', () {
      final board = BoardState.empty();
      expect(board.isFull, false);
    });

    test('isFull returns true when board is completely filled', () {
      final tiles = <Tile>[];
      for (var row = 0; row < BoardState.gridSize; row++) {
        for (var col = 0; col < BoardState.gridSize; col++) {
          tiles.add(Tile(letter: 'A', row: row, column: col));
        }
      }
      final board = BoardState.fromTiles(tiles);
      expect(board.isFull, true);
    });

    test('getEmptyPositions returns all positions on empty board', () {
      final board = BoardState.empty();
      final empty = board.getEmptyPositions();
      expect(empty.length, equals(BoardState.gridSize * BoardState.gridSize));
    });

    test('getEmptyPositions returns fewer positions as board fills', () {
      var board = BoardState.empty();
      board = board.setTile(0, 0, Tile(letter: 'A', row: 0, column: 0));
      final empty = board.getEmptyPositions();
      expect(
        empty.length,
        equals(BoardState.gridSize * BoardState.gridSize - 1),
      );
    });

    test('getAllTiles returns empty list on empty board', () {
      final board = BoardState.empty();
      expect(board.getAllTiles(), isEmpty);
    });

    test('getAllTiles returns all placed tiles', () {
      final board = BoardState.fromTiles([
        Tile(letter: 'A', row: 0, column: 0),
        Tile(letter: 'B', row: 1, column: 1),
        Tile(letter: 'C', row: 2, column: 2),
      ]);
      expect(board.getAllTiles().length, 3);
    });

    test('setTile returns new board with tile placed', () {
      final board = BoardState.empty();
      final newBoard = board.setTile(
        1,
        2,
        Tile(letter: 'X', row: 1, column: 2),
      );
      expect(newBoard.getTile(1, 2)?.letter, 'X');
      expect(board.getTile(1, 2), isNull); // original unchanged
    });

    test('setTile returns same board for out-of-bounds position', () {
      final board = BoardState.empty();
      final newBoard = board.setTile(
        -1,
        0,
        Tile(letter: 'X', row: -1, column: 0),
      );
      expect(identical(board, newBoard), true);
    });

    test('getTile returns null for out-of-bounds', () {
      final board = BoardState.empty();
      expect(board.getTile(-1, 0), isNull);
      expect(board.getTile(0, -1), isNull);
      expect(board.getTile(10, 0), isNull);
      expect(board.getTile(0, 10), isNull);
    });

    test('Position equality and hashCode work correctly', () {
      const pos1 = Position(1, 2);
      const pos2 = Position(1, 2);
      const pos3 = Position(2, 1);

      expect(pos1, equals(pos2));
      expect(pos1.hashCode, equals(pos2.hashCode));
      expect(pos1, isNot(equals(pos3)));
    });

    test('Position toString returns readable format', () {
      const pos = Position(3, 4);
      expect(pos.toString(), 'Position(row: 3, column: 4)');
    });
  });
}
