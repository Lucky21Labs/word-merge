import 'dart:math';

import 'package:flutter/material.dart';
import 'package:word_merge/src/logic/board_state.dart';
import 'package:word_merge/src/logic/merge_logic.dart';
import 'package:word_merge/src/logic/tile.dart';
import 'package:word_merge/src/logic/score_manager.dart';
import 'package:word_merge/src/logic/word_validator.dart';

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
  late ScoreManager _scoreManager;
  late WordValidator _wordValidator;
  int _score = 0;
  Position? _selectedPosition;
  bool _isProcessing = false;

  // Word validation UI state
  String? _lastFormedWord;
  bool? _lastWordValid;
  int? _lastWordScore;
  DateTime? _wordFeedbackTime;

  // Public getters for UI access
  BoardState get board => _board;
  int get score => _score;
  Position? get selectedPosition => _selectedPosition;
  bool get isProcessing => _isProcessing;
  bool get isGameOver => _isGameOver();
  String? get lastFormedWord => _lastFormedWord;
  bool? get lastWordValid => _lastWordValid;
  int? get lastWordScore => _lastWordScore;
  DateTime? get wordFeedbackTime => _wordFeedbackTime;

  @override
  void initState() {
    super.initState();
    _mergeLogic = MergeLogic();
    _scoreManager = ScoreManager();
    _wordValidator = WordValidator(wordFilePath: 'assets/words/english.txt');
    _initializeBoard();
  }

  void _initializeBoard() {
    // Start with 6 random tiles (A-F range)
    final random = Random();
    final initialTiles = <Tile>[];

    for (var i = 0; i < 6; i++) {
      final row = random.nextInt(BoardState.gridSize);
      final col = random.nextInt(BoardState.gridSize);
      final letterCode = random.nextInt(6) + 65; // A-F
      initialTiles.add(
        Tile(letter: String.fromCharCode(letterCode), row: row, column: col),
      );
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
          _lastFormedWord = null;
          _lastWordValid = null;
          _lastWordScore = null;
        });
      }
      return;
    }

    // Tapped the same tile - deselect
    if (_selectedPosition!.row == row && _selectedPosition!.column == column) {
      setState(() {
        _selectedPosition = null;
        _lastFormedWord = null;
        _lastWordValid = null;
        _lastWordScore = null;
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
          _lastFormedWord = null;
          _lastWordValid = null;
          _lastWordScore = null;
        });
      } else {
        // Tapped empty cell - deselect
        setState(() {
          _selectedPosition = null;
          _lastFormedWord = null;
          _lastWordValid = null;
          _lastWordScore = null;
        });
      }
    }
  }

  void _performMerge(Position sourcePos, Position targetPos) {
    _isProcessing = true;

    final result = _mergeLogic.performMerge(_board, sourcePos, targetPos);

    if (result.mergedTile != null) {
      // Get the letters involved in the merge for word validation
      final sourceTile = _board.getTile(sourcePos.row, sourcePos.column)!;
      final targetTile = _board.getTile(targetPos.row, targetPos.column)!;

      // Form a "word" from the merge (source letter + target letter)
      final formedWord = sourceTile.letter + targetTile.letter;

      // Validate the word
      final isValid = _wordValidator.isValidWord(formedWord);

      // Calculate score for this word
      final wordScore = _scoreManager.calculateScore(formedWord.split(''));

      setState(() {
        _board = result.newBoard;
        _score += wordScore;
        _selectedPosition = null;
        _lastFormedWord = formedWord;
        _lastWordValid = isValid;
        _lastWordScore = wordScore;
        _wordFeedbackTime = DateTime.now();
      });

      // Clear word feedback after 1.5 seconds
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _lastFormedWord = null;
            _lastWordValid = null;
            _lastWordScore = null;
            _wordFeedbackTime = null;
          });
        }
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
        final current = _board.getTile(row, col);
        if (current == null) continue;

        // Check all adjacent positions
        for (var dr = -1; dr <= 1; dr++) {
          for (var dc = -1; dc <= 1; dc++) {
            if (dr == 0 && dc == 0) continue;

            final adjacent = Position(row + dr, col + dc);
            final adjacentTile = _board.getTile(adjacent.row, adjacent.column);

            if (adjacentTile != null &&
                adjacentTile.letter == current.letter &&
                !adjacentTile.locked &&
                !current.locked) {
              return false; // Can still merge
            }
          }
        }
      }
    }

    return true; // Board full, no valid merges
  }

  void restartGame() {
    setState(() {
      _score = 0;
      _selectedPosition = null;
      _isProcessing = false;
      _lastFormedWord = null;
      _lastWordValid = null;
      _lastWordScore = null;
      _wordFeedbackTime = null;
      _initializeBoard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
