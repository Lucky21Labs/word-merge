# WM-12: Win/lose conditions

**Type:** Task
**Priority:** High
**Status:** To Do
**Effort:** TBD

## Description

Implement level completion and failure logic.

**Tasks:**
- [ ] Check win condition: all level objectives met AND moves > 0
- [ ] Check lose condition: moves == 0 AND objectives not met
- [ ] Show level complete screen with score, stars earned, rewards
- [ ] Show level failed screen with retry/watch ad options
- [ ] Calculate star rating (1-3 stars based on score/objectives)
- [ ] Persist level completion state (shared_preferences)

**Acceptance Criteria:**
- Level completes when objectives are met
- Level fails when moves run out
- Star rating is calculated correctly
- Completion state is saved and persists across app restarts

**Dependencies:** WM-11, WM-13

**Effort:** 3 hours

## Acceptance Criteria

- [ ] All criteria met

## Dependencies

- None

## Notes

_Add any additional notes or links here._

---
*Created from Word Merge Spec v0.1*
