local L = {}
_G.MidnightL = L

local currentLocale = "fr"

function L.GetLocale()
    return currentLocale
end

function L.Init()
    local gameLocale = GetLocale and GetLocale() or "enUS"
    if gameLocale == "frFR" or gameLocale == "frCA" then
        currentLocale = "fr"
    else
        currentLocale = "en"
    end
end

function L.S(key)
    local loc = currentLocale
    if L[loc] and L[loc][key] ~= nil then
        return L[loc][key]
    end
    if L.fr and L.fr[key] ~= nil then
        return L.fr[key]
    end
    return key
end

L.fr = {}

L.fr.title = "Suivi d'objectif Midnight"
L.fr.planning = "Planning"
L.fr.crests = "Écus"
L.fr.resources = "Ressources"
L.fr.discord_desc = "Copie l'adresse du serveur Discord de la guilde dont je suis membre (nous recherchons d'ailleurs nos derniers membres pour notre roster Mythique)"
L.fr.twitch_desc = "Copie l'URL de ma chaîne Twitch, je live généralement du mardi au vendredi dès 18h."
L.fr.resources_desc = "Copie l'URL des ressources ayant permis de créer ce guide, les données proviennent de différentes sources comme : Larias, WoW Head, Icy Vein, Judge Hype ou Blizz Spirit, elles ont été entrecroisées pour créer un guide de progression cohérent et optimisé."
L.fr.resources_short_desc = "Les données proviennent de différentes sources comme : Larias, WoW Head, Icy Vein, Judge Hype ou Blizz Spirit, elles ont été entrecroisées pour créer un guide de progression cohérent et optimisé."
L.fr.reset_info = "Les dates correspondent au reset hebdomadaire Français. Selon où vous jouez dans le monde, votre réinitialisation hebdomadaire sera décalée. A vous de vous adapter au besoin."
L.fr.x_desc = "Copie l'URL de mon compte X (Twitter), si des questions il y a."
L.fr.reset_checks = "Reset"
L.fr.reset_checks_desc = "Réinitialise toutes les cases cochées du suivi d'objectifs."
L.fr.ilvl_label = "Niveau d'objet"
L.fr.ilvl_no_data = "N/A"
L.fr.ilvl_button = "iLvl"
L.fr.ilvl_button_title = "Référence des Niveaux d'Objet"
L.fr.ilvl_button_desc = "Ouvre le guide de référence des niveaux d'objet"
L.fr.crest_panel_title = "Écus"
L.fr.slash_msg = "|cffFFD100[Midnight]|r Tapez /som pour ouvrir le suivi d'objectifs."
L.fr.welcome_title = "Midnight Objective Tracker"
L.fr.welcome_msg = "Tapez |cffFFD100/som|r dans le chat pour ouvrir le suivi d'objectifs."
L.fr.no_data = "Aucune donnée."
L.fr.no_csv_data = "Aucune donnée importée depuis le CSV."
L.fr.scale_up = "Zoom +"
L.fr.scale_up_desc = "Augmente la taille de l'interface (police et fenêtres)."
L.fr.scale_down = "Zoom -"
L.fr.scale_down_desc = "Réduit la taille de l'interface (police et fenêtres)."
L.fr.scale_reset = "Zoom par défaut"
L.fr.scale_reset_desc = "Réinitialise le zoom à sa valeur par défaut (clic droit)."
L.fr.csv_error = "[Midnight] Erreur lors du parsing du CSV Planning : "

L.fr.colorblind_title = "Accessibilité"
L.fr.colorblind_none = "Vision normale"
L.fr.colorblind_none_desc = "Palette de couleurs par défaut."
L.fr.colorblind_protanopia = "Protanopie"
L.fr.colorblind_protanopia_desc = "Absence totale de perception du rouge."
L.fr.colorblind_protanomaly = "Protanomalie"
L.fr.colorblind_protanomaly_desc = "Perception affaiblie du rouge."
L.fr.colorblind_deuteranopia = "Deutéranopie"
L.fr.colorblind_deuteranopia_desc = "Absence totale de perception du vert."
L.fr.colorblind_deuteranomaly = "Deutéranomalie"
L.fr.colorblind_deuteranomaly_desc = "Perception affaiblie du vert."
L.fr.colorblind_tritanopia = "Tritanopie"
L.fr.colorblind_tritanopia_desc = "Absence de perception du bleu."
L.fr.colorblind_tritanomaly = "Tritanomalie"
L.fr.colorblind_tritanomaly_desc = "Perception altérée du bleu."
L.fr.colorblind_setting_btn = "Accessibilité"
L.fr.colorblind_setting_desc = "Options d'accessibilité pour les daltoniens."

L.fr.mplus_title = "Écus"
L.fr.planning_title = "Planning"
L.fr.ilvl_title = "Palier des niveaux d'équipements par contenu"
L.fr.ilvl_upgrade_tracks = "Paliers d'amélioration (20 écus par palier)"
L.fr.ilvl_crafted = "Artisanat"
L.fr.ilvl_dungeon = "Donjons"
L.fr.ilvl_raid = "Raids (estimations)"
L.fr.ilvl_delve = "Gouffres abondants"
L.fr.ilvl_quality = "Qualité"
L.fr.ilvl_season = "Contenu"
L.fr.ilvl_end_loot = "Butin"
L.fr.ilvl_great_vault = "Chambre Forte"
L.fr.ilvl_difficulty = "Difficulté"
L.fr.ilvl_normal = "Early"
L.fr.ilvl_mid = "Mid"
L.fr.ilvl_late = "Late"
L.fr.ilvl_end = "End"
L.fr.ilvl_tier = "Palier"
L.fr.ilvl_map_drop = "Carte"
L.fr.ilvl_ilvl = "ilvl"
L.fr.ilvl_upgrade_tracks_short = "Palier"
L.fr.ilvl_crests = "Écus"
L.fr.ilvl_adventurer = "Aventurier"
L.fr.ilvl_veteran = "Vétéran"
L.fr.ilvl_champion = "Champion"
L.fr.ilvl_crest_adv = "Écus de l'aube d'aventure"
L.fr.ilvl_crest_vet = "Écus de l'aube vétéran"
L.fr.ilvl_crest_champ = "Écus de l'aube de champion"
L.fr.ilvl_crest_hero = "Écus de l'aube héroïque"
L.fr.ilvl_crest_myth = "Écus de l'aube mythique"

L.fr.summaryPatterns = {
    "^Écus dépensés%s*:",
    "^Niveau d['%%\"]?équipement estimé%s*%(selon RNG%)%s*:"
}

L.fr.menuLabels = {
    "27/02 - 03/03",
    "04/03 - 10/03",
    "11/03 - 17/03",
    "18/03 - 24/03",
    "25/03 - 31/03",
    "01/04 - 07/04",
    "08/04 - 14/04",
    "15/04 - 21/04",
    "22/04 - 28/04",
    "29/04 et +",
}

L.fr.weeks = {
    {
        title = "Accès Anticipé (27 fév. - 3 mars)",
        objectives = {
            "Ne dépensez aucun Écu sauf si demandé.",
            "XP : atteignez le niveau 90 avec les personnages que vous souhaitez jouer pendant Midnight.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
            "Event : inutile d'attendre dimanche pour le bonus de réputation de la « Foire de Sombrelune », ce dernier a été nerf et apporte désormais un MALUS pour les renoms de Midnight.",
            "Renom : atteignez le rang 7 du renom « Singularité » pour obtenir un bijou Champion 1/6 (246).",
            "Renom : atteignez le rang 9 du renom « Cour de Lune d'Argent » pour obtenir un casque Champion 1/6 (246).",
            "Expédition : accomplissez des expéditions offrant de l'équipement Aventurier 1/6 (220) et 2/6 (224).",
            "Traque : accomplissez des Traques en mode normal (4 par semaine), offrant de l'équipement Aventurier 1/6 (220) (faites les en même temps que les expéditions).",
            "Fulgurion : accomplissez l'Assaut de Fulgurion sur Tempête du Vide pour obtenir de l'équipement Aventurier 1/6 (220) et en même temps réaliser la quête du renom pour le bijou Champion 1/6 (246).",
            "Niveau d'équipement estimé (selon RNG) : 12x 224, 1x 227, 2x 246"
        }
    },
    {
        title = "Hors-saison - Semaine 1 (4 - 10 mars)",
        objectives = {
            "Ne dépensez aucun Écu sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
            "Renom : atteignez le rang 8 du renom « Hara'ti » pour obtenir une ceinture Champion 1/6 (246).",
            "Renom : atteignez le rang 9 du renom « Tribu des Amani » pour obtenir un collier Champion 1/6 (246).",
            "Gouffre : débloquez le palier 3 (les paliers supérieurs étant bloqués jusqu'au 18 mars).",
            "Expédition : accomplissez des expéditions offrant de préférence des améliorations d'équipement.",
            "Traque : accomplissez des Traques en mode difficile (4 par semaine), offrant de l'équipement Vétéran 1/6 (233) (faites les en même temps que les expéditions).",
            "Mythique 0 (hors-saison) : accomplissez tous les donjons en Mythique 0 (hors-saison), offrant de l'équipement Vétéran 3/6 (240) (n'améliorez pas l'équipement obtenu).",
            "Héroïque (hors-saison) : accomplissez tous les donjons en Héroïque (hors-saison), offrant de l'équipement Aventurier 2/6 (224) (n'améliorez pas l'équipement obtenu).",
            "Niveau d'équipement estimé (selon RNG) : 3x 233, 8x 240, 4x 246"

        }
    },
    {
        title = "Hors-saison - Semaine 2 (11 - 17 mars)",
        objectives = {
            "Ne dépensez aucun Écu sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
            "Gouffre : débloquez le palier 3 (les paliers supérieurs étant bloqués jusqu'au 18 mars).",
            "Expédition : accomplissez des expéditions offrant de préférence des améliorations d'équipement.",
            "Traque : accomplissez des Traques en mode difficile (4 par semaine), offrant de l'équipement Vétéran 1/6 (233) (faites les en même temps que les expéditions).",
            "Mythique 0 (hors-saison) : accomplissez tous les donjons en Mythique 0 (hors-saison), offrant de l'équipement Vétéran 3/6 (240) (n'améliorez pas l'équipement obtenu).",
            "Artisanat : préparez les composants d'artisanat si vous raidez le 18 mars.",
            "Niveau d'équipement estimé (selon RNG) : 10x 240, 4x 246"
        }
    },
    {
        title = "Saison 1 - Semaine 1 (18 - 24 mars)",
        objectives = {
            "Ne dépensez aucun Écus de l'aube héroïque et Écus de l'aube mythique sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
            "Set de classe : utilisez l'outil Raids (LFR) pour obtenir des pièces de sets.",
            "Mythique 0 (Pré-saison): réalisez un World Tour des donjons Mythique 0 (Pré-saison), offrant désormais de l'équipement Champion 2/6 (250).",
            "Boss monde : tuez le Boss monde pour obtenir de l'équipement Champion 2/6 (250).",
            "Traque : accomplissez des Traques en mode cauchemar (4 par semaine), offrant de l'équipement Champion 1/6 (246).",
            "JcJ : faites la quête JcJ pour obtenir le collier ou l'anneau Hero garanti (si disponible, car disparu de la bêta recemment).",
            "Gouffre : accomplissez des Gouffres abondants (palier 11) avec clés et carte pour obtenir de l'équipement Champion 2/6 (250).",
            "Artisanat : fabriquez 2 équipements Vétéran 5/5 (246) en utilisant 80x Ecu de l'aube vétéran chacun avec 2 embellissements (Priorisez les Poignets, Ceinture et Bottes).",
            "Raid : accomplissez le mode Normal et Héroïque.",
            "Optimisation : dépensez tous les Écus de l'aube vétéran et les Écus de l'aube de Champion avant d'entrer en raid.",
            "Écus dépensés : 0/100 Écus de l'aube héroïque et 0/100 Écus de l'aube mythique.",
            "Niveau d'équipement estimé (selon RNG) : 2x 246, 3x 240, 10x 250"
        }
    },
    {
        title = "Semaine 2 (25 - 31 mars)",
        objectives = {
            "Ne dépensez aucun Écus de l'aube héroïque et Écus de l'aube mythique sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
            "Artisanat : si votre discord de classe le recommande, utilisez 1 étincelle pour fabriquer un Mythe 1/5 (272) avec embellissement (ce cas de figure sera plutôt rare, donc adaptez-vous pour la suite du guide).",
            "Set de classe : utilisez l'outil Raids (LFR) pour obtenir des pièces de sets.",
            "Boss monde : tuez le Boss monde pour obtenir de l'équipement Champion 2/6 (250).",
            "Traque : accomplissez des Traques en mode cauchemar (4 par semaine), offrant de l'équipement Champion 1/6 (246).",
            "Gouffre : accomplissez des Gouffres abondants (palier 11) avec clés et carte pour obtenir de l'équipement Champion 2/6 (250).",
            "Mythique + (Saison 1) : accomplissez des donjons +10 (minimum) pour obtenir de l'équipement Hero 3/6 (266), si c'est trop difficile, faites du +8 pour obtenir de l'équipement Hero 2/6 (263).",
            "Raid : accomplissez le mode Normal et Héroïque avant de commencer la progression Mythique.",
            "Raid Mythique : améliorez 11 équipements Hero 3/6 (266) -> 4/6 (269) contre 220x Écus de l'aube héroïque (priorisez les bagues / bijoux ou pièce de set que vous comptez garder longtemps).",
            "Astuce : si vous avez la chance d'obtenir de l'équipement Mythe en raid, vous pouvez l'améliorer 2 fois (ajustez simplement les conseils jusqu'à ce que cela s'équilibre à nouveau).",
            "Écus dépensés : 220/220 Écus de l'aube héroïque et 0/100 Écus de l'aube mythique.",
            "Niveau d'équipement estimé (selon RNG) : 4x 266, 11x 269"
        }
    },
    {
        title = "Semaine 3 (1 - 7 avril)",
        objectives = {
            "Ne dépensez aucun Écus de l'aube héroïque et Écus de l'aube mythique sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
            "Grande Chambre Forte : ouvrez là pour obtenir un équipement Mythe 272+. Les armes à 2H sont d'excellents choix si vous avez de la chance. Améliorez là seulement après avoir lu l'instruction ci-dessous.",
            "Artisanat : à moins d'avoir eu une arme 2H Mythe en raid ou dans la Grande Chambre forte, fabriquez une arme 2H Mythe 5/5 (285) contre 60x Écus de l'aube mythique, sauf si votre Discord de classe le déconseille fortement.",
            "Set de classe : si vous n'avez pas encore votre bonus 4-pièces (4p), utilisez l'outil Raids (LFR) pour récupérer les pièces manquantes.",
            "Mythique + (Saison 1) : accomplissez des donjons +10 (minimum) pour remplir les emplacements de votre Grande Chambre Forte et accumuler vos différents Écus.",
            "Raid : accomplissez le mode Normal, Héroique et Mythique.",
            "Palier Héroïque : améliorez deux de vos équipements Hero 4/6 (269) -> 6/6 (276) contre 80x Écus de l'aube héroïque. Gardez 20x Écus de l'aube héroïque pour l'étape suivante.",
            "Palier Mythe : si l'équipement de votre Grande Chambre Forte est un équipement Mythe 1/6 (272), améliorez d'abord son équivalent Hero 6/6 (276) contre 20x Écus de l'aube héroïque. Améliorez ensuite votre équipement Mythe 1/6 (272) -> 6/6 (289) contre 80x Écus de l'aube mythique.",
            "Second Mythe : si vous possédez un second équipement Mythe, attendez les conseils d'amélioration de la semaine suivante.",
            "Écus dépensés : 320/320 Écus de l'aube héroïque et 160/320 Écus de l'aube mythique.",
            "Niveau d'équipement estimé (selon RNG) : 3x 266, 8x 269, 2x 276, 1x 285, 1x 289"
        }
    },
    {
        title = "Semaine 4 (8 - 14 avril)",
        objectives = {
            "Ne dépensez aucun Écus de l'aube héroïque et Écus de l'aube mythique sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
            "Grande Chambre Forte : ouvrez là pour obtenir un équipement Mythe 272+",
            "Mythique + (Saison 1) : ccomplissez des donjons +10 (minimum) pour remplir les emplacements de votre Grande Chambre Forte et accumuler vos différents Écus.",
            "Hypothèse : nous partons du principe que vous avez obtenu un équipement Mythe (2/6, ilvl 276).",
            "Palier Héroïque : améliorez deux de vos équipements Hero 4/6 (269) -> 6/6 (276) contre 80x Écus de l'aube héroïque. Gardez 20x Écus de l'aube héroïque pour l'étape suivante.",
            "Palier Mythe : si l'équipement de votre Grande Chambre Forte est un équipement Mythe 1/6 (272), améliorez d'abord son équivalent Hero 6/6 (276) contre 20x Écus de l'aube héroïque. Améliorez ensuite votre équipement Mythe 1/6 (272) -> 6/6 (289) contre 80x Écus de l'aube mythique.",
            "Palier Mythe (Raid) : améliorez la pièce obtenue en raid du rang 2/6 (276) vers le 6/6 (289) contre 80x Écus de l'aube mythique.",
            "Écus dépensés : 420/420 Écus de l'aube héroïque et 320/420 Écus de l'aube mythique",
            "Niveau d'équipement estimé (selon RNG) : 2x 266, 5x 269, 4x 276, 1x 285, 3x 289"
        }
    },
    {
        title = "Semaine 5 (15 - 21 avril)",
        objectives = {
            "Ne dépensez aucun Écus de l'aube héroïque et Écus de l'aube mythique sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
            "Grande Chambre Forte : ouvrez là pour obtenir un équipement Mythe 272+",
            "Mythique + (Saison 1) : accomplissez des donjons +10 (minimum) pour remplir les emplacements de votre Grande Chambre Forte et accumuler vos différents Écus.",
            "Artisanat : fabriquez votre second équipement Mythe 5/5 (285) contre 80x Écus de l'aube mythique. Privilégiez si possible un emplacement où vous possédez déjà un équipement Héro.",
            "Palier Héroïque : améliorez deux de vos équipements Hero 4/6 (269) -> 6/6 (276) contre 80x Écus de l'aube héroïque. Gardez 20x Écus de l'aube héroïque pour l'étape suivante",
            "Palier Mythe : si l'équipement de votre Grande Chambre Forte est un équipement Mythe 1/6 (272), améliorez d'abord son équivalent Hero 6/6 (276) contre 20x Écus de l'aube héroïque. Améliorez ensuite votre équipement Mythe 1/6 (272) -> 6/6 (289) pour 80x Écus de l'aube mythique.",
            "Écus dépensés : 520/520 Écus de l'aube héroïque et 480/480 Écus de l'aube mythique.",
            "Niveau d'équipement estimé (selon RNG) : 1x 266, 2x 269, 6x 276, 2x 285, 4x 289"
        }
    },
    {
        title = "Semaine 6 (22 - 28 avril)",
        objectives = {
            "Ne dépensez aucun Écus de l'aube héroïque et Écus de l'aube mythique sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
            "Grande Chambre Forte : ouvrez là pour obtenir un équipement Mythe 272+",
            "Mythique + (Saison 1) : accomplissez des donjons +12 (minimum) pour remplir les emplacements de votre Grande Chambre Forte et accumuler vos différents Écus.",
            "Hypothèse : nous partons du principe que vous avez obtenu 1 pièce Mythe 2/6 (276)",
            "Palier Héroïque : améliorez un de vos équipements Hero 4/6 (269) -> 6/6 (276) contre 40x Écus de l'aube héroïque.",
            "Palier Mythe : si l'équipement de votre Grande Chambre Forte est un Mythe 1/6 (272), améliorez d'abord son équivalent Hero 6/6 (276) contre 20x Écus de l'aube héroïque. Améliorez ensuite votre Mythe 1/6 (272) -> 6/6 (289) pour 80x Écus de l'aube mythique.",
            "Palier Mythe (Raid) : améliorez l'équipement Mythe 2/6 (276) -> 5/6 (285) contre 60x Écus de l'aube mythique",
            "Écus dépensés : 560/620 Écus de l'aube héroïque et 620/620 Écus de l'aube mythique.",
            "Niveau d'équipement estimé (selon RNG) : 7x 276, 2x 285, 1x 285, 5x 289."
        }
    },
    {
        title = "Semaine 7+ (29 avril et après)",
        objectives = {
            "Artisanat : ne fabriquez aucun objet dans un emplacement si vous avez la possibilité d'obtenir dans votre Grande Chambre Forte des équipements supérieur à Mythe 1/6 (272).",
            "Priorité d'amélioration : améliorez vos équipements Mythe au fur et à mesure que vous les obtenez. Privilégiez une amélioration complète jusqu'a 6/6 (289) pour profiter du saut important de +4 niveaux d'objet.",
            "Optimisation d'arme : commencez à envisager la fabrication d'une main gauche (OH) à un moment donné si vous souhaitez porter une arme principale (MH) 6/6 tout en conservant un embellissement sur votre arme."
        }
    }
}

L.fr.mplus_csv = [[
Source,Quantités
Raid LFR,TBA
Raid Normal,TBA
Raid Héroïque,TBA
Raid Mythique,TBA
M0,TBA
Mythique +2,10 x Ecu de l'aube héroïque
Gouffre Palier 2,TBA
Mythique +3,12 x Ecu de l'aube héroïque
Gouffre Palier 3,TBA
Mythique +4,14 x Ecu de l'aube héroïque
Gouffre Palier 4,TBA
Mythique +5,16 x Ecu de l'aube héroïque
Gouffre Palier 5,TBA
Mythique +6,18 x Ecu de l'aube héroïque
Gouffre Palier 6,TBA
Mythique +7,10 x Ecu de l'aube mythique
Gouffre Palier 7,TBA
Mythique +8,12 x Ecu de l'aube mythique
Gouffre Palier 8,TBA
Mythique +9,14 x Ecu de l'aube mythique
Gouffre Palier 9,TBA
Mythique +10,16 x Ecu de l'aube mythique
Gouffre Palier 10,TBA
Mythique +11,18 x Ecu de l'aube mythique
Gouffre Palier 11,TBA
Mythique +12,20 x Ecu de l'aube mythique
]]

L.fr.planning_csv = [[
,27 février,4 mars,18 mars,25 mars,01 avril,8 avril
Expéditions,X,,,,,
Traques,Normal,Difficile,Cauchemar,,,
Boss monde,,,X,,,
"JcJ",,,"Honneur (276)
Guerre (276)
Conquête (289)",,,
"Gouffres","Palier 1-2-3","Palier 4-5-6-7","Palier 8-9-10-11
Abondant",,,
Donjons,"Normal
Héroïque
(Hors-saison)","M0
(Hors-saison)","M0
(Pré-saison)","M+
(Saison 1)",,
Raids,,,"Faille du rêve
Flèche du vide
(LFR Aile 1 - Normal - Héroïque)","Faille du rêve
(Mythique)
Flèche du vide
(Histoire, LFR Aile 2 - Mythique)","Flèche du vide
(LFR Aile 3)
Marche de Quel'Danas
(Normal, Héroïque, Mythique)","Marche de Quel'Danas
(Histoire, LFR)"
]]

L.en = {}

L.en.title = "Midnight Objective Tracker"
L.en.planning = "Planning"
L.en.crests = "Crests"
L.en.resources = "Resources"
L.en.discord_desc = "Copies the Discord server address of the guild I'm a member of (we are also looking for our last members for our Mythic roster)"
L.en.twitch_desc = "Copies my Twitch channel URL, I usually stream Tuesday to Friday from 6PM (CET)."
L.en.resources_desc = "Copies the URL of resources used to create this guide, data comes from various sources such as: Larias, WoW Head, Icy Veins, Judge Hype or Blizz Spirit, cross-referenced to create a coherent and optimized progression guide."
L.en.resources_short_desc = "Data comes from various sources such as: Larias, WoW Head, Icy Veins, Judge Hype or Blizz Spirit, cross-referenced to create a coherent and optimized progression guide."
L.en.reset_info = "Dates correspond to the French weekly reset. Depending on where you play in the world, your weekly reset may differ. Adjust accordingly."
L.en.x_desc = "Copies my X (Twitter) account URL, if you have any questions."
L.en.reset_checks = "Reset"
L.en.reset_checks_desc = "Resets all checked objectives in the tracker."
L.en.ilvl_label = "Item Level"
L.en.ilvl_no_data = "N/A"
L.en.ilvl_button = "iLvl"
L.en.ilvl_button_title = "Item Level Reference"
L.en.ilvl_button_desc = "Open the Item Level reference guide"
L.en.crest_panel_title = "Crests"
L.en.slash_msg = "|cffFFD100[Midnight]|r Type /som to open the objective tracker."
L.en.welcome_title = "Midnight Objective Tracker"
L.en.welcome_msg = "Type |cffFFD100/som|r in the chat to open the objective tracker."
L.en.no_data = "No data."
L.en.no_csv_data = "No data imported from CSV."
L.en.scale_up = "Zoom +"
L.en.scale_up_desc = "Increase interface size (fonts and windows)."
L.en.scale_down = "Zoom -"
L.en.scale_down_desc = "Decrease interface size (fonts and windows)."
L.en.scale_reset = "Default zoom"
L.en.scale_reset_desc = "Reset zoom to default value (right-click)."
L.en.csv_error = "[Midnight] Error parsing Planning CSV: "

L.en.colorblind_title = "Accessibility"
L.en.colorblind_none = "Normal vision"
L.en.colorblind_none_desc = "Default color palette."
L.en.colorblind_protanopia = "Protanopia"
L.en.colorblind_protanopia_desc = "Complete absence of red perception."
L.en.colorblind_protanomaly = "Protanomaly"
L.en.colorblind_protanomaly_desc = "Weakened red perception."
L.en.colorblind_deuteranopia = "Deuteranopia"
L.en.colorblind_deuteranopia_desc = "Complete absence of green perception."
L.en.colorblind_deuteranomaly = "Deuteranomaly"
L.en.colorblind_deuteranomaly_desc = "Weakened green perception."
L.en.colorblind_tritanopia = "Tritanopia"
L.en.colorblind_tritanopia_desc = "Absence of blue perception."
L.en.colorblind_tritanomaly = "Tritanomaly"
L.en.colorblind_tritanomaly_desc = "Altered blue perception."
L.en.colorblind_setting_btn = "Accessibility"
L.en.colorblind_setting_desc = "Accessibility options for color blindness."

L.en.mplus_title = "Crests"
L.en.planning_title = "Planning"
L.en.ilvl_title = "Season 1 Gear Tier by Content"
L.en.ilvl_upgrade_tracks = "Upgrade (20 crests per step)"
L.en.ilvl_crafted = "Crafting"
L.en.ilvl_dungeon = "Dungeons"
L.en.ilvl_raid = "Raids (Estimation)"
L.en.ilvl_delve = "Bountiful delves"
L.en.ilvl_quality = "Quality"
L.en.ilvl_season = "Content"
L.en.ilvl_end_loot = "Loot"
L.en.ilvl_great_vault = "Vault"
L.en.ilvl_difficulty = "Difficulty"
L.en.ilvl_normal = "Early"
L.en.ilvl_mid = "Mid"
L.en.ilvl_late = "Late"
L.en.ilvl_end = "End"
L.en.ilvl_tier = "Tier"
L.en.ilvl_map_drop = "Map"
L.en.ilvl_ilvl = "ilvl"
L.en.ilvl_upgrade_tracks_short = "Track"
L.en.ilvl_crests = "Crests"
L.en.ilvl_adventurer = "Adventurer"
L.en.ilvl_veteran = "Veteran"
L.en.ilvl_champion = "Champion"
L.en.ilvl_crest_adv = "Adventurer Dawn Crests"
L.en.ilvl_crest_vet = "Veteran Dawn Crests"
L.en.ilvl_crest_champ = "Champion Dawn Crests"
L.en.ilvl_crest_hero = "Heroic Dawn Crests"
L.en.ilvl_crest_myth = "Mythic Dawn Crests"

L.en.summaryPatterns = {
    "^Crests spent%s*:",
    "^Estimated gear level%s*%(based on RNG%)%s*:"
}

L.en.menuLabels = {
    "Feb 27 - Mar 3",
    "Mar 4 - 10",
    "Mar 11 - 17",
    "Mar 18 - 24",
    "Mar 25 - 31",
    "Apr 1 - 7",
    "Apr 8 - 14",
    "Apr 15 - 21",
    "Apr 22 - 28",
    "Apr 29+",
}

L.en.weeks = {
    {
        title = "Early Access (Feb 27 - Mar 3)",
        objectives = {
            "Do not spend any Crest unless asked.",
            "XP: reach level 90 with the characters you want to play during Midnight.",
            "Crests: reach the weekly cap for all your Crests.",
            "Event: no need to wait until Sunday for the 'Darkmoon Faire' reputation bonus; it has been nerfed and now applies a PENALTY to Midnight renowns.",
            "Renown: reach rank 7 of 'The Singularity' renown for a Champion 1/6 (246) trinket.",
            "Renown: reach rank 9 of 'Amani Tribe' renown for a Champion 1/6 (246) necklace.",
            "Expedition: complete expeditions offering Adventurer 1/6 (220) and 2/6 (224) gear.",
            "Prey: complete Preys in Normal mode (4 per week), offering Adventurer 1/6 (220) gear (do them at the same time as expeditions).",
            "Fulgurion: complete the Fulgurion Assault on Voidstorm to obtain Adventurer 1/6 (220) gear and at the same time complete the renown quest for the Champion 1/6 (246) trinket.",
            "Estimated gear level (based on RNG): 12x 224, 1x 227, 2x 246"
        }
    },
    {
        title = "Off-season - Week 1 (Mar 4 - 10)",
        objectives = {
            "Do not spend any Crest unless asked.",
            "Crests: reach the weekly cap for all your Crests.",
            "Renown: reach rank 8 of 'Hara'ti' renown for a Champion 1/6 (246) belt.",
            "Renown: reach rank 9 of 'Silvermoon Court' renown for a Champion 1/6 (246) helmet.",
            "Renown: reach rank 9 of 'Amani Tribe' renown for a Champion 1/6 (246) necklace.",
            "Delve: unlock tier 3 (higher tiers are locked until March 18).",
            "Expedition: complete expeditions that preferably offer gear upgrades.",
            "Prey: complete Preys in Hard mode (4 per week), offering Vétéran 1/6 (233) gear (do them at the same time as expeditions).",
            "Mythic 0 (off-season): complete all Mythic 0 (off-season) dungeons, offering Vétéran 3/6 (240) gear (do not upgrade obtained gear).",
            "Heroic (off-season): complete all Heroic (off-season) dungeons, offering Adventurer 2/6 (224) gear (do not upgrade obtained gear).",
            "Estimated gear level (based on RNG): 3x 233, 8x 240, 4x 246"
        }
    },
    {
        title = "Off-season - Week 2 (Mar 11 - 17)",
        objectives = {
            "Do not spend any Crest unless asked.",
            "Crests: reach the weekly cap for all your Crests.",
            "Delve: unlock tier 3 (higher tiers are locked until March 18).",
            "Expedition: complete expeditions that preferably offer gear upgrades.",
            "Prey: complete Preys in Hard mode (4 per week), offering Vétéran 1/6 (233) gear (do them at the same time as expeditions).",
            "Mythic 0 (off-season): complete all Mythic 0 (off-season) dungeons, offering Vétéran 3/6 (240) gear (do not upgrade obtained gear).",
            "Crafting: prepare crafting materials if you plan to raid on March 18.",
            "Estimated gear level (based on RNG): 10x 240, 4x 246"
        }
    },
    {
        title = "Season 1 - Week 1 (Mar 18 - 24)",
        objectives = {
            "Do not spend any Heroic Dawn Crests or Mythic Dawn Crests unless asked.",
            "Crests: reach the weekly cap for all your Crests.",
            "Class Set: use the Raids tool (LFR) to obtain set pieces.",
            "Mythic 0 (Pre-season): complete a World Tour of Mythic 0 (Pre-season) dungeons, now offering Champion 2/6 (250) gear.",
            "World Boss: kill the World Boss for Champion 2/6 (250) gear.",
            "Prey: complete Preys in Nightmare mode (4 per week), offering Champion 1/6 (246) gear.",
            "PvP: complete the PvP quest to get a guaranteed Hero necklace or ring (if available, as it recently disappeared from the beta).",
            "Delve: complete Bountiful Delves (tier 11) with keys and map for Champion 2/6 (250) gear.",
            "Crafting: craft 2 Vétéran 5/5 (246) gear using 80x Veteran Dawn Crest each with 2 embellishments (Prioritize Wrists, Belt and Boots).",
            "Raid: complete Normal and Heroic mode.",
            "Optimization: spend all Veteran Dawn Crests and Champion Dawn Crests before entering the raid.",
            "Crests spent: 0/100 Heroic Dawn Crests and 0/100 Mythic Dawn Crests.",
            "Estimated gear level (based on RNG): 2x 246, 3x 240, 10x 250"
        }
    },
    {
        title = "Week 2 (Mar 25 - 31)",
        objectives = {
            "Do not spend any Heroic Dawn Crests or Mythic Dawn Crests unless asked.",
            "Crests: reach the weekly cap for all your Crests.",
            "Crafting: if your class Discord recommends it, use 1 spark to craft a Myth 1/5 (272) with embellishment (this will be rather rare, so adapt for the rest of the guide).",
            "Class Set: use the Raids tool (LFR) to obtain set pieces.",
            "World Boss: kill the World Boss for Champion 2/6 (250) gear.",
            "Prey: complete Preys in Nightmare mode (4 per week), offering Champion 1/6 (246) gear.",
            "Delve: complete Bountiful Delves (tier 11) with keys and map for Champion 2/6 (250) gear.",
            "Mythic+ (Season 1): complete +10 dungeons (minimum) for Hero 3/6 (266) gear, if too difficult, do +8 for Hero 2/6 (263) gear.",
            "Raid: complete Normal and Heroic mode before starting Mythic progression.",
            "Mythic Raid: upgrade 11 Hero 3/6 (266) -> 4/6 (269) gear for 220x Heroic Dawn Crests (prioritize rings / trinkets or set pieces you plan to keep long-term).",
            "Tip: if you're lucky enough to get Myth gear in raid, you can upgrade it 2 times (simply adjust the tips until it balances out again).",
            "Crests spent: 220/220 Heroic Dawn Crests and 0/100 Mythic Dawn Crests.",
            "Estimated gear level (based on RNG): 4x 266, 11x 269"
        }
    },
    {
        title = "Week 3 (Apr 1 - 7)",
        objectives = {
            "Do not spend any Heroic Dawn Crests or Mythic Dawn Crests unless asked.",
            "Crests: reach the weekly cap for all your Crests.",
            "Great Vault: open it to get Myth 272+ gear. 2H weapons are excellent choices if you're lucky. Only upgrade it after reading the instruction below.",
            "Crafting: unless you got a 2H Myth weapon in raid or from the Great Vault, craft a 2H Myth 5/5 (285) weapon for 60x Mythic Dawn Crests, unless your class Discord strongly advises against it.",
            "Class Set: if you don't have your 4-piece bonus (4p) yet, use the Raids tool (LFR) to get the missing pieces.",
            "Mythic+ (Season 1): complete +10 dungeons (minimum) to fill your Great Vault slots and accumulate your various Crests.",
            "Raid: complete Normal, Heroic and Mythic mode.",
            "Heroic Tier: upgrade two of your Hero 4/6 (269) -> 6/6 (276) gear for 80x Heroic Dawn Crests. Keep 20x Heroic Dawn Crests for the next step.",
            "Myth Tier: if your Great Vault gear is Myth 1/6 (272), first upgrade its Hero equivalent to 6/6 (276) for 20x Heroic Dawn Crests. Then upgrade your Myth 1/6 (272) -> 6/6 (289) for 80x Mythic Dawn Crests.",
            "Second Myth: if you have a second Myth gear piece, wait for upgrade advice next week.",
            "Crests spent: 320/320 Heroic Dawn Crests and 160/320 Mythic Dawn Crests.",
            "Estimated gear level (based on RNG): 3x 266, 8x 269, 2x 276, 1x 285, 1x 289"
        }
    },
    {
        title = "Week 4 (Apr 8 - 14)",
        objectives = {
            "Do not spend any Heroic Dawn Crests or Mythic Dawn Crests unless asked.",
            "Crests: reach the weekly cap for all your Crests.",
            "Great Vault: open it to get Myth 272+ gear.",
            "Mythic+ (Season 1): complete +10 dungeons (minimum) to fill your Great Vault slots and accumulate your various Crests.",
            "Assumption: we assume you obtained Myth gear (2/6, ilvl 276).",
            "Heroic Tier: upgrade two of your Hero 4/6 (269) -> 6/6 (276) gear for 80x Heroic Dawn Crests. Keep 20x Heroic Dawn Crests for the next step.",
            "Myth Tier: if your Great Vault gear is Myth 1/6 (272), first upgrade its Hero equivalent to 6/6 (276) for 20x Heroic Dawn Crests. Then upgrade your Myth 1/6 (272) -> 6/6 (289) for 80x Mythic Dawn Crests.",
            "Myth Tier (Raid): upgrade the raid piece from rank 2/6 (276) to 6/6 (289) for 80x Mythic Dawn Crests.",
            "Crests spent: 420/420 Heroic Dawn Crests and 320/420 Mythic Dawn Crests.",
            "Estimated gear level (based on RNG): 2x 266, 5x 269, 4x 276, 1x 285, 3x 289"
        }
    },
    {
        title = "Week 5 (Apr 15 - 21)",
        objectives = {
            "Do not spend any Heroic Dawn Crests or Mythic Dawn Crests unless asked.",
            "Crests: reach the weekly cap for all your Crests.",
            "Great Vault: open it to get Myth 272+ gear.",
            "Mythic+ (Season 1): complete +10 dungeons (minimum) to fill your Great Vault slots and accumulate your various Crests.",
            "Crafting: craft your second Myth 5/5 (285) gear for 80x Mythic Dawn Crests. If possible, prioritize a slot where you already have Hero gear.",
            "Heroic Tier: upgrade two of your Hero 4/6 (269) -> 6/6 (276) gear for 80x Heroic Dawn Crests. Keep 20x Heroic Dawn Crests for the next step.",
            "Myth Tier: if your Great Vault gear is Myth 1/6 (272), first upgrade its Hero equivalent to 6/6 (276) for 20x Heroic Dawn Crests. Then upgrade your Myth 1/6 (272) -> 6/6 (289) for 80x Mythic Dawn Crests.",
            "Crests spent: 520/520 Heroic Dawn Crests and 480/480 Mythic Dawn Crests.",
            "Estimated gear level (based on RNG): 1x 266, 2x 269, 6x 276, 2x 285, 4x 289"
        }
    },
    {
        title = "Week 6 (Apr 22 - 28)",
        objectives = {
            "Do not spend any Heroic Dawn Crests or Mythic Dawn Crests unless asked.",
            "Crests: reach the weekly cap for all your Crests.",
            "Great Vault: open it to get Myth 272+ gear.",
            "Mythic+ (Season 1): complete +12 dungeons (minimum) to fill your Great Vault slots and accumulate your various Crests.",
            "Assumption: we assume you obtained 1 Myth 2/6 (276) piece.",
            "Heroic Tier: upgrade one of your Hero 4/6 (269) -> 6/6 (276) gear for 40x Heroic Dawn Crests.",
            "Myth Tier: if your Great Vault gear is Myth 1/6 (272), first upgrade its Hero equivalent to 6/6 (276) for 20x Heroic Dawn Crests. Then upgrade your Myth 1/6 (272) -> 6/6 (289) for 80x Mythic Dawn Crests.",
            "Myth Tier (Raid): upgrade Myth 2/6 (276) -> 5/6 (285) gear for 60x Mythic Dawn Crests.",
            "Crests spent: 560/620 Heroic Dawn Crests and 620/620 Mythic Dawn Crests.",
            "Estimated gear level (based on RNG): 7x 276, 2x 285, 1x 285, 5x 289."
        }
    },
    {
        title = "Week 7+ (Apr 29 and after)",
        objectives = {
            "Crafting: do not craft any item in a slot if you can get gear higher than Myth 1/6 (272) from your Great Vault.",
            "Upgrade priority: upgrade your Myth gear as you obtain it. Prioritize a full upgrade to 6/6 (289) to benefit from the significant +4 item level jump.",
            "Weapon optimization: start considering crafting an off-hand (OH) at some point if you want to carry a main-hand (MH) 6/6 while keeping an embellishment on your weapon."
        }
    }
}

L.en.mplus_csv = [[
Source,Quantities
M0,TBA
LFR Raid,TBA
Normal Raid,TBA
Heroic Raid,TBA
Mythic Raid,TBA
Mythic +2,10 x Heroic Dawn Crest
Delve Tier 2,TBA
Mythic +3,12 x Heroic Dawn Crest
Delve Tier 3,TBA
Mythic +4,14 x Heroic Dawn Crest
Delve Tier 4,TBA
Mythic +5,16 x Heroic Dawn Crest
Delve Tier 5,TBA
Mythic +6,18 x Heroic Dawn Crest
Delve Tier 6,TBA
Mythic +7,10 x Mythic Dawn Crest
Delve Tier 7,TBA
Mythic +8,12 x Mythic Dawn Crest
Delve Tier 8,TBA
Mythic +9,14 x Mythic Dawn Crest
Delve Tier 9,TBA
Mythic +10,16 x Mythic Dawn Crest
Delve Tier 10,TBA
Mythic +11,18 x Mythic Dawn Crest
Delve Tier 11,TBA
Mythic +12,20 x Mythic Dawn Crest
]]

L.en.planning_csv = [[
Week,Feb 27,Mar 4,Mar 18,Mar 25,Apr 1,Apr 8
Expedition,X,,,,,
Prey,Normal,Hard,Nightmare,,,
World Boss,,,X,,,
"Arena & BG",,,"Honor (276)
War Mode (276)
Conquest (289)",,,
"Bountiful Delve","Tier 1-2-3","Tier 4-5-6-7","Tier 8-9-10-11
Bountiful",,,
Dungeon,"Normal
Heroic
(Off-season)","M0
(Off-season)","M0
(Pre-Season)","M+
(Season 1)",,
Raid,,,"Dream Rift
Void Arrow
(LFR Wing 1 - Normal - Heroic)","Dream Rift
(Mythic)
Void Arrow
(Story, LFR Wing 2 - Mythic)","Dream Rift
(Mythic)
Void Arrow
(LFR Wing 3)
March of Quel'Danas
(Normal, Heroic, Mythic)","March of Quel'Danas
(Story, LFR)"
]]

L.ColorblindModes = {
    "none", "protanopia", "protanomaly",
    "deuteranopia", "deuteranomaly",
    "tritanopia", "tritanomaly",
}

L.ColorPalettes = {
    none = {
        adventurer = "7CFFB8",
        veteran    = "7FB8FF",
        champion   = "C0A0FF",
        heroic     = "FFB86A",
        mythic     = "FFE07A",
        spark      = "FFD100",
        prefix     = "ff3b3b",
    },
    protanopia = {
        adventurer = "009E73",
        veteran    = "56B4E9",
        champion   = "CC79A7",
        heroic     = "E69F00",
        mythic     = "FFFFFF",
        spark      = "D4AA00",
        prefix     = "F0E442",
    },
    protanomaly = {
        adventurer = "60D8B0",
        veteran    = "7FB8FF",
        champion   = "CC90D0",
        heroic     = "FFCC44",
        mythic     = "FFF2A0",
        spark      = "FFD100",
        prefix     = "FF7733",
    },
    deuteranopia = {
        adventurer = "0072B2",
        veteran    = "56B4E9",
        champion   = "CC79A7",
        heroic     = "F0E442",
        mythic     = "FFFFFF",
        spark      = "D4AA00",
        prefix     = "D55E00",
    },
    deuteranomaly = {
        adventurer = "40C0B0",
        veteran    = "7FB8FF",
        champion   = "CC90D0",
        heroic     = "FFD060",
        mythic     = "FFF5B0",
        spark      = "FFD100",
        prefix     = "FF5522",
    },
    tritanopia = {
        adventurer = "33BB77",
        veteran    = "FF80A0",
        champion   = "D0A0D0",
        heroic     = "FF8844",
        mythic     = "E8E8E8",
        spark      = "FF9966",
        prefix     = "ff3b3b",
    },
    tritanomaly = {
        adventurer = "60D8A0",
        veteran    = "A098FF",
        champion   = "C8A0E0",
        heroic     = "FFB86A",
        mythic     = "FFD8A0",
        spark      = "FFC060",
        prefix     = "ff3b3b",
    },
}

L._colorblindMode = "none"

function L.SetColorblindMode(mode)
    L._colorblindMode = mode or "none"
end

function L.GetColorblindMode()
    return L._colorblindMode or "none"
end

function L.C(key)
    local mode = L._colorblindMode or "none"
    local palette = L.ColorPalettes[mode] or L.ColorPalettes.none
    return palette[key] or L.ColorPalettes.none[key] or "FFFFFF"
end