# Word Merge — Game Design Document

## 1. Game Overview

**Title:** Word Merge (working title)
**Genre:** Puzzle / Word Game
**Platform:** iOS & Android (Flutter + Flame)
**Target Audience:** Casual word game players, ages 25-55, who enjoy quick sessions (2-5 min)
**Core Loop:** Merge letter tiles to form words, score points, complete level objectives, progress through increasingly challenging puzzles
**Session Length:** 2-5 minutes
**Monetization:** Hybrid — rewarded ads for hints/extra moves + IAP for ad-free + cosmetic packs + level packs

## 2. Core Mechanics

### 2.1 Board Layout
- Rectangular grid (4 neighbors per tile) — chosen for simplicity and easier AI asset generation
- Initial board size: 6x6 to 8x8 depending on level
- Tiles contain single letters (A-Z, with weighted distribution)
- Some tiles are "locked" (require adjacent matches to unlock)
- Some tiles have special modifiers: double letter, triple word, bomb (clear adjacent)

### 2.2 Merge Mechanic
- Drag one tile onto another adjacent tile with same letter → they merge into next-level letter tile
  - A + A = B → B + B = C → ... → Y + Y = Z (alphabetical progression)
- Merging consumes a move
- New letter appears on board from a "pool" of upcoming letters
- Goal: Create words of length 3+ to score; length 5+ = bonus; length 7+ = super bonus

### 2.3 Word Validation
- Use local dictionary (enable1.txt or similar, ~170k words)
- Words must be at least 3 letters
- Proper nouns, abbreviations excluded
- Real-time validation: highlight valid/invalid as player forms word

### 2.4 Scoring
- Base score = letter values (Scrabble-like distribution but simpler)
- Length multiplier: 3 letters = 1x, 4 = 2x, 5 = 3x, 6 = 4x, 7+ = 5x
- Bonus for using rare letters (Q, X, Z, J)
- Combo multiplier for consecutive merges without invalid attempt

### 2.6 Level Objectives (Examples)
- Reach target score (e.g., 500 points)
- Create X words of length 5+
- Clear all locked tiles
- Use specific letters (e.g., "use the Q tile")
- Time attack (score as much as possible in 60 seconds)

### 2.7 Move Limits
- Each level has a fixed number of moves (typically 15-30 depending on difficulty)
- Player must complete objectives within the move limit
- Running out of moves = level failure (option to watch rewarded ad for +5 moves)
- Move count displayed prominently in UI
- Some special tiles (e.g., "freeze" modifier) can add moves when matched

### 2.8 Social & Engagement (MVP Scope)
- **Local leaderboards** via Game Center (iOS) and Google Play Games (Android) — free, no backend required
  - Per-level high scores (friend-only and global)
  - Achievements (e.g., "Create 10 words in one level", "Use all vowels")
- **Daily Challenge** mode: One special level per day with unique objectives and shared leaderboard
- **Streaks** for consecutive daily play (reward coins)
- **Cross-promotion** between Lucky21Labs games (if/when we have multiple titles)
- **No multiplayer** in MVP — keep scope small

### 2.9 Progression
- 100+ levels across multiple worlds/themes (Forest, Ocean, Space, etc.)
- Difficulty curve: larger boards, more locked tiles, special modifiers, fewer moves
- Star rating per level: 1-3 stars based on score/objectives
- Unlock new worlds by earning stars

## 3. UI/UX

### Screens
1. **Splash Screen** — Animated logo, background with subtle parallax
2. **Main Menu** — Play, Settings, Daily Challenge, Shop
3. **World Map** — Select world, see star progress, locked/unlocked levels
4. **Level Select** — Grid of levels within a world, stars earned, locked/unlocked
5. **Game Board** — The main play area (hex or grid), score, moves left, objectives panel, pause button
6. **Pause Menu** — Resume, Restart, Quit, Settings toggle
7. **Level Complete** — Score, stars earned, rewards, Next/Replay buttons
8. **Level Failed** — Try Again, Watch Ad for extra moves, Quit
9. **Settings** — Sound, music, notifications, language
10. **Shop** — IAP for ad removal, hint packs, cosmetic themes, level packs

### Controls
- Drag & drop tiles to merge
- Tap tile to select, tap adjacent to merge
- Undo button (limited uses, replenished via IAP/ad)
- Hint button (highlights possible valid word) — costs coins or ad
- Shuffle button (remix remaining letters) — costs coins or ad

### Virtual Currency
- **Coins** — earned by playing (score, stars, daily bonus)
- Used for: hints, undos, shuffles, cosmetic purchases
- Can be purchased via IAP or earned via rewarded ads

## 4. Technical Architecture

### Local AI Art Generation Setup
- **k3s cluster** with ComfyUI node (already configured on homelab)
- ComfyUI accessible via internal service (e.g., `http://comfyui.k3s.local:8188`)
- Use **SDXL** or **Flux** models optimized for flat design/vector art
- Generation workflow: prompt → image → (optional) img2img refinement → post-processing
- Store generated assets in `assets/images/` with proper naming
- Keep prompts and seed values in `assets/prompts/` for reproducibility

### Project Structure
```
word_merge/
├── lib/
│   ├── main.dart
│   ├── app.dart (FlameGame root)
│   ├── constants/
│   │   ├── game_config.dart (board sizes, scoring weights)
│   │   ├── dictionary.dart (word list loading)
│   │   └── progression.dart (level data, world data)
│   ├── components/
│   │   ├── tile.dart (letter tile component)
│   │   ├── board.dart (grid management)
│   │   ├── word_validator.dart
│   │   ├── score_manager.dart
│   │   ├── objectives.dart
│   │   ├── ui/
│   │   │   ├── menu_button.dart
│   │   │   ├── score_display.dart
│   │   │   ├── moves_counter.dart
│   │   │   └── ...
│   ├── screens/
│   │   ├── splash.dart
│   │   ├── main_menu.dart
│   │   ├── world_map.dart
│   │   ├── level_select.dart
│   │   ├── game_screen.dart
│   │   ├── pause_menu.dart
│   │   ├── level_complete.dart
│   │   ├── level_failed.dart
│   │   ├── settings.dart
│   │   └── shop.dart
│   ├── data/
│   │   ├── levels.json (level configurations)
│   │   ├── words.json (compressed word list)
│   │   └── ...
│   ├── services/
│   │   ├── ad_service.dart (AdMob)
│   │   ├── iap_service.dart (RevenueCat)
│   │   ├── analytics_service.dart (Firebase Analytics)
│   │   └── audio_service.dart
│   └── utils/
│       ├── sound_manager.dart
│       ├── preferences.dart
│       └── ...
├── assets/
│   ├── images/
│   │   ├── tiles/ (letter tiles A-Z, special tiles)
│   │   ├── backgrounds/ (world themes)
│   │   ├── ui/ (buttons, icons)
│   │   ├── splash/
│   │   └── ...
│   ├── audio/
│   │   ├── music/
│   │   └── sfx/
│   └── data/
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
├── pubspec.yaml
└── README.md
```

### Dependencies (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  flame: ^1.10.0
  flame_audio: ^2.1.0
  flame_forge2d: (if physics needed)
  google_mobile_ads: ^4.0.0
  purchases_flutter: ^5.0.0 (RevenueCat)
  firebase_core: ^2.24.0
  firebase_analytics: ^10.8.0
  shared_preferences: ^2.2.2
  provider: ^6.1.1 (or riverpod)
  flutter_localizations:
    sdk: flutter
  # Social features (Phase 4)
  games_services: ^4.0.0 (Google Play Games)
  apple_sign_in: (for Game Center, optional)

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  build_runner: (if needed)
```

### Game State Management
- Use `Provider` or `Riverpod` for global state (coins, settings, progression)
- Flame components for game board and tiles
- State persists via `shared_preferences` or local database (Hive/Isar) for progression

### Word Dictionary
- Include compressed word list as asset (enable1.txt filtered)
- Load into memory at startup (170k words ~ 2MB compressed)
- Trie-based lookup for fast prefix checking (optional but nice)

## 5. AI Art Assets

**Total assets needed for MVP:**
- 26 letter tiles (A-Z) — just the tile shape (letter rendered via Flutter Text widget for perfect typography)
- Backgrounds: 5 worlds × 3 parallax layers = 15 backgrounds
- UI elements: ~20 icons (settings, shop, pause, undo, hint, shuffle, coins, stars)
- Buttons: ~10 variants
- Splash screen background
- Particle texture (simple circle PNG)

**Generation Pipeline (Local, Zero Cost):**
- Use **k3s cluster** with ComfyUI node for all image generation (no external API calls)
- Standard SDXL or Flux models fine-tuned for flat design work well
- Generate assets in batches, review, and iterate prompts as needed
- Post-process: remove backgrounds if needed (Remove.bg or manual), resize, optimize
- Store prompts and seed values for reproducibility

See Art Style Guide for specifics.

## 6. Monetization

### Ads (AdMob)
- Banner: bottom of main menu and pause menu (optional)
- Interstitial: after every 3-5 level failures (with opt-out via IAP)
- Rewarded:
  - Extra moves when stuck (1 per level failure)
  - Hints (reveal a valid word)
  - Undo (1 additional undo per use)
  - Shuffle (remix letters)
- Frequency: max 1 rewarded ad per 10 minutes gameplay

### IAP (RevenueCat)
- **Remove Ads** — $4.99 one-time
- **Hint Pack 10** — $1.99 (10 hints, consumable)
- **Undo Pack 10** — $1.99
- **Starter Coin Pack** — $0.99 (500 coins)
- **Coin Packs** — $2.99 (1500), $4.99 (3000), $9.99 (7000)
- **Level Pack 2** — $1.99 (unlock world 2-5 early)
- **Cosmetic Theme Pack** — $2.99 (alternative tile designs, backgrounds)

### Pricing Strategy
- Soft currency (coins) abundant from gameplay, but grindy for large amounts
- Hard currency (premium coins) via IAP only — for rare cosmetics
- Ads provide soft currency + extra moves to reduce frustration

## 7. Analytics & Metrics (Firebase)

Track:
- Daily Active Users (DAU), Monthly Active Users (MAU)
- Session length, sessions per day
- Level attempts, level completion rates, drop-off points
- Ad impressions, clicks, revenue (AdMob)
- IAP purchases, revenue per user (ARPU)
- Retention: Day 1, Day 7, Day 30
- Funnel: Main menu → play → level complete → next level

## 8. Development Phases

### Phase 0: Setup (Week 1)
- [ ] Create Flutter project with Flame
- [ ] Set up CI (GitHub Actions)
- [ ] Configure Firebase, AdMob, RevenueCat
- [ ] Create art style guide and generate first assets
- [ ] Set up local dictionary loading

### Phase 1: Core Mechanic (Week 2-3)
- [ ] Board rendering (grid layout)
- [ ] Tile component (letter display, drag/drop)
- [ ] Merge logic (adjacent same letter → new tile)
- [ ] Letter generation (pool, spawn new)
- [ ] Basic word validation (3+ letters, dictionary check)
- [ ] Move counter, scoring
- [ ] Win/lose conditions

### Phase 2: Level System (Week 4)
- [ ] Level data structure (objectives, board size, moves, special tiles)
- [ ] Level loading and progression (save state)
- [ ] Star rating calculation
- [ ] World map screen
- [ ] Level select screen

### Phase 3: Polish & Content (Week 5)
- [ ] Generate all AI art assets (tiles, backgrounds, UI)
- [ ] Implement all screens (splash, menu, pause, complete, failed)
- [ ] Sound effects and music
- [ ] Animations (tile merge, score popup, transitions)
- [ ] Hints and undo functionality
- [ ] Daily challenge mode (basic)

### Phase 4: Monetization & Launch (Week 6)
- [ ] AdMob integration (banner, interstitial, rewarded)
- [ ] RevenueCat IAP setup
- [ ] Shop screen and coin economy
- [ ] Analytics events
- [ ] Localization (English first, maybe Spanish later)
- [ ] App Store assets (screenshots, descriptions, keywords)
- [ ] Testing on real devices
- [ ] Soft launch (TestFlight, Internal Testing)
- [ ] Bug fixes based on feedback
- [ ] Submit to App Store & Google Play

### Phase 5: Post-Launch (Ongoing)
- [ ] Monitor analytics, fix crash reports
- [ ] Add new levels (content updates)
- [ ] Seasonal events (themes, limited-time levels)
- [ ] Cross-promotion with other Lucky21Labs games
- [ ] Community building (Discord, Reddit)

## 9. Testing Strategy

- Unit tests for core logic (merge, scoring, word validation)
- Widget tests for UI components
- Integration tests for game flow
- Manual QA on multiple device sizes
- Beta testing with 20-50 users via TestFlight
- A/B testing for monetization (ad frequency, IAP pricing)

## 10. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| AI art looks inconsistent | High | High | Strict style guide, generate reference first, review all assets before use |
| Word dictionary too large/slow | Medium | Medium | Compress to 2MB, load async, use Trie for prefix checks |
| Game too easy/hard | High | High | Playtest extensively, tune scoring/objectives |
| Low retention (players churn quickly) | High | High | Add daily challenges, streaks, progression rewards |
| Monetization too aggressive | Medium | Medium | Offer ad-free IAP, limit ad frequency |
| App Store rejection | Low | High | Follow guidelines, no deceptive IAP, privacy policy |

## 12. Open Questions (Resolved)

1. **Post-MVP updates:** Plan for 4-6 week content update cycles (new worlds, special events, seasonal themes). Architecture should support DLC/content packs.
2. **Localization:** English only for MVP, but code must use Flutter's `intl` package and ARB files from day one. No hardcoded strings.
3. **ComfyUI models:** Use SDXL-based model fine-tuned for flat design/vector art. I'll provide specific model recommendations and a ComfyUI workflow JSON.
4. **Hint system:** Pay-per-hint using virtual coins (earned or purchased). Hints highlight a valid word on the board.
5. **Undo:** Limited to 3 per level, +1 via rewarded ad or IAP "unlimited undo" consumable.

## 12. Success Criteria (MVP)

- 100 levels with increasing difficulty
- Core merge mechanic polished and fun
- Word validation works reliably
- Ads and IAP functional
- Retention: Day 1 > 40%, Day 7 > 15%, Day 30 > 5%
- Average session length > 3 minutes
- Revenue: $500/month within 3 months of launch

---

*Document version: 0.1 — Draft for review*
*Last updated: 2026-05-21*
