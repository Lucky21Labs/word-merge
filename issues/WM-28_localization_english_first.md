# WM-28: Localization (English first)

**Type:** Task
**Priority:** Low
**Status:** To Do
**Effort:** TBD

## Description

Set up internationalization with Flutter intl.

**Tasks:**
- [ ] Add flutter_localizations dependency
- [ ] Create ARB files for English (en)
- [ ] Extract all hardcoded strings to ARB files
- [ ] Implement AppLocalizations delegate
- [ ] Test with locale changes
- [ ] Plan for future languages (Spanish/es)

**Acceptance Criteria:**
- No hardcoded user-facing strings in code
- All text uses AppLocalizations.of(context).stringName
- App switches language when system locale changes
- ARB files are complete and organized

**Dependencies:** WM-19

**Effort:** 4 hours

## Acceptance Criteria

- [ ] All criteria met

## Dependencies

- None

## Notes

_Add any additional notes or links here._

---
*Created from Word Merge Spec v0.1*
