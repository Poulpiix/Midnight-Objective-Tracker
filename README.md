# MidnightObjectiveTracker

> **A week-by-week in-game progression guide for World of Warcraft: Midnight.**
> Automatically switches between English and French based on your game client language.

---

## Features

- **Step-by-step weekly guide** — A draggable, in-game window detailing exactly what to do each week from Midnight launch to endgame optimization.
- **Crest tracker (Crests)** — Dedicated panel showing crest sources and quantities per Mythic+ level, Raid difficulty and Delve tier.
- **Gear planning table** — Full ilvl roadmap with official release dates for all high-end content (Raids, Mythic+, Delves, Crafting, PvP, World Boss, Preys…).
- **Item level reference (iLvl)** — Full item level table by content type (Dungeons, Raids, Delves, Crafting), with upgrade track and crest info.
- **Automatic language detection** — If your WoW client is set to `frFR` or `frCA`, the entire addon displays in French. All other clients default to English.
- **Side navigation menu** — Quick-jump to any week from the sidebar.
- **Checkbox persistence** — Each objective has a checkbox. Checking it greys out the text so you can track your progress. Your checked state is saved between sessions via `SavedVariables`.
- **Reset button** — A "Reset" button in the toolbar resets all checkboxes at once.
- **Colorblind accessibility** — Built-in color palette switcher (Protanopia, Deuteranopia, Tritanopia and variants) accessible via the gear icon.
- **Welcome popup** — On login or reload, a small popup reminds you of the `/som` slash command.
- **Social links** — One-click buttons to copy Discord, Twitch, X (Twitter) URLs into chat.
- **Slash command** — `/som` to toggle the tracker window.

---

## Files

| File | Description |
|---|---|
| `MidnightObjectiveTracker.toc` | Addon manifest |
| `MidnightObjectiveTracker.locales.lua` | All localised strings and CSV data (FR + EN) |
| `MidnightObjectiveTracker.lua` | Main tracker window |
| `MidnightObjectiveTracker.ecus.lua` | Crest panel (`/Écus`) |
| `MidnightObjectiveTracker.planningcontenu.lua` | Planning table |
| `MidnightObjectiveTracker.ilvl.lua` | Item level reference table |

---

## Troubleshooting

If the addon shows errors, take a screenshot and send it to me on [X (Twitter)](https://x.com/poulpi_x).

---