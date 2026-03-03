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

## Installation

### Via CurseForge / WoWUp
Search for **MidnightObjectiveTracker** (Project ID: `1469813`) and install.

### Manual Installation

1. Close World of Warcraft if running.
2. Navigate to your AddOns folder:
   ```
   C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\
   ```
3. Create a folder named `MidnightObjectiveTracker` (if it doesn't already exist).
4. Copy the following files into that folder:
   - `MidnightObjectiveTracker.toc`
   - `MidnightObjectiveTracker.locales.lua`
   - `MidnightObjectiveTracker.lua`
   - `MidnightObjectiveTracker.ecus.lua`
   - `MidnightObjectiveTracker.planningcontenu.lua`
   - `MidnightObjectiveTracker.ilvl.lua`
5. Launch WoW. On the character select screen, click **AddOns** (bottom-left) and make sure **MidnightObjectiveTracker** is enabled. Enable *Load out of date AddOns* if needed.
6. Log in and type `/som` in chat to open the tracker.

---

## Troubleshooting

If the addon shows errors, take a screenshot and send it to me on [X (Twitter)](https://x.com/poulpi_x).

---

---

# MidnightObjectiveTracker (FR)

> **Un guide de progression semaine par semaine, directement en jeu, pour World of Warcraft: Midnight.**
> L'addon bascule automatiquement entre le français et l'anglais selon la langue de votre client de jeu.

---

## Fonctionnalités

- **Guide hebdomadaire étape par étape** — Une fenêtre déplaçable en jeu détaillant exactement quoi faire chaque semaine, du lancement de Midnight jusqu'à l'optimisation endgame.
- **Suivi des Écus** — Panneau dédié affichant les sources et quantités d'Écus par niveau de Mythique+, difficulté de Raid et palier de Gouffre.
- **Tableau de planning d'équipement** — Feuille de route complète des ilvl avec les dates de sortie officielles de tout le contenu haut niveau (Raids, Mythique+, Gouffres, Artisanat, JcJ, Boss Monde, Traques…).
- **Référence des niveaux d'objet (iLvl)** — Tableau complet des ilvl par type de contenu (Donjons, Raids, Gouffres, Artisanat), avec paliers d'amélioration et Écus associés.
- **Détection automatique de la langue** — Si votre client WoW est en `frFR` ou `frCA`, l'intégralité de l'addon s'affiche en français. Tous les autres clients affichent l'anglais par défaut.
- **Menu de navigation latéral** — Accès rapide à n'importe quelle semaine depuis la barre latérale.
- **Sauvegarde des cases cochées** — Chaque objectif possède une case à cocher. La cocher grise le texte pour suivre votre progression. L'état est sauvegardé entre les sessions via les `SavedVariables`.
- **Bouton de réinitialisation** — Un bouton "Reset" dans la barre d'outils réinitialise toutes les cases d'un coup.
- **Accessibilité daltonisme** — Sélecteur de palette de couleurs intégré (Protanopie, Deutéranopie, Tritanopie et variantes), accessible via l'icône d'engrenage.
- **Popup de bienvenue** — À la connexion ou au rechargement, une petite fenêtre rappelle la commande `/som`.
- **Liens sociaux** — Boutons pour copier les URLs Discord, Twitch, X (Twitter) directement dans le chat.
- **Commande slash** — `/som` pour afficher/masquer la fenêtre de suivi.

---

## Fichiers

| Fichier | Description |
|---|---|
| `MidnightObjectiveTracker.toc` | Manifeste de l'addon |
| `MidnightObjectiveTracker.locales.lua` | Toutes les chaînes localisées et données CSV (FR + EN) |
| `MidnightObjectiveTracker.lua` | Fenêtre principale du suivi |
| `MidnightObjectiveTracker.ecus.lua` | Panneau des Écus |
| `MidnightObjectiveTracker.planningcontenu.lua` | Tableau de planning |
| `MidnightObjectiveTracker.ilvl.lua` | Tableau de référence des niveaux d'objet |

---

## Installation

### Via CurseForge / WoWUp
Recherchez **MidnightObjectiveTracker** (Project ID : `1469813`) et installez.

### Installation manuelle

1. Fermez World of Warcraft s'il est ouvert.
2. Naviguez vers le dossier AddOns :
   ```
   C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\
   ```
3. Créez un dossier nommé `MidnightObjectiveTracker` (s'il n'existe pas déjà).
4. Copiez les fichiers suivants dans ce dossier :
   - `MidnightObjectiveTracker.toc`
   - `MidnightObjectiveTracker.locales.lua`
   - `MidnightObjectiveTracker.lua`
   - `MidnightObjectiveTracker.ecus.lua`
   - `MidnightObjectiveTracker.planningcontenu.lua`
   - `MidnightObjectiveTracker.ilvl.lua`
5. Lancez WoW. À l'écran de sélection de personnage, cliquez sur **AddOns** (en bas à gauche) et vérifiez que **MidnightObjectiveTracker** est activé. Activez *Charger les addons obsolètes* si nécessaire.
6. Connectez-vous et tapez `/som` dans le chat pour ouvrir le suivi.

---

## Dépannage

Si l'addon affiche des erreurs, faites une capture d'écran et envoyez-la sur [X (Twitter)](https://x.com/poulpi_x).


---

## Features

- **Step-by-step weekly guide** — A draggable, in-game window detailing exactly what to do each week from Midnight launch to endgame optimization.
- **Crest tracker (Écus)** — Dedicated panel showing crest sources and quantities per Mythic+ level, Raid difficulty and Delve tier.
- **Gear planning table** — Full ilvl roadmap with official release dates for all high-end content (Raids, Mythic+, Delves, Crafting, PvP, World Boss, Preys…).
- **Automatic language detection** — If your WoW client is set to `enUS` or `enGB`, the entire addon displays in English. Otherwise it defaults to French.
- **Side navigation menu** — Quick-jump to any week from the sidebar.
- **Checkbox persistence** — Each objective has a checkbox. Checking it greys out the text so you can track your progress. Your checked state is saved between sessions via `SavedVariables`.
- **Reset button** — A "Reset" button in the toolbar resets all checkboxes at once.
- **Social links** — One-click buttons to copy Discord, Twitch, X (Twitter) and Resources URLs into chat.
- **Slash command** — `/som` to toggle the tracker window.

---

## Installation

### Via CurseForge / WoWUp
Search for **MidnightObjectiveTracker** (Project ID: `1469813`) and install.

### Manual Installation

1. Close World of Warcraft if running.
2. Navigate to your AddOns folder:
   ```
   C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\
   ```
3. Create a folder named `MidnightObjectiveTracker` (if it doesn't already exist).
4. Copy the following files into that folder:
   - `MidnightObjectiveTracker.toc`
   - `MidnightObjectiveTracker.locales.lua`
   - `MidnightObjectiveTracker.lua`
   - `MidnightObjectiveTracker.planning.lua`
   - `MidnightObjectiveTracker.mplus.lua`
5. Launch WoW. On the character select screen, click **AddOns** (bottom-left) and make sure **MidnightObjectiveTracker** is enabled. Enable *Load out of date AddOns* if needed.
6. Log in and type `/som` in chat to open the tracker.

---

## Troubleshooting

If the addon shows errors, take a screenshot and send it to me on [X (Twitter)](https://x.com/poulpi_x).

---

---

# MidnightObjectiveTracker (FR)

> **Un guide de progression semaine par semaine, directement en jeu, pour World of Warcraft: Midnight.**
> L'addon bascule automatiquement entre le français et l'anglais selon la langue de votre client de jeu.

---

## Fonctionnalités

- **Guide hebdomadaire étape par étape** — Une fenêtre déplaçable en jeu détaillant exactement quoi faire chaque semaine, du lancement de Midnight jusqu'à l'optimisation endgame.
- **Suivi des Écus** — Panneau dédié affichant les sources et quantités d'Écus par niveau de Mythique+, difficulté de Raid et palier de Gouffre.
- **Tableau de planning d'équipement** — Feuille de route complète des ilvl avec les dates de sortie officielles de tout le contenu haut niveau (Raids, Mythique+, Gouffres, Artisanat, JcJ, Boss Monde, Traques…).
- **Détection automatique de la langue** — Si votre client WoW est en `enUS` ou `enGB`, l'intégralité de l'addon s'affiche en anglais. Sinon, il est en français par défaut.
- **Menu de navigation latéral** — Accès rapide à n'importe quelle semaine depuis la barre latérale.
- **Sauvegarde des cases cochées** — Chaque objectif possède une case à cocher. La cocher grise le texte pour suivre votre progression. L'état est sauvegardé entre les sessions via les `SavedVariables`.
- **Bouton de réinitialisation** — Un bouton "Reset" dans la barre d'outils réinitialise toutes les cases d'un coup.
- **Liens sociaux** — Boutons pour copier les URLs Discord, Twitch, X (Twitter) et Ressources directement dans le chat.
- **Commande slash** — `/som` pour afficher/masquer la fenêtre de suivi.

---

## Installation

### Via CurseForge / WoWUp
Recherchez **MidnightObjectiveTracker** (Project ID : `1469813`) et installez.

### Installation manuelle

1. Fermez World of Warcraft s'il est ouvert.
2. Naviguez vers le dossier AddOns :
   ```
   C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\
   ```
3. Créez un dossier nommé `MidnightObjectiveTracker` (s'il n'existe pas déjà).
4. Copiez les fichiers suivants dans ce dossier :
   - `MidnightObjectiveTracker.toc`
   - `MidnightObjectiveTracker.locales.lua`
   - `MidnightObjectiveTracker.lua`
   - `MidnightObjectiveTracker.planning.lua`
   - `MidnightObjectiveTracker.mplus.lua`
5. Lancez WoW. À l'écran de sélection de personnage, cliquez sur **AddOns** (en bas à gauche) et vérifiez que **MidnightObjectiveTracker** est activé. Activez *Charger les addons obsolètes* si nécessaire.
6. Connectez-vous et tapez `/som` dans le chat pour ouvrir le suivi.

---

## Dépannage

Si l'addon affiche des erreurs, faites une capture d'écran et envoyez-la sur [X (Twitter)](https://x.com/poulpi_x).
