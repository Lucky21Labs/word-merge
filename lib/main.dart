import 'package:flutter/material.dart';
import 'package:word_merge/src/widgets/game_controller.dart';

void main() {
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
      home: const GameController(
        child: SizedBox.expand(),
      ),
    );
  }
}
