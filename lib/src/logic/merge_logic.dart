import 'dart:math';

import 'board_state.dart';
import 'tile.dart';

/// Result of a merge operation.
class MergeResult {
  /// The new board state after merge
  final BoardState newBoard;

  /// Position of the source tile that was consumed
  final Position sourcePosition;

  /// Position of the target tile that received the merge
  final Position targetPosition;

  /// The resulting merged tile (null if merge was invalid)
  final Tile? mergedTile;

  const MergeResult({
    required this.newBoard,
    required this.sourcePosition,
    required this.targetPosition,
    this.mergedTile,
  });
}

/// Handles validation and execution of tile merges.
class MergeLogic {
  static const int maxLetter = 90; // 'Z'.codeUnitAt(0)
  static const int minLetter = 65; // 'A'.codeUnitAt(0)

  /// Checks if two tiles can be merged.
  bool canMerge(BoardState board, Position pos1, Position pos2) {
    final tile1 = board.getTile(pos1.row, pos1.column);
    final tile2 = board.getTile(pos2.row, pos2.column);

    // Both positions must have tiles
    if (tile1 == null || tile2 == null) return false;

    // Cannot merge same position
    if (pos1.row == pos2.row && pos1.column == pos2.column) return false;

    // Tiles must be adjacent
    if (!BoardState.areAdjacent(pos1.row, pos1.column, pos2.row, pos2.column)) {
      return false;
    }

    // Neither tile can be locked
    if (tile1.locked || tile2.locked) return false;

    // Letters must be the same
    if (tile1.letter != tile2.letter) return false;

    // Cannot merge Z (max letter)
    if (tile1.letter == 'Z') return false;

    return true;
  }

  /// Performs a merge operation, returning a new board state.
  MergeResult performMerge(
    BoardState board,
    Position sourcePos,
    Position targetPos,
  ) {
    if (!canMerge(board, sourcePos, targetPos)) {
      return MergeResult(
        newBoard: board,
        sourcePosition: sourcePos,
        targetPosition: targetPos,
        mergedTile: null,
      );
    }

    final sourceTile = board.getTile(sourcePos.row, sourcePos.column)!;
    final targetTile = board.getTile(targetPos.row, targetPos.column)!;

    // Calculate the merged letter
    final nextLetter = _getNextLetter(sourceTile.letter);

    // Create merged tile at target position
    // Preserve locked state from source, modifier from target
    final mergedTile = Tile(
      letter: nextLetter,
      row: targetPos.row,
      column: targetPos.column,
      locked: sourceTile.locked,
      specialModifier: targetTile.specialModifier,
    );

    // Create new board: source tile removed, target tile replaced with merged tile
    var newBoard = board.setTile(sourcePos.row, sourcePos.column, null);
    newBoard = newBoard.setTile(targetPos.row, targetPos.column, mergedTile);

    return MergeResult(
      newBoard: newBoard,
      sourcePosition: sourcePos,
      targetPosition: targetPos,
      mergedTile: mergedTile,
    );
  }

  /// Returns the next letter in the alphabet sequence.
  String _getNextLetter(String letter) {
    final code = letter.toUpperCase().codeUnitAt(0);
    if (code >= maxLetter) return letter;
    return String.fromCharCode(code + 1);
  }
}
