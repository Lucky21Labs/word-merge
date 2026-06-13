# WM-13: Level data structure and loading

**Type:** Task
**Priority:** High
**Status:** To Do
**Effort:** TBD

## Description

Define level configuration format and load levels from JSON.

**Tasks:**
- [ ] Design level JSON schema (objectives, board size, moves, special tiles, letter distribution)
- [ ] Create sample levels (at least 10 for testing)
- [ ] Implement Level class with deserialization
- [ ] Create LevelManager to load and manage levels
- [ ] Validate level data on load

**Acceptance Criteria:**
- Levels load from JSON without errors
- Level data includes: objectives array, board size, max moves, initial board state
- Invalid levels are rejected with clear error messages

**Dependencies:** WM-1

**Effort:** 3 hours

## Acceptance Criteria

- [ ] All criteria met

## Dependencies

- None

## Notes

_Add any additional notes or links here._

---
*Created from Word Merge Spec v0.1*
