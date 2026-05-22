import 'tile.dart';

/// Immutable representation of the game board state.
class BoardState {
  static const int gridSize = 6;

  /// The 2D grid of tiles. Null represents an empty cell.
  final List<List<Tile?>> grid;

  const BoardState(this.grid);

  /// Creates an empty board state with all cells null.
  factory BoardState.empty() {
    return BoardState(
      List.generate(gridSize, (_) => List<Tile?>.filled(gridSize, null)),
    );
  }

  /// Creates a board state from a flat list of tiles.
  /// Tiles with null are placed in order, empty cells remain null.
  factory BoardState.fromTiles(List<Tile> tiles) {
    final grid = List<List<Tile?>>.generate(
      gridSize,
      (_) => List<Tile?>.filled(gridSize, null),
    );

    for (final tile in tiles) {
      grid[tile.row][tile.column] = tile;
    }

    return BoardState(grid);
  }

  /// Gets the tile at the specified position, or null if empty.
  Tile? getTile(int row, int column) {
    if (row < 0 || row >= gridSize || column < 0 || column >= gridSize) {
      return null;
    }
    return grid[row][column];
  }

  /// Sets a tile at the specified position, returning a new BoardState.
  BoardState setTile(int row, int column, Tile? tile) {
    if (row < 0 || row >= gridSize || column < 0 || column >= gridSize) {
      return this;
    }
    final newGrid = List<List<Tile?>>.from(
      grid.map((row) => List<Tile?>.from(row)),
    );
    newGrid[row][column] = tile;
    return BoardState(newGrid);
  }

  /// Checks if two positions are adjacent (horizontal or vertical only).
  static bool areAdjacent(int row1, int col1, int row2, int col2) {
    final rowDiff = (row1 - row2).abs();
    final colDiff = (col1 - col2).abs();
    return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1);
  }

  /// Gets all tiles on the board.
  List<Tile> getAllTiles() {
    final tiles = <Tile>[];
    for (var row = 0; row < gridSize; row++) {
      for (var col = 0; col < gridSize; col++) {
        final tile = grid[row][col];
        if (tile != null) {
          tiles.add(tile);
        }
      }
    }
    return tiles;
  }

  /// Checks if the board is full (no empty cells).
  bool get isFull {
    for (var row = 0; row < gridSize; row++) {
      for (var col = 0; col < gridSize; col++) {
        if (grid[row][col] == null) return false;
      }
    }
    return true;
  }

  /// Gets all empty positions on the board.
  List<Position> getEmptyPositions() {
    final positions = <Position>[];
    for (var row = 0; row < gridSize; row++) {
      for (var col = 0; col < gridSize; col++) {
        if (grid[row][col] == null) {
          positions.add(Position(row, col));
        }
      }
    }
    return positions;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardState && _listEquals(grid, other.grid);

  @override
  int get hashCode => _computeHashCode(grid);

  static int _computeHashCode<T>(List<T> list) {
    var hash = 0;
    for (final item in list) {
      if (item is List) {
        hash = hash * 31 + _computeHashCode(item as List);
      } else {
        hash = hash * 31 + (item?.hashCode ?? 0);
      }
    }
    return hash;
  }

  @override
  String toString() => 'BoardState(grid: $grid)';
}

/// Simple 2D position.
class Position {
  final int row;
  final int column;

  const Position(this.row, this.column);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Position && row == other.row && column == other.column;

  @override
  int get hashCode => row.hashCode ^ column.hashCode;

  @override
  String toString() => 'Position(row: $row, column: $column)';
}

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null) return false;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] is List) {
      if (!_listEquals(a[i] as List, b[i] as List)) return false;
    } else {
      if (a[i] != b[i]) return false;
    }
  }
  return true;
}
