# MidnightObjectiveTracker

---

> **A week-by-week in-game progression guide for World of Warcraft: Midnight.**
> Automatically detects your WoW client language and displays in French, English, German or Spanish.

<p align="center">
  <img src="https://media0.giphy.com/media/v1.Y2lkPTc5MGI3NjExZWQ2bGt1a2h0Ym5rMWFncm53eDBiZms2aHVqY2hucHNnd2Rpcm41OCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaW" alt="Mon animation" width="500">
</p>

### Features

- **Step-by-step weekly guide** — A draggable, in-game window detailing exactly what to do each week from Midnight launch to endgame optimization.
- **Auto-hide completed weeks** — Once all objectives in a week are checked, it disappears from the list automatically to keep the display clean.
- **Full-row click interaction** — Clicking anywhere on an objective row (including the label) toggles its checked state. A subtle golden highlight appears on hover to indicate the clickable area.
- **Crest panel** — Horizontal bar at the bottom of the main window showing real-time quantities held and weekly cap for each crest type (Adventurer, Veteran, Champion, Heroic, Mythic), plus Sparks of Awakening and Residual Memory.
- **Great Vault panel** — 3 × 3 grid displayed below the weekly summary menu, showing unlock progress for all nine Great Vault slots across Raid (2 / 4 / 6), Dungeon (1 / 4 / 8) and World (2 / 4 / 8). Each cell is color-coded (green = unlocked, amber = in progress, red = not started) and refreshes every 3 seconds.
- **Gear planning table** — Full ilvl roadmap with official release dates for all high-end content (Raids, Mythic+, Delves, Crafting, PvP, World Boss, Preys…).
- **Item level reference (iLvl)** — Full item level table by content type (Dungeons, Raids, Delves, Crafting), with upgrade track and crest info.
- **Live iLvl display** — The side panel shows your current equipped iLvl in real time alongside the estimated iLvl derived from the currently visible week's objectives.
- **Side navigation menu** — Quick-jump to any week from the sidebar.
- **Checkbox persistence** — Each objective has a checkbox. Checking it greys out the text. State is saved between sessions via `SavedVariables`.
- **Reset button with confirmation** — The "Reset" button shows a confirmation popup before wiping all checked objectives, preventing accidental resets.
- **Minimap icon** — Circular LibDBIcon button draggable around the minimap. Position is persisted across sessions.
  - **Left-click** — open / close the main window.
  - **Right-click** — open / close the Options panel.
  - **Middle-click** — toggle the item-level reference window.
- **Smooth scrolling** — Mouse wheel scrolls the content with a smooth animation.
- **Zoom / scale** — `+` and `−` buttons in the toolbar to enlarge or shrink the UI (60 % to 160 %). Right-click either button to reset to 100 %.
- **Opacity slider** — Slider in the *Accessibility* panel (gear icon) to adjust the transparency of all windows (15 % to 100 %).
- **ESC closes the window** — Optional checkbox to include the main window in the list of frames closed by the Escape key.
- **Customizable accent color** — Color picker (compatible with the native WoW Color Picker) to change the color used for week titles, menu bullets, objective numbers and the iLvl label. *Reset* button to revert to default gold. Color is saved.
- **Customizable button background color** — Dedicated color picker for the background tint of all addon buttons. *Reset* button to revert to the default dark red.
- **Toggleable golden border** — Checkbox in the *Accessibility* panel to enable or disable the golden border on all addon windows.
- **Panel visibility options** — Two checkboxes in the Options panel to independently show or hide the Crest panel and the Great Vault panel.
- **ElvUI sync** — *Sync with ElvUI* button in the *Accessibility* panel: detects if ElvUI is active and automatically syncs the accent color (`valuecolor` or `bordercolor`) and window background color.
- **Colorblind accessibility** — Built-in color palette switcher (Protanopia, Deuteranopia, Tritanopia and variants) accessible via the gear icon.
- **Automatic language detection** — `frFR`/`frCA` → French · `deDE` → German · `esES`/`esMX` → Spanish · any other client → English.
- **Social links** — One-click buttons to copy Discord, Twitch, X (Twitter) URLs into chat.
- **Slash command** — `/som` to toggle the tracker window.

### Files

| File | Description |
|---|---|
| `MidnightObjectiveTracker.toc` | Addon manifest |
| `lib/LibStub/LibStub.lua` | LibStub dependency |
| `lib/CallbackHandler-1.0/CallbackHandler-1.0.lua` | CallbackHandler dependency |
| `lib/LibDataBroker-1.1/LibDataBroker-1.1.lua` | LibDataBroker dependency |
| `lib/LibDBIcon-1.0/LibDBIcon-1.0.lua` | Minimap button library |
| `locales/MidnightObjectiveTracker.locales.lua` | Locale dispatch and helpers |
| `locales/MidnightObjectiveTracker.locales.en.lua` | Strings and CSV data (English) |
| `locales/MidnightObjectiveTracker.locales.fr.lua` | Strings and CSV data (French) |
| `locales/MidnightObjectiveTracker.locales.de.lua` | Strings and CSV data (German) |
| `locales/MidnightObjectiveTracker.locales.es.lua` | Strings and CSV data (Spanish) |
| `MidnightObjectiveTracker.lua` | Main tracker window |
| `modules/MidnightObjectiveTracker.ecus.lua` | Crest module (data helpers) |
| `modules/MidnightObjectiveTracker.crestpanel.lua` | Crest summary bar (bottom panel) |
| `modules/MidnightObjectiveTracker.vault.lua` | Great Vault 3×3 grid panel |
| `modules/MidnightObjectiveTracker.planningcontenu.lua` | Gear planning table |
| `modules/MidnightObjectiveTracker.ilvl.lua` | Item level reference table |

### Troubleshooting

If the addon shows errors, take a screenshot and send it to me on [X (Twitter)](https://x.com/poulpi_x).

---
