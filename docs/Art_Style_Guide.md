# Word Merge — Art Style Guide

## 1. Design Philosophy

**Goal:** Clean, modern, flat design that feels friendly and approachable — not childish, not corporate. Think "Monument Valley meets Wordscapes." The game should look polished enough that players don't immediately think "AI-generated," but not so detailed that it requires AAA art budget.

**Keywords for AI generation:**
- Flat design
- Minimalist
- Vector illustration
- Clean lines
- Solid colors
- No gradients (or very subtle)
- No photorealism
- 2D game asset
- Mobile game UI
- Consistent style

## 2. Color Palette

**Primary palette (6 colors max):**
- `#4ECDC4` — Teal (primary accent, buttons, highlights)
- `#FF6B6B` — Coral (secondary accent, warnings, special tiles)
- `#FFE66D` — Yellow (stars, coins, bonuses)
- `#1A535C` — Dark teal (text, borders)
- `#F7FFF7` — Off-white (backgrounds)
- `#292F36` — Charcoal (dark text)

**World-specific palettes** (each world uses primary palette + 2-3 accent colors):
- Forest: Greens `#2D6A4F`, `#52B788`, browns `#D4A373`
- Ocean: Blues `#0077B6`, `#00B4D8`, sand `#F4A261`
- Space: Purples `#7209B7`, `#3A0CA3`, stars `#F72585`
- Desert: Oranges `#E76F51`, `#F4A261`, sand `#E9C46A`
- Candy: Pinks `#FF69B4`, `#FFB6C1`, mint `#98FF98`

**Tiles:**
- Base tile: Off-white `#F7FFF7` with subtle border `#E0E0E0`
- Selected tile: Teal accent `#4ECDC4` border, slight scale up (1.05x)
- Matched/merged: Flash animation (scale 1.2 then back), particle burst
- Locked tile: Gray overlay `#CCCCCC` with lock icon

**Typography:**
- Primary font: **Poppins** (Google Fonts) — clean, geometric, readable
- Weights: Regular (400), Medium (500), SemiBold (600)
- Sizes:
  - Tile letters: 32-48px (depends on tile size, ~60% of tile height)
  - UI text: 16-24px
  - Headlines: 32-48px

## 3. Tile Design

**Shape:**
- Rounded rectangles (corner radius: 8-12px)
- Aspect ratio: 1:1 (square) or slightly wider (4:5)
- Tile size: scales with screen (responsive), but typical 80x80dp on mobile

**Visual treatment:**
- Solid fill color (off-white)
- 2px border (gray or accent when selected)
- Letter centered, Poppins SemiBold
- Drop shadow: very subtle, 2px offset, 10% opacity black
- No inner shadows, no gradients

**States:**
- Normal: border `#E0E0E0`
- Selected: border `#4ECDC4`, shadow glow `#4ECDC4` 20% opacity
- Merging: scale animation + particle effect (colored circles)
- Locked: gray overlay `#CCCCCC` + lock icon (from UI icons)

**Special tile modifiers (optional):**
- Double letter: small "2x" badge in corner
- Triple word: small "3x" badge
- Bomb: tile with fuse icon (tap to clear adjacent)
- Frozen: ice overlay (needs adjacent match to clear)

## 4. Backgrounds

**Style:**
- Parallax scrolling (2-3 layers: far, mid, near)
- Each world has a theme (forest, ocean, etc.)
- Use primary palette + world accent colors
- Subtle texture (noise or grain) to avoid flat plastic look
- No focal point (don't compete with game board)

**Implementation:**
- Generate 3 layers per world (far: mountains/trees silhouette, mid: mid-ground elements, near: foreground grass/rocks)
- Tile them seamlessly if possible
- Slight vertical parallax on board move (optional)

**Prompt template for backgrounds:**
```
Flat vector background for {world} level, minimal detailed, 
muted colors, {primary_color} and {accent1}, no focal point, 
game background, 2D, mobile game, style of Monument Valley
```

## 5. UI Elements

**Buttons:**
- Shape: rounded rectangle (corner radius 12-16px)
- Fill: solid accent color (teal `#4ECDC4` for primary, coral `#FF6B6B` for destructive)
- Text: white, Poppins SemiBold, centered
- States: normal, pressed (scale 0.98x, darken 10%), disabled (opacity 50%)
- No gradients, no inner shadows

**Icons:**
- Style: outlined or filled, consistent weight
- Color: accent color or charcoal `#292F36`
- Size: 24-32dp
- Use Feather Icons or Heroicons style (clean, minimal)
- Can generate via AI: "flat icon of a gear, 24px, solid color, minimal"

**Score display:**
- Large number (48-64px) at top
- Small label ("Score") above or below (16px)
- Color: teal accent
- Background: rounded rectangle with subtle shadow

**Moves counter:**
- Similar to score, but coral accent if moves < 5 remaining

**Stars:**
- Simple star shape, yellow `#FFE66D`
- Earned: filled, unearned: outline gray
- Animation: pop in with bounce

**Modals (pause, level complete):**
- Semi-transparent dark overlay `#00000080`
- Centered card: white background, rounded corners (16px), subtle shadow
- Title (32px, charcoal), message (18px, gray), buttons (teal primary, gray secondary)

## 6. Animations

**Principles:** Snappy, responsive, purposeful. Duration 150-300ms. Easing: ease-out for entrances, ease-in-out for transitions.

- **Tile merge:** Scale 1.0 → 1.2 → 1.0, fade out old tile, fade in new tile with scale bounce
- **Tile selection:** Scale 1.0 → 1.05, border color transition 200ms
- **Score popup:** Float up from merged tile, fade out after 500ms
- **Button press:** Scale 0.98 for 100ms
- **Screen transitions:** Slide left/right with fade, 250ms
- **Particles:** On merge, spawn 5-8 small colored circles that expand and fade

## 7. AI Art Generation Pipeline (Local, Zero Cost)

### Setup
- **k3s cluster** running ComfyUI node (already configured)
- Use **SDXL** or **Flux** models fine-tuned for flat design
- All generation happens locally — no external API costs, no rate limits

### Consistency Workflow
1. **Generate style reference first:** Create 1-2 images that define the look (tile example, background example). Save these as `assets/references/`.
2. **Use those as image prompts** for all subsequent assets (img2img mode in ComfyUI).
3. **Batch generation:** Generate all assets of one type (all tiles, then all backgrounds) in a single workflow.
4. **Review batch** before moving to next type — fix prompt if style drifts.
5. **Color extraction:** Pick a reference palette image and include "color palette: #4ECDC4, #FF6B6B, #FFE66D" in every prompt.

### Prompt Templates (for ComfyUI)

**Letter Tiles (shape only, letter added via Flutter Text):**
```
Flat design square tile, rounded corners, blank center, 
off-white background, gray border, no shadow, 
2D game asset, transparent background, 128x128px
```

**Background (world: Forest):**
```
Flat vector background for forest level, minimal detailed, 
muted greens and browns, no focal point, game background, 
2 layers of parallax, mobile game, style of Monument Valley
```

**Button (primary):**
```
Flat design rounded rectangle button, teal color #4ECDC4, 
white text "PLAY", minimal shadow, 2D game UI, mobile game
```

**Icon (settings):**
```
Flat design gear icon, 24px, solid color #292F36, 
minimal, 2D game UI, transparent background
```

**Splash background:**
```
Abstract geometric background, teal and coral gradient, 
minimal, 2D, mobile game splash screen, no text
```

### Post-Processing
- Remove backgrounds if needed (Remove.bg or manual masking in Photopea/GIMP)
- Resize to power-of-2 dimensions (128x128, 256x256, 512x512)
- Optimize with TinyPNG or ImageOptim
- Rename with convention: `tiles/tile_shape_A.png`, `backgrounds/forest_far.png`, `ui/button_play.png`

### Quality Checklist (Before Committing Asset)
- [ ] Colors match palette (teal, coral, yellow, charcoal, off-white)
- [ ] No gradients, no photorealism, no 3D effects
- [ ] Consistent style with reference images
- [ ] Transparent background (PNG)
- [ ] Proper dimensions (power of 2)
- [ ] No watermarks or artifacts

## 8. Asset Pipeline (Detailed)

1. **Generate** batch with ComfyUI using local k3s node
2. **Curate** best outputs manually (pick 3-5 per asset type)
3. **Clean up** in image editor if needed
4. **Optimize** for mobile
5. **Organize** in `assets/images/` with naming convention:
   - `tiles/tile_shape_A.png` (letter added via Flutter Text)
   - `backgrounds/forest_far.png`, `backgrounds/forest_mid.png`, `backgrounds/forest_near.png`
   - `ui/button_play.png`, `ui/button_settings.png`
   - `splash/splash_bg.png`
   - `particles/particle_circle.png`
6. **Commit** to git with descriptive message: "feat: add forest background tiles"

## 9. Example Assets (Reference Games)

Look at these for inspiration on flat style:
- **Monument Valley** (clean geometry, muted palette)
- **Alto's Odyssey** (minimalist, atmospheric)
- **Two Dots** (simple shapes, consistent palette)
- **Wordscapes** (nature themes, flat backgrounds)
- **Blossom Blast** (cute but not overly detailed)

**Do NOT emulate:**
- Hyper-realistic 3D
- Anime/manga style
- Retro pixel (unless we decide that later)
- Cartoon with heavy outlines (like Clash Royale)

## 10. AI Art Limitations & Workarounds

**Limitations:**
- Text generation is poor (AI can't render "A" reliably) → solution: use Flutter Text widget for letters
- Character consistency across poses is hard (not needed for this game)
- Exact color matching requires post-processing

**Workarounds:**
- For letter tiles: Generate tile shape only, overlay letter using Flutter Text (vector text, perfect typography)
- For icons: Generate with AI, then trace in vector editor for consistency if needed
- For backgrounds: AI is fine; adjust colors in post to match palette
- Use AI for concepts, then clean up manually — don't expect perfection

## 11. Asset Generation Checklist (MVP)

- [ ] 26 letter tiles (shape only, letter added via Flutter Text)
- [ ] 5 worlds × 3 background layers = 15 backgrounds
- [ ] 20 UI icons (settings, shop, pause, undo, hint, shuffle, coins, stars, etc.)
- [ ] 10 buttons (various states and labels)
- [ ] Splash screen background
- [ ] Particle texture (simple circle PNG)

## 12. Revision History

- v0.1 — Initial draft, flat design direction, color palette defined

---

*This guide is living — update as we discover what works.*
