import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:word_merge/src/logic/word_validator.dart';
import 'package:word_merge/src/logic/tile.dart';

void main() {
  group('WordValidator', () {
    late WordValidator validator;

    setUp(() async {
      // Create a temporary word list file for testing
      final tempDir = Directory.systemTemp.createTempSync();
      final wordFile = File('${tempDir.path}/test_words.txt');
      wordFile.writeAsStringSync('APPLE\nBANANA\nCHERRY\nHELLO\nWORLD\n');

      validator = WordValidator(wordFilePath: wordFile.path);
    });

    tearDown(() {
      // Clean up temp file
      final wordFile = File(validator.wordFilePath);
      if (wordFile.existsSync()) {
        wordFile.deleteSync();
      }
    });

    test('loads words from file', () {
      expect(validator.wordCount, greaterThan(0));
    });

    test('validates correct word', () {
      expect(validator.isValidWord('APPLE'), true);
    });

    test('rejects invalid word', () {
      expect(validator.isValidWord('XYZ'), false);
    });

    test('is case insensitive', () {
      expect(validator.isValidWord('apple'), true);
      expect(validator.isValidWord('ApPlE'), true);
    });

    test('validates word formed by merging tiles', () {
      // Simulate tiles spelling HELLO
      final tiles = [
        Tile(letter: 'H', row: 0, column: 0),
        Tile(letter: 'E', row: 0, column: 1),
        Tile(letter: 'L', row: 0, column: 2),
        Tile(letter: 'L', row: 0, column: 3),
        Tile(letter: 'O', row: 0, column: 4),
      ];

      expect(validator.isValidWordFromTiles(tiles), true);
    });

    test('rejects invalid word from tiles', () {
      final tiles = [
        Tile(letter: 'X', row: 0, column: 0),
        Tile(letter: 'Y', row: 0, column: 1),
        Tile(letter: 'Z', row: 0, column: 2),
      ];

      expect(validator.isValidWordFromTiles(tiles), false);
    });
  });
}
