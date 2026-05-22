import 'package:flutter/material.dart';
import 'src/widgets/game_controller.dart';
import 'src/widgets/game_board.dart';

void main() {
  FlutterError.onError = (details) {
    print('FlutterError: ${details.exception}');
    if (details.stack != null) print('Stack: ${details.stack}');
  };
  runApp(const WordMergeApp());
}

class WordMergeApp extends StatelessWidget {
  const WordMergeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Merge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GameController(child: _GameHome()),
    );
  }
}

class _GameHome extends StatelessWidget {
  const _GameHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Merge'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const _GameBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRestartDialog(context),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  void _showRestartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Restart Game?'),
        content: const Text('This will reset your score and the board.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              final controller = context
                  .findAncestorStateOfType<GameControllerState>();
              controller?.restartGame();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}

class _GameBody extends StatelessWidget {
  const _GameBody();

  @override
  Widget build(BuildContext context) {
    final controller = context.findAncestorStateOfType<GameControllerState>();

    if (controller == null) {
      return const Center(child: Text('Error: GameController not found'));
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
                'Score: ${controller.score}',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (controller.selectedPosition != null)
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
                    'Selected: ${controller.board.getTile(controller.selectedPosition!.row, controller.selectedPosition!.column)?.letter}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
            ],
          ),
        ),
        // Game board
        Expanded(
          child: GameBoard(
            board: controller.board,
            onTileTap: controller.handleTileTap,
          ),
        ),
        // Game over overlay
        if (controller.isGameOver)
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
                        'Final Score: ${controller.score}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: controller.restartGame,
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
