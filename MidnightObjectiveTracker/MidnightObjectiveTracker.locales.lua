local L = {}
_G.MidnightL = L

local currentLocale = "fr"

function L.GetLocale()
    return currentLocale
end

function L.Init()
    local gameLocale = GetLocale and GetLocale() or "frFR"
    if gameLocale == "enUS" or gameLocale == "enGB" then
        currentLocale = "en"
    else
        currentLocale = "fr"
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
L.fr.crests = "Ecus"
L.fr.resources = "Ressources"
L.fr.discord_desc = "Copie l'adresse du serveur Discord de la guilde dont je suis membre (nous recherchons d'ailleurs nos derniers membres pour notre roster Mythique)"
L.fr.twitch_desc = "Copie l'URL de ma chaîne Twitch, je live généralement du mardi au vendredi dès 18h."
L.fr.resources_desc = "Copie l'URL des ressources ayant permis de créer ce guide, les données proviennent de différentes sources comme : Larias, WoW Head, Icy Vein, Judge Hype ou Blizz Spirit, elles ont été entrecroisées pour créer un guide de progression cohérent et optimisé."
L.fr.x_desc = "Copie l'URL de mon compte X (Twitter), si des questions il y a."
L.fr.reset_checks = "Reset"
L.fr.reset_checks_desc = "Réinitialise toutes les cases cochées du suivi d'objectifs."
L.fr.ilvl_label = "Niveau d'objet"
L.fr.ilvl_no_data = "N/A"
L.fr.slash_msg = "|cffFFD100[Midnight]|r Tapez /som pour ouvrir le suivi d'objectifs."
L.fr.no_data = "Aucune donnée."
L.fr.no_csv_data = "Aucune donnée importée depuis le CSV."
L.fr.csv_error = "[Midnight] Erreur lors du parsing du CSV Planning : "

L.fr.mplus_title = "Ecus"
L.fr.planning_title = "Planning"

L.fr.summaryPatterns = {
    "^Ecus dépensés%s*:",
    "^Niveau d['%%\"]?équipement estimé%s*%(selon RNG%)%s*:"
}

L.fr.menuLabels = {
    "27/02. - 03/03",
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
            "Ne dépensez aucun Ecu sauf si demandé.",
            "XP : mettez à jour les personnages au niveau 90 que vous souhaitez jouer pendant Midnight.",
            "Renom : utilisez le bonus de la « Foire de Sombrelune » pour monter les renoms dès dimanche grâce aux quêtes secondaires.",
            "Si disponible : accomplissez les expéditions hebdomadaires dès leur apparition, offrant de l'équipement Aventurier 1/6 (220) et 2/6 (224).",
            "Si disponible : accomplissez les Traques en mode normal, offrant de l'équipement Aventurier 1/6 (220)."
        }
    },
    {
        title = "Hors-saison - Semaine 1 (4 - 10 mars)",
        objectives = {
            "Ne dépensez aucun Ecu sauf si demandé.",
            "Ecus : atteignez le cap hebdomadaire de tous vos Ecus.",
            "Renom : atteignez le rang 7 du renom « Singularité » pour un bijou Champion 1/6 (246).",
            "Renom : atteignez le rang 8 du renom « Hara'ti » pour une ceinture Champion 1/6 (246).",
            "Renom : atteignez le rang 9 du renom « Cour de Lune-d'Argent » pour un casque Champion 1/6 (246).",
            "Renom : atteignez le rang 9 du renom « Tribu des Amani » pour obtenir un collier Champion 1/6 (246).",
            "Gouffre : débloquez le palier 3 (les paliers supérieurs étant bloqués jusqu'au 18 mars).",
            "Expédition : accomplissez des expéditions offrant de préférence des améliorations d'équipement.",
            "Traque : accomplissez des Traques en mode normal, offrant de l'équipement Aventurier 1/6 (220).",
            "Mythique 0 (hors-saison) : accomplissez tous les donjons en Mythique 0 (hors-saison), offrant de l'équipement Veteran 3/6 (240) (n'améliorez pas l'équipement obtenu).",
            "Héroïque (hors-saison) : accomplissez tous les donjons en Héroïque (hors-saison), offrant de l'équipement Aventurier 2/6 (224) (n'améliorez pas l'équipement obtenu)."
        }
    },
    {
        title = "Hors-saison - Semaine 2 (11 - 17 mars)",
        objectives = {
            "Ne dépensez aucun Ecu sauf si demandé.",
            "Ecus : atteignez le cap hebdomadaire de tous vos Ecus.",
            "Gouffre : débloquez le palier 3 (les paliers supérieurs étant bloqués jusqu'au 18 mars).",
            "Expédition : accomplissez des expéditions offrant de préférence des améliorations d'équipement.",
            "Traque : accomplissez des Traques en mode normal, offrant de l'équipement Aventurier 1/6 (220).",
            "Mythique 0 (hors-saison) : accomplissez tous les donjons en Mythique 0 (hors-saison), offrant de l'équipement Veteran 3/6 (240) (n'améliorez pas l'équipement obtenu).",
            "Artisanat : préparez les composants d'artisanat si vous raidez le 18 mars."
        }
    },
    {
        title = "Saison 1 - Semaine 1 (18 - 24 mars)",
        objectives = {
            "Ne dépensez aucun Ecus de l'aube héroïque et Ecus de l'aube mythique sauf si demandé.",
            "Ecus : atteignez le cap hebdomadaire de tous vos Ecus.",
            "Set de classe : utilisez l'outil Raids (LFR) pour obtenir des pièces de sets.",
            "Mythique 0 (Pré-saison): réalisez un World Tour des donjons Mythique 0 (Pré-saison), offrant désormais de l'équipement Champion 2/6 (250).",
            "Boss monde : tuez le Boss monde pour obtenir de l'équipement Champion 2/6 (250).",
            "Traque : accomplissez des Traques en mode cauchemar, offrant de l'équipement Champion 1/6 (246).",
            "JcJ : faites la quête JcJ pour obtenir le collier ou l'anneau Hero garanti (si disponible, car disparu de la bêta recemment).",
            "Gouffre : accomplissez des Gouffres abondants (palier 11) avec clés et carte pour obtenir de l'équipement Champion 2/6 (250).",
            "Artisanat : fabriquez 2 équipements Veteran 5/5 (246) en utilisant 80x Ecu de l'aube Veteran chacun avec 2 embellissements (Priorisez les Poignets, Ceinture et Bottes).",
            "Raid : accomplissez le mode Normal et Héroïque.",
            "Optimisation : dépensez tous les Ecus de l'aube Veteran et les Ecus de l'aube de Champion avant d'entrer en raid.",
            "Ecus dépensés : 0/100 Ecus de l'aube héroïque et 0/100 Ecus de l'aube mythique."
        }
    },
    {
        title = "Semaine 2 (25 - 31 mars)",
        objectives = {
            "Ne dépensez aucun Ecus de l'aube héroïque et Ecus de l'aube mythique sauf si demandé.",
            "Ecus : atteignez le cap hebdomadaire de tous vos Ecus.",
            "Artisanat : si votre discord de classe le recommande, utilisez 1 étincelle pour fabriquer un Mythe 1/5 (272) avec embellissement (ce cas de figure sera plutôt rare, donc adaptez-vous pour la suite du guide).",
            "Set de classe : utilisez l'outil Raids (LFR) pour obtenir des pièces de sets.",
            "Boss monde : tuez le Boss monde pour obtenir de l'équipement Champion 2/6 (250).",
            "Traque : accomplissez des Traques en mode cauchemar, offrant de l'équipement Champion 1/6 (246).",
            "Gouffre : accomplissez des Gouffres abondants (palier 11) avec clés et carte pour obtenir de l'équipement Champion 2/6 (250).",
            "Mythique + (Saison 1) : accomplissez des donjons +10 (minimum) pour obtenir de l'équipement Hero 3/6 (266), si c'est trop difficile, faites du +8 pour obtenir de l'équipement Hero 2/6 (263).",
            "Raid : accomplissez le mode Normal et Héroïque avant de commencer la progression Mythique.",
            "Raid Mythique : améliorez 11 équipements Hero 3/6 (266) -> 4/6 (269) contre 220x Ecus de l'aube héroïque (priorisez les bagues / bijoux ou pièce de set que vous comptez garder longtemps).",
            "Astuce : si vous avez la chance d'obtenir de l'équipement Mythe en raid, vous pouvez l'améliorer 2 fois (ajustez simplement les conseils jusqu'à ce que cela s'équilibre à nouveau).",
            "Ecus dépensés : 220/220 Ecus de l'aube héroïque et 0/100 Ecus de l'aube mythique.",
            "Niveau d'équipement estimé (selon RNG) : 4x 266, 11x 269"
        }
    },
    {
        title = "Semaine 3 (1 - 7 avril)",
        objectives = {
            "Ne dépensez aucun Ecus de l'aube héroïque et Ecus de l'aube mythique sauf si demandé.",
            "Ecus : atteignez le cap hebdomadaire de tous vos Ecus.",
            "Grande Chambre Forte : ouvrez là pour obtenir un équipement Mythe 272+. Les armes à 2H sont d'excellents choix si vous avez de la chance. Améliorez là seulement après avoir lu l'instruction ci-dessous.",
            "Artisanat : à moins d'avoir eu une arme 2H Mythe en raid ou dans la Grande Chambre forte, fabriquez une arme 2H Mythe 5/5 (285) contre 60x Ecus de l'aube mythique, sauf si votre Discord de classe le déconseille fortement.",
            "Set de classe : si vous n'avez pas encore votre bonus 4-pièces (4p), utilisez l'outil Raids (LFR) pour récupérer les pièces manquantes.",
            "Mythique + (Saison 1) : accomplissez des donjons +10 (minimum) pour remplir les emplacements de votre Grande Chambre Forte et accumuler vos différents Ecus.",
            "Raid : accomplissez le mode Normal, Héroique et Mythique.",
            "Palier Héroïque : améliorez deux de vos équipements Hero 4/6 (269) -> 6/6 (276) contre 80x Ecus de l'aube héroïque. Gardez 20x Ecus de l'aube héroïque pour l'étape suivante.",
            "Palier Mythe : si l'équipement de votre Grande Chambre Forte est un équipement Mythe 1/6 (272), améliorez d'abord son équivalent Hero 6/6 (276) contre 20x Ecus de l'aube héroïque. Améliorez ensuite votre équipement Mythe 1/6 (272) -> 6/6 (289) contre 80x Ecus de l'aube mythique.",
            "Second Mythe : si vous possédez un second équipement Mythe, attendez les conseils d'amélioration de la semaine suivante.",
            "Ecus dépensés : 320/320 Ecus de l'aube héroïque et 160/320 Ecus de l'aube mythique.",
            "Niveau d'équipement estimé (selon RNG) : 3x 266, 8x 269, 2x 276, 1x 285, 1x 289"
        }
    },
    {
        title = "Semaine 4 (8 - 14 avril)",
        objectives = {
            "Ne dépensez aucun Ecus de l'aube héroïque et Ecus de l'aube mythique sauf si demandé.",
            "Ecus : atteignez le cap hebdomadaire de tous vos Ecus.",
            "Grande Chambre Forte : ouvrez là pour obtenir un équipement Mythe 272+",
            "Mythique + (Saison 1) : ccomplissez des donjons +10 (minimum) pour remplir les emplacements de votre Grande Chambre Forte et accumuler vos différents Ecus.",
            "Hypothèse : nous partons du principe que vous avez obtenu un équipement Mythe (2/6, ilvl 276).",
            "Palier Héroïque : améliorez deux de vos équipements Hero 4/6 (269) -> 6/6 (276) contre 80x Ecus de l'aube héroïque. Gardez 20x Ecus de l'aube héroïque pour l'étape suivante.",
            "Palier Mythe : si l'équipement de votre Grande Chambre Forte est un équipement Mythe 1/6 (272), améliorez d'abord son équivalent Hero 6/6 (276) contre 20x Ecus de l'aube héroïque. Améliorez ensuite votre équipement Mythe 1/6 (272) -> 6/6 (289) contre 80x Ecus de l'aube mythique.",
            "Palier Mythe (Raid) : améliorez la pièce obtenue en raid du rang 2/6 (276) vers le 6/6 (289) contre 80x Ecus de l'aube mythique.",
            "Ecus dépensés : 420/420 Ecus de l'aube héroïque et 320/420 Ecus de l'aube mythique",
            "Niveau d'équipement estimé (selon RNG) : 2x 266, 5x 269, 4x 276, 1x 285, 3x 289"
        }
    },
    {
        title = "Semaine 5 (15 - 21 avril)",
        objectives = {
            "Ne dépensez aucun Ecus de l'aube héroïque et Ecus de l'aube mythique sauf si demandé.",
            "Ecus : atteignez le cap hebdomadaire de tous vos Ecus.",
            "Grande Chambre Forte : ouvrez là pour obtenir un équipement Mythe 272+",
            "Mythique + (Saison 1) : accomplissez des donjons +10 (minimum) pour remplir les emplacements de votre Grande Chambre Forte et accumuler vos différents Ecus.",
            "Artisanat : fabriquez votre second équipement Mythe 5/5 (285) contre 80x Ecus de l'aube mythique. Privilégiez si possible un emplacement où vous possédez déjà un équipement Héro.",
            "Palier Héroïque : améliorez deux de vos équipements Hero 4/6 (269) -> 6/6 (276) contre 80x Ecus de l'aube héroïque. Gardez 20x Ecus de l'aube héroïque pour l'étape suivante",
            "Palier Mythe : si l'équipement de votre Grande Chambre Forte est un équipement Mythe 1/6 (272), améliorez d'abord son équivalent Hero 6/6 (276) contre 20x Ecus de l'aube héroïque. Améliorez ensuite votre équipement Mythe 1/6 (272) -> 6/6 (289) pour 80x Ecus de l'aube mythique.",
            "Ecus dépensés : 520/520 Ecus de l'aube héroïque et 480/480 Ecus de l'aube mythique.",
            "Niveau d'équipement estimé (selon RNG) : 1x 266, 2x 269, 6x 276, 2x 285, 4x 289"
        }
    },
    {
        title = "Semaine 6 (22 - 28 avril)",
        objectives = {
            "Ne dépensez aucun Ecus de l'aube héroïque et Ecus de l'aube mythique sauf si demandé.",
            "Ecus : atteignez le cap hebdomadaire de tous vos Ecus.",
            "Grande Chambre Forte : ouvrez là pour obtenir un équipement Mythe 272+",
            "Mythique + (Saison 1) : accomplissez des donjons +12 (minimum) pour remplir les emplacements de votre Grande Chambre Forte et accumuler vos différents Ecus.",
            "Hypothèse : nous partons du principe que vous avez obtenu 1 pièce Mythe 2/6 (276)",
            "Palier Héroïque : améliorez un de vos équipements Hero 4/6 (269) -> 6/6 (276) contre 40x Ecus de l'aube héroïque.",
            "Palier Mythe : si l'équipement de votre Grande Chambre Forte est un Mythe 1/6 (272), améliorez d'abord son équivalent Hero 6/6 (276) contre 20x Ecus de l'aube héroïque. Améliorez ensuite votre Mythe 1/6 (272) -> 6/6 (289) pour 80x Ecus de l'aube mythique.",
            "Palier Mythe (Raid) : améliorez l'équipement Mythe 2/6 (276) -> 5/6 (285) contre 60x Ecus de l'aube mythique",
            "Ecus dépensés : 560/620 Ecus de l'aube héroïque et 620/620 Ecus de l'aube mythique.",
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
M0,TBA
Raid LFR,TBA
Raid Normal,TBA
Raid Héroïque,TBA
Raid Mythique,TBA
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
Gouffre Palier 11,TBA
]]

L.fr.planning_csv = [[
,Quêtes,Expédition,"Boss Monde",Artisanat,"Traque", Traque Vault,Arène & BG,Gouffre Abondant,Gouffre Prime,Gouffre Vault,Donjon,Donjon Vault,Raid & Vault
207,(3 mars),,,,,,,,,,,,
210,,,,,,,,,,,,,
214,,,,,,,,,,,"Normal
(3 mars)",,
217,,,,,,,"Honneur (276)
(18 mars)",,,,,,
220,,(3 mars),,"Ecu de l'aube d'aventure 
(Qualité 1)","Normal
(3 mars)",,,"Palier 1
(18 mars)",,,,,
224,,,,"Ecu de l'aube d'aventure 
(Qualité 2)",,,,Palier 2,,,"Héroique (hors saison)
(3 mars)",,
227,,,,"Ecu de l'aube d'aventure 
(Qualité 3)",,,,Palier 3,,,,,
230,,,,"Ecu de l'aube d'aventure 
(Qualité 4)",,,,Palier 4,,,"Héroique (Pre Saison)
(18 mars)",,
233,,,,"Ecu de l'aube d'aventure 
(Qualité 5)",,,,,,,,,
237,,,,,,,,,,,,,
233,,,,"Ecu de l'aube vétéran 
(Qualité 1)","Difficile
(18 mars)","Normal
(3 mars)",,Palier 5,,,,,"LFR
Aile 1 (18 mars)
Aile 2 (25 mars)
Aile 3 (01 avril)"
237,,,,"Ecu de l'aube vétéran 
(Qualité 2)",,,,Palier 6,"Palier 4
(18 mars)",,,,
240,,,,"Ecu de l'aube vétéran 
(Qualité 3)",,,,,,,"Mythique 0 (Pre Saison)
(18 mars)",,
243,,,,"Ecu de l'aube vétéran 
(Qualité 4)",,,,,Palier 5,,,"Héroique (hors saison)
(3 mars)",
246,,,,"Ecu de l'aube vétéran 
(Qualité 5)",,,"Mode guerre (276)
(18 mars)",,,,,,
250,,,,,,,,,,,,,
246,,,,"Etincelle de radiance
(Qualité 1)","Cauchemar
(18 mars)","Difficile
(18 mars)","Conquête (289)
(18 mars)",Palier 7,Palier 6, Palier 5,"Mythique (saison 1)
(25 mars)",,"Normal
(18 mars)"
249,,,,"Etincelle de radiance
(Qualité 2)",,,,,,,,,,
250,,,(18 mars),,,,,Palier 8 - 11,Palier 7,,Mythique + (+2-3),,
252,,,,"Etincelle de radiance
(Qualité 3)",,,,,,,,,,
253,,,,,,,,,,Palier  6,Mythique + (+4),,
255,,,,"Etincelle de radiance
(Qualité 4)",,,,,,,,,,
256,,,,,,,,,,Palier 7,Mythique + (+5),"Mythique 0 (Pre Saison)
(18 mars)",
259,,,,"Etincelle de radiance
(Qualité 5)",,,,,,,,,,
263,,,,,,,,,,,,
259,,,,"Etincelle de radiance + Ecu de l'aube héroïque
(Qualité 1)",,"Cauchemar
(18 mars)",,,Palier 8 - 11,Palier 8 - 11,Mythique + (+6-7),"Mythique + (+2-3)
(25 mars)","Héroique
(18 mars)"
262,,,,"Etincelle de radiance + Ecu de l'aube héroïque
(Qualité 2)",,,,,,,,,,
263,,,,,,,,,,,Mythique + (+8-9),Mythique + (+4-5),
265,,,,"Etincelle de radiance + Ecu de l'aube héroïque
(Qualité 3)",,,,,,,,,,
266,,,,,,,,,,,Mythique + (+10 et +),Mythique + (+6),
268,,,,"Etincelle de radiance + Ecu de l'aube héroïque
(Qualité 4)",,,,,,,,,,
269,,,,,,,,,,,,Mythique + (+7-9),
272,,,,"Etincelle de radiance + Ecu de l'aube héroïque
(Qualité 5)",,,,,,,,,,
276,,,,,,,,,,,,,
272,,,,"Etincelle de radiance + Ecu de l'aube mythique
(Qualité 1)",,,,,,,,Mythique + (+10 et +),"Mythique
Raid 1 & 2 (25 mars)
Raid 3 (01 avril)"
275,,,,"Etincelle de radiance + Ecu de l'aube mythique
(Qualité 2)",,,,,,,,,,
276,,,,,,,,,,,,,
278,,,,"Etincelle de radiance + Ecu de l'aube mythique
(Qualité 3)",,,,,,,,,,
279,,,,,,,,,,,,,
282,,,,"Etincelle de radiance + Ecu de l'aube mythique
(Qualité 4)",,,,,,,,,,
282,,,,,,,,,,,,,
285,,,,"Etincelle de radiance + Ecu de l'aube mythique
(Qualité 5)",,,,,,,,,,
289,,,,,,,,,,,,,
]]

L.en = {}

L.en.title = "Midnight Objective Tracker"
L.en.planning = "Planning"
L.en.crests = "Crests"
L.en.resources = "Resources"
L.en.discord_desc = "Copies the Discord server address of the guild I'm a member of (we are also looking for our last members for our Mythic roster)"
L.en.twitch_desc = "Copies my Twitch channel URL, I usually stream Tuesday to Friday from 6PM (CET)."
L.en.resources_desc = "Copies the URL of resources used to create this guide, data comes from various sources such as: Larias, WoW Head, Icy Veins, Judge Hype or Blizz Spirit, cross-referenced to create a coherent and optimized progression guide."
L.en.x_desc = "Copies my X (Twitter) account URL, if you have any questions."
L.en.reset_checks = "Reset"
L.en.reset_checks_desc = "Resets all checked objectives in the tracker."
L.en.ilvl_label = "Item Level"
L.en.ilvl_no_data = "N/A"
L.en.slash_msg = "|cffFFD100[Midnight]|r Type /som to open the objective tracker."
L.en.no_data = "No data."
L.en.no_csv_data = "No data imported from CSV."
L.en.csv_error = "[Midnight] Error parsing Planning CSV: "

L.en.mplus_title = "Crests"
L.en.planning_title = "Planning"

L.en.summaryPatterns = {
    "^Crests spent%s*:",
    "^Estimated gear level%s*%(based on RNG%)%s*:"
}

L.en.menuLabels = {
    "Feb 27 - Mar 2",
    "Mar 3 - 10",
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
        title = "Early Access (Feb 27 - Mar 2)",
        objectives = {
            "Do not spend any Crest unless asked.",
            "XP: level up the characters to 90 that you want to play during Midnight.",
            "Renown: use the Darkmoon Faire bonus to level up reputations starting Sunday through side quests.",
            "If available: complete weekly expeditions as they appear, offering Adventurer 1/6 (220) and 2/6 (224) gear.",
            "If available: complete Preys in Normal mode, offering Adventurer 1/6 (220) gear."
        }
    },
    {
        title = "Off-season - Week 1 (Mar 3 - 10)",
        objectives = {
            "Do not spend any Crest unless asked.",
            "Crests: reach the weekly cap for all your Crests.",
            "Renown: reach rank 7 of 'The Singularity' renown for a Champion 1/6 (246) trinket.",
            "Renown: reach rank 8 of 'Hara'ti' renown for a Champion 1/6 (246) belt.",
            "Renown: reach rank 9 of 'Silvermoon Court' renown for a Champion 1/6 (246) helmet.",
            "Renown: reach rank 9 of 'Amani Tribe' renown for a Champion 1/6 (246) necklace.",
            "Delve: unlock tier 3 (higher tiers are locked until March 18).",
            "Expedition: complete expeditions that preferably offer gear upgrades.",
            "Prey: complete Preys in Normal mode, offering Adventurer 1/6 (220) gear.",
            "Mythic 0 (off-season): complete all Mythic 0 (off-season) dungeons, offering Veteran 3/6 (240) gear (do not upgrade obtained gear).",
            "Heroic (off-season): complete all Heroic (off-season) dungeons, offering Adventurer 2/6 (224) gear (do not upgrade obtained gear)."
        }
    },
    {
        title = "Off-season - Week 2 (Mar 11 - 17)",
        objectives = {
            "Do not spend any Crest unless asked.",
            "Crests: reach the weekly cap for all your Crests.",
            "Delve: unlock tier 3 (higher tiers are locked until March 18).",
            "Expedition: complete expeditions that preferably offer gear upgrades.",
            "Prey: complete Preys in Normal mode, offering Adventurer 1/6 (220) gear.",
            "Mythic 0 (off-season): complete all Mythic 0 (off-season) dungeons, offering Veteran 3/6 (240) gear (do not upgrade obtained gear).",
            "Crafting: prepare crafting materials if you plan to raid on March 18."
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
            "Prey: complete Preys in Nightmare mode, offering Champion 1/6 (246) gear.",
            "PvP: complete the PvP quest to get a guaranteed Hero necklace or ring (if available, as it recently disappeared from the beta).",
            "Delve: complete Bountiful Delves (tier 11) with keys and map for Champion 2/6 (250) gear.",
            "Crafting: craft 2 Veteran 5/5 (246) gear using 80x Veteran Dawn Crest each with 2 embellishments (Prioritize Wrists, Belt and Boots).",
            "Raid: complete Normal and Heroic mode.",
            "Optimization: spend all Veteran Dawn Crests and Champion Dawn Crests before entering the raid.",
            "Crests spent: 0/100 Heroic Dawn Crests and 0/100 Mythic Dawn Crests."
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
            "Prey: complete Preys in Nightmare mode, offering Champion 1/6 (246) gear.",
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
            "Assumption: we assume you obtained 1 Mythic loot piece (2/6, ilvl 276).",
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
Delve Tier 11,TBA
]]

L.en.planning_csv = [[
,Quests,Expedition,"World Boss",Crafting,"Prey",Prey Vault,Arena & BG,Bountiful Delve,Prime Delve,Delve Vault,Dungeon,Dungeon Vault,Raid & Vault
207,(Mar 3),,,,,,,,,,,,
210,,,,,,,,,,,,,
214,,,,,,,,,,,"Normal
(Mar 3)",,
217,,,,,,,"Honor (276)
(Mar 18)",,,,,,
220,,(Mar 3),,"Adventurer Dawn Crest
(Quality 1)","Normal
(Mar 3)",,,"Tier 1
(Mar 18)",,,,,
224,,,,"Adventurer Dawn Crest
(Quality 2)",,,,Tier 2,,,"Heroic (off-season)
(Mar 3)",,
227,,,,"Adventurer Dawn Crest
(Quality 3)",,,,Tier 3,,,,,
230,,,,"Adventurer Dawn Crest
(Quality 4)",,,,Tier 4,,,"Heroic (Pre-Season)
(Mar 18)",,
233,,,,"Adventurer Dawn Crest
(Quality 5)",,,,,,,,,
237,,,,,,,,,,,,,
233,,,,"Veteran Dawn Crest
(Quality 1)","Hard
(Mar 18)","Normal
(Mar 3)",,Tier 5,,,,,"LFR
Wing 1 (Mar 18)
Wing 2 (Mar 25)
Wing 3 (Apr 1)"
237,,,,"Veteran Dawn Crest
(Quality 2)",,,,Tier 6,"Tier 4
(Mar 18)",,,,
240,,,,"Veteran Dawn Crest
(Quality 3)",,,,,,,"Mythic 0 (Pre-Season)
(Mar 18)",,
243,,,,"Veteran Dawn Crest
(Quality 4)",,,,,Tier 5,,,"Heroic (off-season)
(Mar 3)",
246,,,,"Veteran Dawn Crest
(Quality 5)",,,"War Mode (276)
(Mar 18)",,,,,,
250,,,,,,,,,,,,,
246,,,,"Spark of Radiance
(Quality 1)","Nightmare
(Mar 18)","Hard
(Mar 18)","Conquest (289)
(Mar 18)",Tier 7,Tier 6,Tier 5,"Mythic (Season 1)
(Mar 25)",,"Normal
(Mar 18)"
249,,,,"Spark of Radiance
(Quality 2)",,,,,,,,,,
250,,,(Mar 18),,,,,Tier 8 - 11,Tier 7,,Mythic + (+2-3),,
252,,,,"Spark of Radiance
(Quality 3)",,,,,,,,,,
253,,,,,,,,,,Tier 6,Mythic + (+4),,
255,,,,"Spark of Radiance
(Quality 4)",,,,,,,,,,
256,,,,,,,,,,Tier 7,Mythic + (+5),"Mythic 0 (Pre-Season)
(Mar 18)",
259,,,,"Spark of Radiance
(Quality 5)",,,,,,,,,,
263,,,,,,,,,,,,
259,,,,"Spark of Radiance + Heroic Dawn Crest
(Quality 1)",,"Nightmare
(Mar 18)",,,Tier 8 - 11,Tier 8 - 11,Mythic + (+6-7),"Mythic + (+2-3)
(Mar 25)","Heroic
(Mar 18)"
262,,,,"Spark of Radiance + Heroic Dawn Crest
(Quality 2)",,,,,,,,,,
263,,,,,,,,,,,Mythic + (+8-9),Mythic + (+4-5),
265,,,,"Spark of Radiance + Heroic Dawn Crest
(Quality 3)",,,,,,,,,,
266,,,,,,,,,,,Mythic + (+10+),Mythic + (+6),
268,,,,"Spark of Radiance + Heroic Dawn Crest
(Quality 4)",,,,,,,,,,
269,,,,,,,,,,,,Mythic + (+7-9),
272,,,,"Spark of Radiance + Heroic Dawn Crest
(Quality 5)",,,,,,,,,,
276,,,,,,,,,,,,,
272,,,,"Spark of Radiance + Mythic Dawn Crest
(Quality 1)",,,,,,,,Mythic + (+10+),"Mythic
Raid 1 & 2 (Mar 25)
Raid 3 (Apr 1)"
275,,,,"Spark of Radiance + Mythic Dawn Crest
(Quality 2)",,,,,,,,,,
276,,,,,,,,,,,,,
278,,,,"Spark of Radiance + Mythic Dawn Crest
(Quality 3)",,,,,,,,,,
279,,,,,,,,,,,,,
282,,,,"Spark of Radiance + Mythic Dawn Crest
(Quality 4)",,,,,,,,,,
282,,,,,,,,,,,,,
285,,,,"Spark of Radiance + Mythic Dawn Crest
(Quality 5)",,,,,,,,,,
289,,,,,,,,,,,,,
]]
