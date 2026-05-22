import 'dart:math';

import 'tile.dart';

/// Rarity multipliers for letters (based on Scrabble-like distribution).
const Map<String, double> letterRarity = {
  'A': 1.0,
  'B': 3.0,
  'C': 3.0,
  'D': 2.0,
  'E': 1.0,
  'F': 4.0,
  'G': 2.0,
  'H': 4.0,
  'I': 1.0,
  'J': 8.0,
  'K': 5.0,
  'L': 1.0,
  'M': 3.0,
  'N': 1.0,
  'O': 1.0,
  'P': 3.0,
  'Q': 10.0,
  'R': 1.0,
  'S': 1.0,
  'T': 1.0,
  'U': 1.0,
  'V': 4.0,
  'W': 4.0,
  'X': 8.0,
  'Y': 4.0,
  'Z': 10.0,
};

/// Configuration for score calculation.
class ScoreConfig {
  final int basePointsPerLetter;
  final double lengthBonusMultiplier;
  final double wordMultiplier;

  const ScoreConfig({
    this.basePointsPerLetter = 10,
    this.lengthBonusMultiplier = 1.5,
    this.wordMultiplier = 1.0,
  });
}

/// Calculates scores based on word length and letter rarity.
class ScoreManager {
  final ScoreConfig config;

  ScoreManager({
    ScoreConfig? config,
    int? basePointsPerLetter,
    double? lengthBonusMultiplier,
    double? wordMultiplier,
  }) : config =
           config ??
           ScoreConfig(
             basePointsPerLetter: basePointsPerLetter ?? 10,
             lengthBonusMultiplier: lengthBonusMultiplier ?? 1.5,
             wordMultiplier: wordMultiplier ?? 1.0,
           );

  /// Base points per letter from configuration.
  int get basePointsPerLetter => config.basePointsPerLetter;

  /// Calculates the base score for a word with rarity multipliers and length bonus.
  /// This is the core scoring method used during gameplay.
  int calculateScore(List<String> letters) {
    if (letters.isEmpty) return 0;

    int baseScore = 0;
    for (final letter in letters) {
      final rarity = letterRarity[letter.toUpperCase()] ?? 1.0;
      baseScore += (config.basePointsPerLetter * rarity).round();
    }

    // Apply length bonus: longer words get bonus multiplier
    final lengthBonus = pow(
      config.lengthBonusMultiplier,
      letters.length - 1,
    ).toInt();

    // Apply word multiplier
    return (baseScore * lengthBonus * config.wordMultiplier).round();
  }

  /// Calculates the full score including rarity multipliers and length bonus.
  int calculateFullScore(List<String> letters) {
    if (letters.isEmpty) return 0;

    // Base score: sum of (base points * rarity multiplier) for each letter
    int baseScore = 0;
    for (final letter in letters) {
      final rarity = letterRarity[letter.toUpperCase()] ?? 1.0;
      baseScore += (config.basePointsPerLetter * rarity).round();
    }

    // Apply length bonus: longer words get bonus multiplier
    final lengthBonus = pow(
      config.lengthBonusMultiplier,
      letters.length - 1,
    ).toInt();

    // Apply word multiplier
    final finalScore = baseScore * lengthBonus * config.wordMultiplier;

    return finalScore.round();
  }

  /// Calculates score with special tile modifiers applied.
  int calculateScoreWithModifiers(
    List<String> letters,
    List<SpecialModifier?> modifiers,
  ) {
    if (letters.isEmpty) return 0;

    int baseScore = 0;
    for (var i = 0; i < letters.length; i++) {
      final letter = letters[i];
      final modifier = modifiers[i];
      final rarity = letterRarity[letter.toUpperCase()] ?? 1.0;
      var letterScore = (config.basePointsPerLetter * rarity).round();

      // Apply special modifiers
      if (modifier == SpecialModifier.doublePoints) {
        letterScore *= 2;
      } else if (modifier == SpecialModifier.triplePoints) {
        letterScore *= 3;
      }

      baseScore += letterScore;
    }

    final lengthBonus = pow(
      config.lengthBonusMultiplier,
      letters.length - 1,
    ).toInt();
    return (baseScore * lengthBonus * config.wordMultiplier).round();
  }
}
