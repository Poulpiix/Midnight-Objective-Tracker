local addonName = ...
local Midnight = {}
_G["MidnightTracker"] = Midnight

MidnightTrackerDB = MidnightTrackerDB or {}

local weeks = {
    {
        title = "Accès Anticipé (27 fév. - 2 mars)",
        objectives = {
            "Ne dépensez aucun Écu sauf si demandé.",
            "XP : mettez à jour les personnages au niveau 90 que vous souhaitez jouer pendant Midnight.",
            "Renom : utilisez le bonus de la « Foire de Sombrelune » pour monter les renoms dès dimanche grâce aux quêtes secondaires.",
            "Si disponible : accomplissez les expéditions hebdomadaires dès leur apparition, offrant de l'équipement Aventurier 1/6 (220) et 2/6 (224).",
            "Si disponible : accomplissez les Traques en mode normal, offrant de l'équipement Aventurier 1/6 (220)."
        }
    },
    {
        title = "Hors-saison - Semaine 1 (3 - 10 mars)",
        objectives = {
            "Ne dépensez aucun Écu sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
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
            "Ne dépensez aucun Écu sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
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
            "Ne dépensez aucun Écu Héroïque et Mythique sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
            "Set de classe : utilisez l'outil Raids (LFR) pour obtenir des pièces de sets.",
            "Mythique 0 (Pré-saison): réalisez un World Tour des donjons Mythique 0 (Pré-saison), offrant désormais de l'équipement Champion 2/6 (250).",
            "Boss monde : tuez le Boss monde pour obtenir de l'équipement Champion 2/6 (250).",
            "Traque : accomplissez des Traques en mode cauchemar, offrant de l'équipement Champion 1/6 (246).",
            "JcJ : faites la quête JcJ pour obtenir le collier ou l'anneau Hero garanti (si disponible, car disparu de la bêta recemment).",
            "Gouffre : accomplissez des Gouffres abondants (palier 11) avec clés et carte pour obtenir de l'équipement Champion 2/6 (250).",
            "Artisanat : fabriquez 2 équipements Veteran 5/5 (246) en utilisant 80x Écu Veteran chacun avec 2 embellissements (Priorisez les Poignets, Ceinture et Bottes).",
            "Raid : accomplissez le mode Normal et Héroïque.",
            "Optimisation : dépensez tous les Écus Veteran et Champion avant d'entrer en raid.",
            "Écus dépensés : 0/100 Écus Héroïques et 0/100 Écus Mythiques."
        }
    },
    {
        title = "Semaine 2 (25 - 31 mars)",
        objectives = {
            "Ne dépensez aucun Écu Héroïque et Mythique sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
            "Artisanat : si votre discord de classe le recommande, utilisez 1 étincelle pour fabriquer un Mythe 1/5 (272) avec embellissement (ce cas de figure sera plutôt rare, donc adaptez-vous pour la suite du guide).",
            "Set de classe : utilisez l'outil Raids (LFR) pour obtenir des pièces de sets.",
            "Boss monde : tuez le Boss monde pour obtenir de l'équipement Champion 2/6 (250).",
            "Traque : accomplissez des Traques en mode cauchemar, offrant de l'équipement Champion 1/6 (246).",
            "Gouffre : accomplissez des Gouffres abondants (palier 11) avec clés et carte pour obtenir de l'équipement Champion 2/6 (250).",
            "Mythique + (Saison 1) : accomplissez des donjons +10 (minimum) pour obtenir de l'équipement Hero 3/6 (266), si c'est trop difficile, faites du +8 pour obtenir de l'équipement Hero 2/6 (263).",
            "Raid : accomplissez le mode Normal et Héroïque avant de commencer la progression Mythique.",
            "Raid Mythique : améliorez 11 équipements Hero 3/6 (266) -> 4/6 (269) contre 220x Écus Héroïques (priorisez les bagues / bijoux ou pièce de set que vous comptez garder longtemps).",
            "Astuce : si vous avez la chance d'obtenir de l'équipement Mythe en raid, vous pouvez l'améliorer 2 fois (ajustez simplement les conseils jusqu'à ce que cela s'équilibre à nouveau).",
            "Écus dépensés : 220/220 Écus Héroïques et 0/100 Écus Mythiques.",
            "Niveau d'équipement estimé (selon RNG) : 4x 266, 11x 269"
        }
    },
    {
        title = "Semaine 3 (1 - 7 avril)",
        objectives = {
            "Ne dépensez aucun Écu Héroïque et Mythique sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
            "Grande Chambre Forte : ouvrez là pour obtenir un équipement Mythe 272+. Les armes à 2H sont d'excellents choix si vous avez de la chance. Améliorez là seulement après avoir lu l'instruction ci-dessous.",
            "Artisanat : à moins d'avoir eu une arme 2H Mythe en raid ou dans la Grande Chambre forte, fabriquez une arme 2H Mythe 5/5 (285) contre 60x Écu Mythique, sauf si votre Discord de classe le déconseille fortement.",
            "Set de classe : si vous n'avez pas encore votre bonus 4-pièces (4p), utilisez l'outil Raids (LFR) pour récupérer les pièces manquantes.",
            "Mythique + (Saison 1) : accomplissez des donjons +10 (minimum) pour remplir les emplacements de votre Grande Chambre Forte et accumuler vos différents Écus.",
            "Raid : accomplissez le mode Normal, Héroique et Mythique.",
            "Palier Héroïque : améliorez deux de vos équipements Hero 4/6 (269) -> 6/6 (276) contre 80x Écus Héroïques. Gardez 20x Écus Héroïques pour l'étape suivante.",
            "Palier Mythe : si l'équipement de votre Grande Chambre Forte est un équipement Mythe 1/6 (272), améliorez d'abord son équivalent Hero 6/6 (276) contre 20x Écus Héroïques. Améliorez ensuite votre équipement Mythe 1/6 (272) -> 6/6 (289) contre 80x Écus Mythiques.",
            "Second Mythe : si vous possédez un second équipement Mythe, attendez les conseils d'amélioration de la semaine suivante.",
            "Écus dépensés : 320/320 Écus Héroïques et 160/320 Écus Mythiques.",
            "Niveau d'équipement estimé (selon RNG) : 3x 266, 8x 269, 2x 276, 1x 285, 1x 289"
        }
    },
    {
        title = "Semaine 4 (8 - 14 avril)",
        objectives = {
            "Ne dépensez aucun Écu Héroïque et Mythique sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
            "Grande Chambre Forte : ouvrez là pour obtenir un équipement Mythe 272+",
            "Mythique + (Saison 1) : ccomplissez des donjons +10 (minimum) pour remplir les emplacements de votre Grande Chambre Forte et accumuler vos différents Écus.",
            "Hypothèse : nous partons du principe que vous avez obtenu 1 pièce de butin Mythique (2/6, ilvl 276).",
            "Palier Héroïque : améliorez deux de vos équipements Hero 4/6 (269) -> 6/6 (276) contre 80x Écus Héroïques. Gardez 20x Écus Héroïques pour l'étape suivante.",
            "Palier Mythe : si l'équipement de votre Grande Chambre Forte est un équipement Mythe 1/6 (272), améliorez d'abord son équivalent Hero 6/6 (276) contre 20x Écus Héroïques. Améliorez ensuite votre équipement Mythe 1/6 (272) -> 6/6 (289) contre 80x Écus Mythiques.",
            "Palier Mythe (Raid) : améliorez la pièce obtenue en raid du rang 2/6 (276) vers le 6/6 (289) contre 80 Écus Mythiques.",
            "Écus dépensés : 420 / 420 Écus Héroïques et 320 / 420 Écus Mythiques",
            "Niveau d'équipement estimé (selon RNG) : 2x 266, 5x 269, 4x 276, 1x 285, 3x 289"
        }
    },
    {
        title = "Semaine 5 (15 - 21 avril)",
        objectives = {
            "Ne dépensez aucun Écu Héroïque et Mythique sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
            "Grande Chambre Forte : ouvrez là pour obtenir un équipement Mythe 272+",
            "Mythique + (Saison 1) : accomplissez des donjons +10 (minimum) pour remplir les emplacements de votre Grande Chambre Forte et accumuler vos différents Écus.",
            "Artisanat : fabriquez votre second équipement Mythe 5/5 (285) contre 80x Écus Mythiques. Privilégiez si possible un emplacement où vous possédez déjà un équipement Héro.",
            "Palier Héroïque : améliorez deux de vos équipements Hero 4/6 (269) -> 6/6 (276) contre 80x Écus Héroïques. Gardez 20x Écus Héroïques pour l'étape suivante",
            "Palier Mythe : si l'équipement de votre Grande Chambre Forte est un équipement Mythe 1/6 (272), améliorez d'abord son équivalent Hero 6/6 (276) contre 20x Écus Héroïques. Améliorez ensuite votre équipement Mythe 1/6 (272) -> 6/6 (289) pour 80x Écus Mythiques.",
            "Écus dépensés : 520 / 520 Écus Héroïques et 480 / 480 Écus Mythiques",
            "Niveau d'équipement estimé (selon RNG) : 1x 266, 2x 269, 6x 276, 2x 285, 4x 289"
        }
    },
    {
        title = "Semaine 6 (22 - 28 avril)",
        objectives = {
            "Ne dépensez aucun Écu Héroïque et Mythique sauf si demandé.",
            "Écus : atteignez le cap hebdomadaire de tous vos Écus.",
            "Grande Chambre Forte : ouvrez là pour obtenir un équipement Mythe 272+",
            "Mythique + (Saison 1) : accomplissez des donjons +12 (minimum) pour remplir les emplacements de votre Grande Chambre Forte et accumuler vos différents Écus.",
            "Hypothèse : nous partons du principe que vous avez obtenu 1 pièce Mythe 2/6 (276)",
            "Palier Héroïque : améliorez un de vos Hero 4/6 (269) -> 6/6 (276) contre 40x Écus Héroïques.",
            "Palier Mythe : si l'équipement de votre Grande Chambre Forte est un Mythe 1/6 (272), améliorez d'abord son équivalent Hero 6/6 (276) contre 20x Écus Héroïques. Améliorez ensuite votre Mythe 1/6 (272) -> 6/6 (289) pour 80x Écus Mythiques.",
            "Palier Mythe (Raid) : améliorez l'équipement Mythe 2/6 (276) -> 5/6 (285) contre 60x Écus Mythiques",
            "Écus dépensés : 560 / 620 Écus Héroïques (Terminé) et 620 / 620 Écus Mythiques.",
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

local frame = CreateFrame("Frame", "MidnightTrackerFrame", UIParent, "BackdropTemplate")
frame:SetSize(500, 400)
frame:SetPoint("CENTER")
frame:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})

frame:SetBackdropColor(0,0,0,0.92)
frame:SetBackdropBorderColor(1, 0.82, 0, 1)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:Hide()

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -10)
title:SetText("Suivi d'objectif Midnight")

local menuWidth = 110
local menu = CreateFrame("Frame", "MidnightSummaryMenu", frame, "BackdropTemplate")
menu:SetSize(menuWidth, 220)

menu:SetPoint("TOPLEFT", frame, "TOPRIGHT", 10, -36)
menu:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
menu:SetBackdropColor(0,0,0,0.92)
menu:SetBackdropBorderColor(1, 0.82, 0, 1)


local menuContent = CreateFrame("Frame", nil, menu)
menuContent:SetPoint("TOPLEFT", 8, -8)
menuContent:SetPoint("BOTTOMRIGHT", -8, 8)


local menuLabels = {
    "27/02. - 03/03",
    "03/03 - 10/03",
    "11/03 - 17/03",
    "18/03 - 24/03",
    "25/03 - 31/03",
    "01/04 - 07/04",
    "08/04 - 14/04",
    "15/04 - 21/04",
    "22/04 - 28/04",
    "29/04 et +",
}

local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")

scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -36)
scrollFrame:SetPoint("BOTTOMRIGHT", -16, 10)

local content = CreateFrame("Frame", nil, scrollFrame)
content:SetSize(430, 1)
content:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 2, -4)
scrollFrame:SetScrollChild(content)

local function computeAvailableW(offset)
    local availableW = 400
    if scrollFrame and scrollFrame.GetWidth and scrollFrame:GetWidth() > 0 then
        availableW = scrollFrame:GetWidth()
    elseif frame and frame.GetWidth and frame:GetWidth() > 0 then
        availableW = frame:GetWidth()
    end
    local rightPad = 20
    offset = offset or 10
    return math.max(200, availableW - offset - rightPad)
end

local function UpdateMenuForScroll(cur)
    if not cur then cur = scrollFrame:GetVerticalScroll() end
    if not weekScrolls or #weekScrolls == 0 then return end
    local bestIdx, bestDist = nil, math.huge
    for i = 1, #weekScrolls do
        local d = math.abs(weekScrolls[i] - cur)
        if d < bestDist then bestDist = d; bestIdx = i end
    end
    if bestIdx and bestIdx ~= activeMenuIndex then
        activeMenuIndex = bestIdx
        UpdateMenuActive()
    end
end


local poll = { last = -1, timer = 0 }
do
    scrollFrame:SetScript("OnUpdate", function(self, elapsed)
        poll.timer = poll.timer + (elapsed or 0)
        if poll.timer < 0.08 then return end
        poll.timer = 0
        local cur = self:GetVerticalScroll()
        if cur == poll.last then return end
        poll.last = cur
        UpdateMenuForScroll(cur)
    end)

    scrollFrame:SetScript("OnVerticalScroll", function(self, value)
        UpdateMenuForScroll(value)
    end)
end

local weekScrolls = {}


local menuButtons = {}
local activeMenuIndex = nil

local function UpdateMenuActive()
    for idx, entry in ipairs(menuButtons) do
        if entry and entry.txt then
            if idx == activeMenuIndex then
                entry.txt:SetTextColor(1, 0.82, 0)
                if entry.btn and entry.btn.LockHighlight then entry.btn:LockHighlight() end
            else
                entry.txt:SetTextColor(1,1,1)
                if entry.btn and entry.btn.UnlockHighlight then entry.btn:UnlockHighlight() end
            end
        end
    end
end

local function ScrollToWeek(idx)
    if not weekScrolls[idx] then return end
    local target = weekScrolls[idx]
    local maxScroll = 0
    if content and content.GetHeight and scrollFrame and scrollFrame.GetHeight then
        maxScroll = math.max(0, content:GetHeight() - scrollFrame:GetHeight())
    end
    if target < 0 then target = 0 end
    if target > maxScroll then target = maxScroll end
    scrollFrame:SetVerticalScroll(target)
end

local function CreateObjective(parent, text, index, yOffset, weekIndex)
    MidnightTrackerDB = MidnightTrackerDB or {}
    MidnightTrackerDB.checks = MidnightTrackerDB.checks or {}
    local function colorizeText(s)
        if not s or s == "" then return s end
        s = s:gsub("[Aa]vent[^ %.,%(]*", "|cff7FB8FF%0|r")
        s = s:gsub("%f[%a][Vv][e]t[e]ran%f[%A]", "|cffC0A0FF%0|r")
        s = s:gsub("[Cc]hampion", "|cffff3b3b%0|r")
        s = s:gsub("%f[%a][Hh][e]ro%f[%A]", "|cffFFB86A%0|r")
        s = s:gsub("%f[%a][Mm]ythe%f[%A]", "|cffFFE07A%0|r")
        return s
    end

    local function highlightPrefix(s)
        if not s then return s end
        local prefix, rest = s:match("^(.-:)%s*(.*)$")
        if prefix then
            prefix = "|cff7CFFB8" .. prefix .. "|r"
            if rest == "" then
                return prefix
            else
                return prefix .. " " .. colorizeText(rest)
            end
        end
        return colorizeText(s)
    end

    local summaryPrefixPatterns = {
        "^Écus dépensés%s*:",
        "^Niveau d['%\"]?équipement estimé%s*%(selon RNG%)%s*:"
    }
    for _, pat in ipairs(summaryPrefixPatterns) do
        if text:match(pat) then
            local prefix, rest = text:match("^(.-:)%s*(.*)$")
            prefix = prefix or text
            rest = rest or ""
            local display = "|cffFFD100" .. prefix .. "|r"
            if rest ~= "" then
                display = display .. " " .. "|cffffffff" .. rest .. "|r"
            end

            local centerLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            local leftPad = 10
            centerLabel:SetWidth(computeAvailableW(leftPad))
            centerLabel:SetJustifyH("LEFT")
            centerLabel:SetWordWrap(true)
            centerLabel:SetText(display)
            local leftPad = 10
            centerLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", leftPad, yOffset)
            return centerLabel:GetStringHeight() + 12
        end
    end

    local num = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    num:SetPoint("TOPLEFT", parent, "TOPLEFT", 16, yOffset)
    num:SetText(index .. ".")
    num:SetTextColor(1, 0.82, 0)

    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", 36, yOffset)
    do
        local offset = 36
        label:SetWidth(computeAvailableW(offset))
    end
    label:SetJustifyH("LEFT")
    label:SetWordWrap(true)
    label:SetTextColor(1,1,1)

    label:SetText(highlightPrefix(text))
    label:SetTextColor(1,1,1)
    label:SetAlpha(1)
    num:SetTextColor(1, 0.82, 0)

    return label:GetStringHeight() + 12
end

function Midnight:Refresh()
    content:Hide()
    content:SetSize(1,1)

    
    for _, c in ipairs({content:GetChildren()}) do
        c:Hide()
        c:SetParent(nil)
    end

    weekScrolls = {}

        
        if not frame or not frame:IsShown() then
            poll.last = -1
            poll.timer = 0
            return
        end
    local yOffset = -10

    for wIndex, week in ipairs(weeks) do
        local weekTitle = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
        weekTitle:SetPoint("TOPLEFT", 10, yOffset)
        weekTitle:SetText(week.title)
        weekTitle:SetTextColor(1, 0.82, 0)
        
        weekScrolls[wIndex] = -yOffset - 4
        yOffset = yOffset - 30

            for oIndex, objective in ipairs(week.objectives) do
                local height = CreateObjective(content, objective, oIndex, yOffset, wIndex)
                yOffset = yOffset - height
            end

        yOffset = yOffset - 24
    end

    content:SetHeight(-yOffset)
    content:Show()
    
    
    for _, c in ipairs({menuContent:GetChildren()}) do c:Hide(); c:SetParent(nil) end
    
    menuButtons = {}
    for i, week in ipairs(weeks) do
        local btn = CreateFrame("Button", nil, menuContent)
        btn:SetSize(menuWidth - 16, 18)
        btn:SetPoint("TOPLEFT", 0, -((i - 1) * 20))
        btn:EnableMouse(true)
        btn:SetFrameLevel(menu:GetFrameLevel() + 2)
        btn:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")

        local bullet = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        bullet:SetPoint("LEFT", 2, 0)
        bullet:SetTextColor(1, 0.82, 0)
        bullet:SetText("•")

        local txt = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        txt:SetPoint("LEFT", 14, 0)
        txt:SetJustifyH("LEFT")
        txt:SetText(menuLabels[i] or week.title or ("Semaine " .. i))
        txt:SetTextColor(1,1,1)

        menuButtons[i] = { btn = btn, txt = txt, bullet = bullet }

        btn:SetScript("OnClick", function()
            activeMenuIndex = i
            UpdateMenuActive()
            ScrollToWeek(i)
        end)
        btn:SetScript("OnEnter", function(self)
            if menuButtons[i] and menuButtons[i].txt then
                menuButtons[i].txt:SetTextColor(1, 0.82, 0)
            end
            if self.LockHighlight then self:LockHighlight() end
        end)
        btn:SetScript("OnLeave", function(self)
            if activeMenuIndex == i then
                if menuButtons[i] and menuButtons[i].txt then menuButtons[i].txt:SetTextColor(1, 0.82, 0) end
            else
                if menuButtons[i] and menuButtons[i].txt then menuButtons[i].txt:SetTextColor(1,1,1) end
            end
            if self.UnlockHighlight then self:UnlockHighlight() end
        end)
    end
    
    if not activeMenuIndex then activeMenuIndex = 1 end
    UpdateMenuActive()
end

local function createLetterButton(letter, r, g, b, xOff, yOff, onClick, title, desc)
    local btn = CreateFrame("Button", nil, frame)
    btn:SetSize(20, 20)
    btn:SetPoint("TOPLEFT", frame, "TOPLEFT", xOff, yOff)

    local bg = btn:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(r, g, b, 1)

    local txt = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    txt:SetPoint("CENTER", 0, 0)
    txt:SetTextColor(1,1,1)
    txt:SetText(letter)

    btn:SetScript("OnClick", onClick)
    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:ClearLines()
        GameTooltip:AddLine(title)
        if desc then GameTooltip:AddLine(desc, 1,1,1, true) end
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    btn:SetFrameLevel(frame:GetFrameLevel() + 5)
    return btn
end

local discordButton = createLetterButton("D", 0.36, 0.18, 0.56, 10, -10,
    function()
        if ChatEdit_ChooseBoxForSend then
            local editBox = ChatEdit_ChooseBoxForSend()
            ChatEdit_ActivateChat(editBox)
            editBox:Insert("https://discord.gg/D7zMBtPfGn")
            editBox:HighlightText()
        end
    end,
    "Discord",
    "Copie l'adresse du serveur Discord de la guilde dont je suis membre (nous recherchons d'ailleurs nos derniers membres pour notre roster Mythique)")

local twitchButton = createLetterButton("T", 0.4, 0.2, 0.7, 36, -10,
    function()
        if ChatEdit_ChooseBoxForSend then
            local editBox = ChatEdit_ChooseBoxForSend()
            ChatEdit_ActivateChat(editBox)
            editBox:Insert("twitch.tv/poulpi_x")
            editBox:HighlightText()
        end
    end,
    "Twitch",
    "Copie l'URL de ma chaîne Twitch, je live principalement du mardi au vendredi dès 18h")

local resourcesButton = createLetterButton("R", 0.2, 0.6, 0.2, 62, -10,
    function()
        local url = "https://docs.google.com/document/u/1/d/e/2PACX-1vTAN9Hjl-_ZhxofBUn4qKM0UNkEx2MTePWg61IcD_b5Vo6istu8YAivtINMz5QX5oxY7prnKfACIQcx/pub"
        if ChatEdit_ChooseBoxForSend then
            local editBox = ChatEdit_ChooseBoxForSend()
            ChatEdit_ActivateChat(editBox)
            editBox:Insert(url)
            editBox:HighlightText()
        else
        end
    end,
    "Ressources",
    "Copie l'URL des ressources ayant permis de créer ce guide créé par Larias (un joueur anglophone), un grand merci à lui pour son travail de compilation et d'analyse des données de la bêta !")

local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -6, -6)
closeBtn:SetScript("OnClick", function()
    frame:Hide()
end)
closeBtn:SetFrameLevel(frame:GetFrameLevel() + 5)

local planningButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
planningButton:SetSize(70, 22)
planningButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -40, -6)
planningButton:SetText("Planning")
planningButton:SetScript("OnClick", function()
    if MidnightPlanning and MidnightPlanning.Show and MidnightPlanning.Hide then
        if MidnightPlanningFrame and MidnightPlanningFrame:IsShown() then
            MidnightPlanning.Hide()
        else
            MidnightPlanning.Show()
        end
    else
    end
end)
planningButton:SetFrameLevel(frame:GetFrameLevel() + 5)

SLASH_MIDNIGHTTRACKER1 = "/som"
SlashCmdList["MIDNIGHTTRACKER"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
        Midnight:Refresh()
    end
end

print("|cffFFD100[Midnight]|r Tapez /som pour ouvrir le suivi d'objectifs.")

