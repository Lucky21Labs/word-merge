# WM-24: AdMob integration (banner, interstitial, rewarded)

**Type:** Task
**Priority:** High
**Status:** To Do
**Effort:** TBD

## Description

Integrate AdMob for revenue generation.

**Tasks:**
- [ ] Add test ad unit IDs for development
- [ ] Implement banner ads (bottom of main menu, pause menu)
- [ ] Implement interstitial ads (after 3-5 level failures)
- [ ] Implement rewarded ads:
  - Extra moves (1 per level failure)
  - Hints
  - Undo
  - Shuffle
- [ ] Limit rewarded ad frequency (max 1 per 10 minutes)
- [ ] Respect ad-free IAP (remove all ads)

**Acceptance Criteria:**
- Test ads display correctly in all placements
- Rewarded ads grant rewards after completion
- Ads do not appear for ad-free users
- Ad frequency limits are enforced

**Dependencies:** WM-2, WM-25

**Effort:** 6 hours

## Acceptance Criteria

- [ ] All criteria met

## Dependencies

- None

## Notes

_Add any additional notes or links here._

---
*Created from Word Merge Spec v0.1*
