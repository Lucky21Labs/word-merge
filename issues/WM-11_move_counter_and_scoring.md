# WM-11: Move counter and scoring

**Type:** Task
**Priority:** High
**Status:** To Do
**Effort:** TBD

## Description

Implement move counter and scoring system.

**Tasks:**
- [ ] Track moves remaining (starts at level-defined limit, typically 15-30)
- [ ] Decrement moves on each merge
- [ ] Calculate score based on word length and letter values
  - Base score: letter values (Scrabble-like: A=1, B=3, etc.)
  - Length multiplier: 3=1x, 4=2x, 5=3x, 6=4x, 7+=5x
  - Bonus for rare letters (Q=10, X=8, Z=10, J=8)
  - Combo multiplier for consecutive valid words
- [ ] Display score prominently in UI (top of screen)
- [ ] Display moves remaining (coral color when <5)

**Acceptance Criteria:**
- Score updates correctly after each valid word
- Moves decrement on each merge
- Combo multiplier resets on invalid word
- UI displays current score and moves clearly

**Dependencies:** WM-10, WM-8

**Effort:** 4 hours

## Acceptance Criteria

- [ ] All criteria met

## Dependencies

- None

## Notes

_Add any additional notes or links here._

---
*Created from Word Merge Spec v0.1*
