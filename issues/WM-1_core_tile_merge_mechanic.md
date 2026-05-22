# WM-1: Core Tile Merge Mechanic

**Type:** Feature  
**Priority:** High  
**Estimate:** 8 story points  
**Epic:** WM-0 (Word Merge Game Development)

## Description

Implement the core merge mechanic that is the heart of the game:

- 6x6 rectangular grid of letter tiles (A-Z)
- Drag & drop or tap-to-select + tap-adjacent-to-merge
- A + A = B → B + B = C → ... → Y + Y = Z (alphabetical progression)
- New tiles spawn from a pool to replace merged ones
- Move limit per level (configurable)

## Acceptance Criteria

- [ ] `Board` component manages 2D array of `Tile` components
- [ ] `Tile` has letter property, locked state, special modifiers
- [ ] `MergeLogic` class handles merge validation and result
- [ ] `WordValidator` checks if merged letters form valid English words (use provided word list)
- [ ] `ScoreManager` calculates score based on word length and rarity
- [ ] `MoveCounter` tracks remaining moves
- [ ] Board renders correctly with Flame components
- [ ] All logic covered by unit tests (>80% coverage)
- [ ] `flutter analyze` passes with no warnings

## Technical Notes

- Use Flame's `PositionComponent` for tiles
- Board as a `PositionComponent` with children (tiles)
- Drag & drop via Flame's `DragCallbacks` mixin
- Word list: use `assets/words/english.txt` (will be provided)
- Store board state in immutable data structures for easy testing

## References

- See `docs/WordMerge_Spec.md` section 2.2 for full mechanic spec
- See `docs/Art_Style_Guide.md` for tile visual design

## Dependencies

- None (this is the foundation)

## Blocked By

- None
