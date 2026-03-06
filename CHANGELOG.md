# Changelog — MidnightObjectiveTracker

---

## [5.5] – 2026-03-06

### 🇫🇷 Français

- **Nouvelles langues** — Ajout du support complet pour l'allemand (`deDE`) et l'espagnol (`esES`/`esMX`) : objectifs hebdomadaires, étiquettes de menu, infobulles et chaînes de l'interface traduits dans les deux langues.
- **Infobulles dans la langue du client** — Les infobulles de l'addon (boutons de la barre d'outils, icône minimap, panel de crêtes) s'affichent désormais dans la langue du client WoW détectée automatiquement (FR, EN, DE, ES).
- **Correction d'erreur Lua** — Résolution d'une erreur Lua survenant lors du rechargement de l'interface dans certaines conditions (accès à une clé inexistante dans `MidnightTrackerDB`).
- **Check-list interactive sur toute la ligne** — Auparavant, seul le clic sur la case à cocher validait un objectif. Désormais, cliquer n'importe où sur la ligne de l'objectif (texte inclus) bascule également son état. Au survol de la ligne, un léger fond doré apparaît pour indiquer la zone cliquable.
- **Confirmation avant reset** — Le bouton « Reset » affiche désormais une fenêtre de confirmation avant de réinitialisé toutes les cases cochées, afin d'éviter les réinitialisations accidentelles. La popup est traduite dans les quatre langues supportées (FR, EN, DE, ES).
- **Correction d'alignement — panneau des écus** — La distance entre le panneau des écus (résumé en bas de la fenêtre principale) et la fenêtre de base n'était pas cohérente avec celle des autres panneaux latéraux. L'espacement est désormais uniformisé à 4 px sur tous les côtés (haut, droite, bas).
- **Alignment fix — crest panel** — The gap between the crest summary panel (bottom of the main window) and the main frame was inconsistent with the other side panels. Spacing is now uniform at 4 px on all sides (top, right, bottom).
- **Contour doré désactivable** — Nouvelle case à cocher dans le panel *Accessibilité* (icône engrenage) permettant d'activer ou de désactiver le contour doré sur toutes les fenêtres de l'addon.
- **Couleur d'accentuation personnalisable** — Un sélecteur de couleur (compatible avec le Color Picker natif WoW) permet de modifier la couleur utilisée pour les titres de semaines, les bullets du menu, les numéros d'objectifs et l'étiquette du niveau d'objet. Un bouton *Reset* permet de revenir à l'or par défaut. La couleur est sauvegardée dans la base de données.
- **Synchronisation avec ElvUI** — Un nouveau bouton *Sync avec ElvUI* dans le panel *Accessibilité* détecte si ElvUI est actif et synchronise automatiquement la couleur d'accentuation (via `valuecolor` ou `bordercolor` du profil ElvUI), ainsi que la couleur de fond des fenêtres. Si la couleur de bordure d'ElvUI est trop sombre, la `valuecolor` est utilisée en priorité.

---

### 🇬🇧 English

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
