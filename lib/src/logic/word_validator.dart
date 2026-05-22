import 'dart:io';

import 'tile.dart';

/// Validates words against a dictionary.
class WordValidator {
  final String wordFilePath;
  final Set<String> _words;

  WordValidator({required this.wordFilePath})
    : _words = _loadWords(wordFilePath);

  /// Loads words from the specified file into a set (uppercase).
  static Set<String> _loadWords(String filePath) {
    final file = File(filePath);
    if (!file.existsSync()) {
      return <String>{};
    }

    final content = file.readAsStringSync();
    final words = content
        .split('\n')
        .map((line) => line.trim().toUpperCase())
        .where((word) => word.isNotEmpty);

    return words.toSet();
  }

  /// Checks if a word is valid.
  bool isValidWord(String word) {
    return _words.contains(word.toUpperCase().trim());
  }

  /// Checks if the letters from a sequence of tiles form a valid word.
  bool isValidWordFromTiles(List<Tile> tiles) {
    if (tiles.isEmpty) return false;

    final word = tiles.map((t) => t.letter).join();
    return isValidWord(word);
  }

  /// Returns the number of words in the dictionary.
  int get wordCount => _words.length;
}
