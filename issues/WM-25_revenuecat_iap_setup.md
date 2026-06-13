# WM-25: RevenueCat IAP setup

**Type:** Task
**Priority:** High
**Status:** To Do
**Effort:** TBD

## Description

Implement in-app purchases via RevenueCat.

**Tasks:**
- [ ] Configure RevenueCat products in App Store Connect and Google Play Console
- [ ] Add products:
  - Remove Ads ($4.99)
  - Hint Pack 10 ($1.99)
  - Undo Pack 10 ($1.99)
  - Starter Coin Pack ($0.99, 500 coins)
  - Coin Packs ($2.99/1500, $4.99/3000, $9.99/7000)
  - Level Pack 2 ($1.99)
  - Cosmetic Theme Pack ($2.99)
- [ ] Implement PurchasesFlutter integration
- [ ] Handle purchase flow and restore purchases
- [ ] Grant entitlements (ad-free, coins) after purchase

**Acceptance Criteria:**
- All IAP products are purchasable
- Purchases restore correctly
- Coins are added immediately
- Ad-free removes all ads

**Dependencies:** WM-2

**Effort:** 6 hours

## Acceptance Criteria

- [ ] All criteria met

## Dependencies

- None

## Notes

_Add any additional notes or links here._

---
*Created from Word Merge Spec v0.1*
