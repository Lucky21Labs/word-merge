import 'package:flutter/material.dart';
import 'package:word_merge/src/logic/board_state.dart';
import 'package:word_merge/src/logic/tile.dart';

class GameBoard extends StatelessWidget {
  final BoardState board;
  final void Function(int row, int column)? onTileTap;

  const GameBoard({super.key, required this.board, this.onTileTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
