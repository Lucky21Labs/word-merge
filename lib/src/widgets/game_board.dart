import 'package:flutter/material.dart';
import 'package:word_merge/src/logic/board_state.dart';
import 'package:word_merge/src/logic/tile.dart';

class GameBoard extends StatelessWidget {
  final BoardState board;
  final void Function(int row, int column)? onTileTap;
  final String? lastFormedWord;
  final bool? lastWordValid;
  final int? lastWordScore;
  final DateTime? wordFeedbackTime;

  const GameBoard({
    super.key,
    required this.board,
    this.onTileTap,
    this.lastFormedWord,
    this.lastWordValid,
    this.lastWordScore,
    this.wordFeedbackTime,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Check if word feedback should be shown (within last 1.5 seconds)
    final showFeedback = wordFeedbackTime != null &&
        lastFormedWord != null &&
        DateTime.now().difference(wordFeedbackTime!) < const Duration(milliseconds: 1500);

    return Stack(
      children: [
        GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: BoardState.gridSize,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: BoardState.gridSize * BoardState.gridSize,
          itemBuilder: (context, index) {
            final row = index ~/ BoardState.gridSize;
            final column = index % BoardState.gridSize;
            final tile = board.getTile(row, column);

            return _TileWidget(
              tile: tile,
              onTap: onTileTap != null ? () => onTileTap!(row, column) : null,
            );
          },
        ),
        // Word validation feedback overlay
        if (showFeedback && lastFormedWord != null && lastWordValid != null)
          Positioned.fill(
            child: Container(
              color: (lastWordValid! ? Colors.green : Colors.red).withValues(alpha: 0.3),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        lastWordValid! ? '✓' : '✗',
                        style: TextStyle(
                          fontSize: 48,
                          color: lastWordValid! ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lastFormedWord!,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      if (lastWordScore != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '+${lastWordScore!}',
                          style: TextStyle(
                            fontSize: 20,
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                      Text(
                        lastWordValid! ? 'Valid word!' : 'Not a word',
                        style: TextStyle(
                          fontSize: 16,
                          color: lastWordValid! ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TileWidget extends StatelessWidget {
  final Tile? tile;
  final VoidCallback? onTap;

  const _TileWidget({this.tile, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (tile == null) {
      return Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: tile!.locked
              ? colorScheme.errorContainer
              : tile!.specialModifier != null
              ? colorScheme.tertiaryContainer
              : colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            tile!.letter,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ),
    );
  }
}
