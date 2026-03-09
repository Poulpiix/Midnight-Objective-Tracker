# Changelog — MidnightObjectiveTracker

--

## [5.6.1] – 2026-03-09

**Minimap icon — LibDBIcon**
- The minimap button is now powered by **LibDBIcon-1.0** (bundled in `lib/`), replacing the previous hand-crafted implementation.
- The icon now displays the **circular border ring** standard to all LibDBIcon-based addons.
- The button can be **dragged** around the minimap; its position is persisted across sessions in `MidnightObjectiveTrackerDB.minimap`.
- **Click bindings updated:**
  - **Left-click** — open / close the main window.
  - **Right-click** — open / close the Options panel.
  - **Middle-click** — toggle the item-level reference window.
- The tooltip now lists all three click actions and is fully localized in French, English, Spanish and German.

**Great Vault summary panel**
- A new **Great Vault** panel has been added to the right side of the main window, anchored below the weekly summary menu panel.
- Displays a **3 × 3 grid** showing unlock progress for all nine Great Vault slots across the three activity types: **Raid** (thresholds: 2 / 4 / 6), **Dungeon** (1 / 4 / 8), and **World** (2 / 4 / 8).
- Each cell is color-coded in real time using `C_WeeklyRewards.GetActivities()`:
  - **Green** — slot unlocked (threshold reached).
  - **Amber** — in progress (at least one activity completed).
  - **Red** — not started.
  - **Dark grey** — data unavailable.
- Hovering a cell shows a tooltip with the slot's threshold and current progress.
- The panel refreshes automatically every 3 seconds while the main window is open.
- Fully integrated with the Midnight theming system: accent color, window background color, and border are all synchronized with the rest of the addon.
- Localized in **French** and **English** (title, row labels, tooltip strings).

**Panel visibility options**
- Two new checkboxes have been added to the **Options** panel:
  - **"Show Crests summary"** — toggles the horizontal crest bar displayed at the bottom of the main window.
  - **"Show Great Vault"** — toggles the Great Vault 3×3 grid panel.
- Both settings are saved in `MidnightObjectiveTrackerDB` (`showCrestPanel`, `showVaultPanel`) and persist across sessions and version upgrades.
- Both panels default to **visible** on a fresh install.

**Crest panel extracted into its own module**
- The horizontal crest bar (previously inlined in the main file) has been moved to a dedicated module: `modules/MidnightObjectiveTracker.crestpanel.lua`.
- Functionality and positioning are unchanged; its `UpdateCrestPanel` function is now exported via `MidnightTracker.UpdateCrestPanel` for use by the main file.
- The hover-opacity system has been extended to include both `MidnightCrestPanel` and `MidnightVaultPanel`, so hovering either panel at reduced opacity restores full visibility as expected.
- The summary menu panel dynamically adjusts its height to match the number of visible weeks; the Great Vault panel stays flush against the bottom of the menu at all times.

**Localization**
- Keys `show_crest_panel` and `show_vault_panel` added in French and English.
- `reset_info` simplified in all four languages: now reads *"Dates are based on your local timezone."* (and equivalents in FR, DE, ES), removing the EU reset reference.

---

## [5.6] – 2026-03-08

**Timezone-aware date display**
- Week titles (e.g. "Week 3: Mar 11 - 17") and side-menu labels (e.g. "Mar 11 - 17") are now computed dynamically from UTC timestamps using `date("*t", timestamp)`, which applies the player's local OS timezone. US players will see dates shifted one day earlier; Asian players may see them one day later.
- The Crests panel subtitle ("As of March 18" / "À compter du 18 mars" / etc.) follows the same rule, derived from the Week 4 timestamp.
- Each locale (FR, EN, DE, ES) exposes three new formatter functions — `formatMenuLabel`, `formatWeekTitle`, `formatSubtitle` — called via `MidnightL.FormatMenuLabel(weekIndex)`, `MidnightL.FormatWeekTitle(weekIndex)` and `MidnightL.FormatMplusSubtitle()`.
- Existing static strings (`menuLabels`, `weeks[].title`, `mplus_subtitle`) are kept as fallbacks.
- `reset_info` updated in all four locales to reflect the new behavior.

**Locale synchronization (EN / DE / ES)**
- All four CSV sections (Raids, Mythic+, Prey, Delves) in EN, DE and ES have been fully rewritten to match the FR source of truth: correct tier mapping (`??` quantities throughout, M0 row removed), aligned difficulty labels, and proper localized crest names per language.
- Delves tables now contain 15 rows each, including `+ Bonus` tier variants (e.g. Tier 6 + Bonus → Champion, Tier 8/9/10 + Bonus → Heroic, Tier 11 → Heroic), mirroring the FR layout exactly.
- `mplus_subtitle` added to EN ("As of March 18") and DE ("Ab dem 18. März"). The ES entry ("A partir del 18 de marzo") was already present.

**Crest detection — extended language coverage (`ecus.lua`)**
- Veteran tier detection broadened from the literal `"veteran dawn"` to the plain substring `"veteran"`, now correctly covering DE (`Veteran-Morgenwappen`) and ES (`veterano`) in addition to EN.
- Champion tier detection extended with the `"campe"` pattern to cover ES `campeón`, which was previously unrecognized and fell through to an uncoloured white fallback.

**Crest panel — redesign**
- **Full rework (CSV-based multi-section layout)** — The Crests window has been completely rewritten. Data is now driven by per-locale CSV strings, split into independent sections (Raids, Mythic+, Delves, Prey). Each section renders its own titled block with a column-header row and data rows, all dynamically laid out. The window auto-resizes its height to fit all content.
- **Inline crest icons and tier color-coding** — Quantity cells auto-detect the crest tier from the cell text and display the matching icon (`inv_120_crest_*`) followed by the full text colored in the tier accent color (Adventurer, Veteran, Champion, Heroic, Mythic). Unrecognized values are rendered in white; `TBA` entries are shown in grey.
- **Alternating row backgrounds** — Even data rows receive a subtle dark overlay (`0, 0, 0, 0.25`) spanning the full table width for improved readability.
- **Live accent-color update** — The panel is registered with `RegisterAccentColorCallback`; all section titles, column headers and the panel title update instantly when the accent color is changed in the options.
- **Section titles centered** — The section titles ("Raids", "Mythic+", "Delves", "Prey") are now center-aligned instead of left-aligned.
- **Background colors reworked** — Section titles now display the accent-colored background previously applied to column headers. Column headers now use the same dark-blue background (`0.08, 0.08, 0.14, 0.85`) as the upgrade-track table in the iLvl panel.
- **New "Prey" section** — A fourth section for Hunt rewards (Normal, Hard, Nightmare) has been added. Translated in all four languages (FR: Traque, EN: Prey, DE: Jagd, ES: Cacería).
- **Subtitle "À compter du 18 mars"** — A small subtitle is now displayed below the window title to indicate that data applies from 18 March. Translated per locale (FR: "À compter du 18 mars", ES: "A partir del 18 de marzo"). `PAD_T` increased from 36 to 48 to accommodate the extra line.

**Bug fixes**
- **Adventurer and Veteran Dawn Crests — missing icon and color** — The `??` placeholder quantity was not matched by the detection pattern (`[%dX]+`), preventing icon and tier color from being applied. Extended to `[%dX?]+`. Entries with a double `x x` notation (e.g. `?? x x Écu de l'aube de vétéran`) also left a stray `x ` before the colored text; this is now stripped automatically.
- **Champion Dawn Crest — missing icon and color** — The Champion tier was not included in the crest-detection chain in `ecus.lua`. Added the missing `elseif` branch with `inv_120_crest_champion` icon and `MidnightL.C("champion")` color.
- **Scroll resets checked objectives** — Fixed a rare issue where scrolling could reset the checked state of objectives. The `UIPanelScrollFrameTemplate` internal `OnVerticalScroll` handler was being chained unnecessarily and could interfere with ElvUI; the `rowBtn` overlay also overlapped the checkbox area, causing double-toggles under certain addon configurations. The row button now starts after the checkbox zone, and the redundant scroll handler has been removed.

**Objective updates — Weeks 2 to 6 (all languages)**
- **Bonus renown** (Halduron Brightwing) — weekly dungeon quest added to Weeks 2, 3, 4, 5 and 6.
- **Spark** — weekly Spark quest added to Weeks 2, 3, 4, 5 and 6.
- **Cache** — weekly Cache quest added to Weeks 3, 4, 5 and 6.
- **Random delve** (Astalor Bloodsworn) — random delve objective (Veteran/Champion depending on the week) added to Weeks 2, 3, 4 and 5.
- **Lodging** — Lodging quest for Heroic crests added to Week 5.
- **Pit objective (Week 5)** — now points to the Fractured Keystone quest instead of Champion loot 2/6 (250).

**Visual polish**
- **Adventurer Dawn Crest icon** — The `inv_120_crest_adventurer` icon is now displayed inline wherever Adventurer crests appear: in the Crests table and in the weekly objectives of the main tracker (Weeks 1, 2 and 3), in all four languages.
- **Font consistency — week title** — The weekly title font (`GameFontHighlightLarge`) has been replaced with `GameFontNormalLarge` to match the Crests, iLvl and Planning windows.
- **iLvl window — title vertical alignment** — The iLvl title offset was `-12` px while all other windows use `-15` px. Corrected for visual consistency.

---

## [5.5] – 2026-03-06

- **New languages** — Added full support for German (`deDE`) and Spanish (`esES`/`esMX`): weekly objectives, menu labels, tooltips and UI strings are translated in both languages.
- **Client-language tooltips** — Addon tooltips (toolbar buttons, minimap icon, crest panel) are now displayed in the detected WoW client language (FR, EN, DE, ES).
- **Lua error fix** — Fixed a Lua error that occurred on UI reload under certain conditions (nil key access in `MidnightTrackerDB`).
- **Full-row checklist interaction** — Previously, only clicking the checkbox validated an objective. Now, clicking anywhere on the objective row (including the text) also toggles its state. Hovering over a row shows a subtle golden highlight to indicate the clickable area.
- **Reset confirmation popup** — The "Reset" button now shows a confirmation dialog before reset all checked objectives, preventing accidental resets. The popup is fully translated in all four supported languages (FR, EN, DE, ES).
- **Toggleable golden border** — New checkbox in the *Accessibility* panel (gear icon) to enable or disable the golden border on all addon windows.
- **Customizable accent color** — A color picker (compatible with the native WoW Color Picker) allows changing the color used for week titles, menu bullets, objective numbers and the item level label. A *Reset* button reverts to the default gold. The color is saved in the database.
- **ElvUI sync** — A new *Sync with ElvUI* button in the *Accessibility* panel detects if ElvUI is active and automatically syncs the accent color (via `valuecolor` or `bordercolor` from the ElvUI profile) and the window background color. If ElvUI's border color is too dark, `valuecolor` is used as priority.
- **Alignment fix — crest panel** — The gap between the crest summary panel (bottom of the main window) and the main frame was inconsistent with the other side panels. Spacing is now uniform at 4 px on all sides (top, right, bottom).

---
