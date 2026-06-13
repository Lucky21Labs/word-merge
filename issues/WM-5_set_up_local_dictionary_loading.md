# WM-5: Set up local dictionary loading

**Type:** Task
**Priority:** High
**Status:** To Do
**Effort:** TBD

## Description

Implement compressed word dictionary loading for word validation.

**Tasks:**
- [ ] Obtain enable1.txt or similar dictionary (~170k words)
- [ ] Filter out proper nouns and abbreviations
- [ ] Compress dictionary to ~2MB
- [ ] Create Dictionary class with async loading
- [ ] Implement Trie data structure for prefix checking (optional)
- [ ] Add unit tests for dictionary lookup

**Acceptance Criteria:**
- Dictionary loads in <500ms
- Word lookup is O(1) or O(n) where n = word length
- Tests cover edge cases (empty string, non-alpha, etc.)

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
