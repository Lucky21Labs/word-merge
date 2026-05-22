import 'package:flutter_test/flutter_test.dart';
import 'package:word_merge/src/logic/score_manager.dart';
import 'package:word_merge/src/logic/tile.dart';

void main() {
  group('ScoreManager', () {
    test('calculates base score for 3-letter word', () {
      final manager = ScoreManager();
      final score = manager.calculateScore([
        'A',
        'E',
        'I',
      ]); // All common letters (rarity 1.0)
      expect(score, 60); // 30 * length bonus 1.5^2 (truncated to 2) = 60
    });

    test('applies letter rarity multiplier', () {
      final manager = ScoreManager();
      final score = manager.calculateScore(['Q', 'Z']);
      expect(score, greaterThan(20)); // Should be more than base 2*10=20
    });

    test('applies length bonus for longer words', () {
      final manager = ScoreManager();
      final shortScore = manager.calculateScore(['A', 'B', 'C']);
      final longScore = manager.calculateScore(['A', 'B', 'C', 'D', 'E']);
      expect(longScore, greaterThan(shortScore * 5 ~/ 3));
    });

    test('uses default configuration when none provided', () {
      final manager = ScoreManager();
      expect(manager.basePointsPerLetter, 10);
    });

    test('accepts custom configuration', () {
      final manager = ScoreManager(
        config: ScoreConfig(basePointsPerLetter: 5, lengthBonusMultiplier: 1.5),
      );
      final score = manager.calculateScore(['A', 'E', 'I']); // All rarity 1.0
      expect(score, 30); // (5*3) * 1.5^2 (truncated to 2) = 30
    });

    test('calculates score with double points modifier', () {
      final manager = ScoreManager();
      final score = manager.calculateScoreWithModifiers(
        ['A', 'B', 'C'],
        [null, SpecialModifier.doublePoints, null],
      );
      // A: 10*1.0 = 10, B: 10*3.0*2 = 60, C: 10*3.0 = 30, total = 100 * length bonus (1.5^2 = 2) = 200
      expect(score, 200);
    });
  });
}
