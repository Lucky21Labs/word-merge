import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:word_merge/src/logic/board_state.dart';
import 'package:word_merge/src/logic/tile.dart';
import 'package:word_merge/src/widgets/game_board.dart';

void main() {
  group('GameBoard widget', () {
    testWidgets('renders 6x6 grid', (WidgetTester tester) async {
      final board = BoardState.empty();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GameBoard(board: board)),
        ),
      );

      // Should render grid view
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('displays correct letters on tiles', (
      WidgetTester tester,
    ) async {
      final board = BoardState.fromTiles([
        Tile(letter: 'A', row: 0, column: 0),
        Tile(letter: 'B', row: 0, column: 1),
      ]);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GameBoard(board: board)),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
    });

    testWidgets('shows empty placeholder for null tiles', (
      WidgetTester tester,
    ) async {
      final board = BoardState.empty();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: GameBoard(board: board)),
        ),
      );

      // Should not find any letter text since all tiles are null
      expect(find.byType(Text), findsNothing);
    });
  });
}
