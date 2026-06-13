# WM-10: Basic word validation (3+ letters, dictionary check)

**Type:** Task
**Priority:** Critical
**Status:** To Do
**Effort:** TBD

## Description

Validate words formed by adjacent tiles against dictionary.

**Tasks:**
- [ ] Detect when player completes a word (3+ adjacent letters in path)
- [ ] Check word against dictionary (case-insensitive)
- [ ] Reject proper nouns and abbreviations (already filtered in dictionary)
- [ ] Highlight valid words in real-time as player forms them
- [ ] Award points for valid words

**Acceptance Criteria:**
- Words of 3+ letters are validated
- Invalid words are rejected
- Real-time highlighting works (green/red)
- Dictionary lookup is fast (<50ms)

**Dependencies:** WM-5, WM-7

**Effort:** 6 hours

## Acceptance Criteria

- [ ] All criteria met

## Dependencies

- None

## Notes

_Add any additional notes or links here._

---
*Created from Word Merge Spec v0.1*
