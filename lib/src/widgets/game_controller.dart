import 'dart:math';

import 'package:flutter/material.dart';
import 'package:word_merge/src/logic/board_state.dart';
import 'package:word_merge/src/logic/merge_logic.dart';
import 'package:word_merge/src/logic/tile.dart';
import 'package:word_merge/src/widgets/game_board.dart';

/// Manages game state and orchestrates the merge logic.
class GameController extends StatefulWidget {
  final Widget child;

  const GameController({super.key, required this.child});

  @override
  State<GameController> createState() => GameControllerState();
}

class GameControllerState extends State<GameController> {
  late BoardState _board;
  late MergeLogic _mergeLogic;
  int _score = 0;
  Position? _selectedPosition;
  bool _isProcessing = false;
  String? _error;

  // Public getters for UI access
  BoardState get board => _board;
  int get score => _score;
  Position? get selectedPosition => _selectedPosition;
  bool get isProcessing => _isProcessing;
  bool get isGameOver => _isGameOver();

  @override
  void initState() {
    super.initState();
    try {
      _mergeLogic = MergeLogic();
      _initializeBoard();
    } catch (e, stack) {
      setState(() {
        _error = 'Init error: $e\n$stack';
      });
    }
  }

  void _initializeBoard() {
    final random = Random();
    final initialTiles = <Tile>[];

    // Start with 4 random tiles
    for (int i = 0; i < 4; i++) {
      final row = random.nextInt(BoardState.gridSize);
      final col = random.nextInt(BoardState.gridSize);
      final letter = String.fromCharCode(
        random.nextInt(6) + 65, // A-F range for start
      );
      initialTiles.add(Tile(letter: letter, row: row, column: col));
    }

    _board = BoardState.fromTiles(initialTiles);
  }

  void handleTileTap(int row, int column) {
    if (_isProcessing) return;

    final tappedPosition = Position(row, column);

    // If no tile selected, select this one
    if (_selectedPosition == null) {
      if (_board.getTile(row, column) != null) {
        setState(() {
          _selectedPosition = tappedPosition;
        });
      }
      return;
    }

    // Tapped the same tile - deselect
    if (_selectedPosition!.row == row && _selectedPosition!.column == column) {
      setState(() {
        _selectedPosition = null;
      });
      return;
    }

    // Check if merge is valid
    final canMerge = _mergeLogic.canMerge(
      _board,
      _selectedPosition!,
      tappedPosition,
    );

    if (canMerge) {
      _performMerge(_selectedPosition!, tappedPosition);
    } else {
      // Select new tile if it exists
      if (_board.getTile(row, column) != null) {
        setState(() {
          _selectedPosition = tappedPosition;
        });
      } else {
        // Tapped empty cell - deselect
        setState(() {
          _selectedPosition = null;
        });
      }
    }
  }

  void _performMerge(Position sourcePos, Position targetPos) {
    _isProcessing = true;

    final result = _mergeLogic.performMerge(_board, sourcePos, targetPos);

    if (result.mergedTile != null) {
      setState(() {
        _board = result.newBoard;
        _score += 10; // Base score for merge
        _selectedPosition = null;
      });

      // Spawn new tile after brief delay
      Future.delayed(const Duration(milliseconds: 300), () {
        _spawnNewTile();
        setState(() {
          _isProcessing = false;
        });
      });
    } else {
      setState(() {
        _isProcessing = false;
        _selectedPosition = null;
      });
    }
  }

  void _spawnNewTile() {
    final random = Random();
    final emptyPositions = _board.getEmptyPositions();

    if (emptyPositions.isNotEmpty) {
      final pos = emptyPositions[random.nextInt(emptyPositions.length)];
      // Spawn letter based on board average level or random A-D
      final letterCode = random.nextInt(4) + 65; // A-D
      final newTile = Tile(
        letter: String.fromCharCode(letterCode),
        row: pos.row,
        column: pos.column,
      );
      setState(() {
        _board = _board.setTile(pos.row, pos.column, newTile);
      });
    }
  }

  bool _isGameOver() {
    if (!_board.isFull) return false;
    // Check if any adjacent tiles can merge
    for (var row = 0; row < BoardState.gridSize; row++) {
      for (var col = 0; col < BoardState.gridSize; col++) {
        final tile = _board.getTile(row, col);
        if (tile == null) continue;
        // Check all 4 directions
        for (final (dr, dc) in [(1, 0), (-1, 0), (0, 1), (0, -1)]) {
          final neighbor = _board.getTile(row + dr, col + dc);
          if (neighbor != null && tile.letter == neighbor.letter) {
            return false; // Valid merge exists
          }
        }
      }
    }
    return true; // Board full, no merges possible
  }

  void restartGame() {
    setState(() {
      _score = 0;
      _selectedPosition = null;
      _isProcessing = false;
      _error = null;
    });
    _initializeBoard();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: Colors.red,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Score display
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Score: $_score',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (_selectedPosition != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Selected: ${_board.getTile(_selectedPosition!.row, _selectedPosition!.column)?.letter}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
            ],
          ),
        ),
        // Game board
        Expanded(
          child: GameBoard(board: _board, onTileTap: handleTileTap),
        ),
        // Game over overlay
        if (isGameOver)
          Container(
            color: Colors.black54,
            child: Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Game Over!',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Final Score: $_score',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: restartGame,
                        child: const Text('Play Again'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        // Instructions
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Tap two adjacent tiles with the same letter to merge them!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
