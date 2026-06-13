# WM-8: Merge logic (adjacent same letter → new tile)

**Type:** Task
**Priority:** Critical
**Status:** To Do
**Effort:** TBD

## Description

Implement the core merge mechanic: dragging same letter onto adjacent tile creates next letter.

**Tasks:**
- [ ] Detect when two tiles are adjacent (4-neighbor grid)
- [ ] Check if letters match (A + A = B)
- [ ] Animate merge (scale up, particles, then new tile appears)
- [ ] Remove old tiles and spawn new tile at merge location
- [ ] Consume a move on merge
- [ ] Update game state (score, moves remaining)

**Acceptance Criteria:**
- A + A → B works correctly
- Y + Y → Z works correctly (last letter)
- Merge animation is smooth (150-300ms)
- Invalid merges are rejected with feedback

**Dependencies:** WM-7

**Effort:** 5 hours

## Acceptance Criteria

- [ ] All criteria met

## Dependencies

- None

## Notes

_Add any additional notes or links here._

---
*Created from Word Merge Spec v0.1*
