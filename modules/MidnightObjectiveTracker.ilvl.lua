---@diagnostic disable: undefined-global
local Ilvl = {}
_G["MidnightIlvl"] = Ilvl

local function getAccent()
    if MidnightTracker and MidnightTracker.GetAccentColor then
        return MidnightTracker.GetAccentColor()
    end
    return 1, 0.82, 0
end

local function colorizeTrack(text)
    local advColor   = MidnightL.C("adventurer")
    local vetColor   = MidnightL.C("veteran")
    local champColor = MidnightL.C("champion")
    local heroColor  = MidnightL.C("heroic")
    local mythColor  = MidnightL.C("mythic")

    local sAdv   = MidnightL.S("ilvl_adventurer")
    local sVet   = MidnightL.S("ilvl_veteran")
    local sChamp = MidnightL.S("ilvl_champion")
    local sHero  = MidnightL.S("ilvl_hero")
    local sMyth  = MidnightL.S("ilvl_myth")

    local function colorPart(part)
        if part:find(sAdv, 1, true) then
            return "|cff" .. advColor   .. part .. "|r"
        elseif part:find(sVet, 1, true) then
            return "|cff" .. vetColor   .. part .. "|r"
        elseif part:find(sChamp, 1, true) then
            return "|cff" .. champColor .. part .. "|r"
        elseif part:find(sHero, 1, true) then
            return "|cff" .. heroColor  .. part .. "|r"
        elseif part:find(sMyth, 1, true) then
            return "|cff" .. mythColor  .. part .. "|r"
        end
        return part
    end

    if text:find(" / ") then
        local parts = {}
        for segment in text:gmatch("[^/]+") do
            local trimmed = segment:match("^%s*(.-)%s*$")
            parts[#parts + 1] = colorPart(trimmed)
        end
        return table.concat(parts, " |cffffffff/|r ")
    end
    return colorPart(text)
end

local ICON_ADV   = "|TInterface\\Icons\\inv_120_crest_adventurer:14:14:0:0|t"
local ICON_VET   = "|TInterface\\Icons\\inv_120_crest_veteran:14:14:0:0|t"
local ICON_CHAMP = "|TInterface\\Icons\\inv_120_crest_champion:14:14:0:0|t"
local ICON_HERO  = "|TInterface\\Icons\\inv_120_crest_hero:14:14:0:0|t"
local ICON_MYTH  = "|TInterface\\Icons\\inv_120_crest_myth:14:14:0:0|t"

local function getLocalizedData()
    local locale = MidnightL.GetLocale()
    local adv   = MidnightL.S("ilvl_adventurer")
    local vet   = MidnightL.S("ilvl_veteran")
    local champ = MidnightL.S("ilvl_champion")
    local hero  = MidnightL.S("ilvl_hero")
    local myth  = MidnightL.S("ilvl_myth")

    local crestAdv   = ICON_ADV   .. " |cff" .. MidnightL.C("adventurer") .. MidnightL.S("ilvl_crest_adv")   .. "|r"
    local crestVet   = ICON_VET   .. " |cff" .. MidnightL.C("veteran")    .. MidnightL.S("ilvl_crest_vet")   .. "|r"
    local crestChamp = ICON_CHAMP .. " |cff" .. MidnightL.C("champion")   .. MidnightL.S("ilvl_crest_champ") .. "|r"
    local crestHero  = ICON_HERO  .. " |cff" .. MidnightL.C("heroic")     .. MidnightL.S("ilvl_crest_hero")  .. "|r"
    local crestMyth  = ICON_MYTH  .. " |cff" .. MidnightL.C("mythic")     .. MidnightL.S("ilvl_crest_myth")  .. "|r"

    local upgradeTracksData = {
        { ilvl = "220", track = adv .. " 1",               crests = crestAdv },
        { ilvl = "224", track = adv .. " 2",               crests = crestAdv },
        { ilvl = "227", track = adv .. " 3",               crests = crestAdv },
        { ilvl = "230", track = adv .. " 4",               crests = crestAdv },
        { ilvl = "233", track = adv .. " 5 / " .. vet .. " 1", crests = crestAdv },
        { ilvl = "237", track = adv .. " 6 / " .. vet .. " 2", crests = crestAdv },
        { ilvl = "240", track = vet .. " 3",               crests = crestVet },
        { ilvl = "243", track = vet .. " 4",               crests = crestVet },
        { ilvl = "246", track = vet .. " 5 / " .. champ .. " 1", crests = crestVet },
        { ilvl = "250", track = vet .. " 6 / " .. champ .. " 2", crests = crestVet },
        { ilvl = "253", track = champ .. " 3",             crests = crestChamp },
        { ilvl = "256", track = champ .. " 4",             crests = crestChamp },
        { ilvl = "259", track = champ .. " 5 / " .. hero .. " 1", crests = crestChamp },
        { ilvl = "263", track = champ .. " 6 / " .. hero .. " 2", crests = crestChamp },
        { ilvl = "266", track = hero .. " 3",              crests = crestHero },
        { ilvl = "269", track = hero .. " 4",              crests = crestHero },
        { ilvl = "272", track = hero .. " 5 / " .. myth .. " 1", crests = crestHero },
        { ilvl = "276", track = hero .. " 6 / " .. myth .. " 2", crests = crestHero },
        { ilvl = "279", track = myth .. " 3",              crests = crestMyth },
        { ilvl = "282", track = myth .. " 4",              crests = crestMyth },
        { ilvl = "285", track = myth .. " 5",              crests = crestMyth },
        { ilvl = "289", track = myth .. " 6",              crests = crestMyth },
    }

    local craftedData = {
        { quality = "1", adv = "220", vet = "233", champ = "246", hero = "259", myth = "272" },
        { quality = "2", adv = "224", vet = "237", champ = "249", hero = "262", myth = "275" },
        { quality = "3", adv = "227", vet = "240", champ = "252", hero = "265", myth = "278" },
        { quality = "4", adv = "230", vet = "243", champ = "255", hero = "268", myth = "282" },
        { quality = "5", adv = "233", vet = "246", champ = "259", hero = "272", myth = "285" },
    }

    local dungeonData = {
        { source = "Normal", endLoot = "214", vault = "-" },
        { source = (locale == "fr" and "Héroïque") or (locale == "de" and "Heroisch") or (locale == "es" and "Heroico") or "Heroic", endLoot = "230", vault = "243" },
        { source = "M0", endLoot = "246", vault = "256" },
        { source = "M2", endLoot = "250", vault = "259" },
        { source = "M3", endLoot = "250", vault = "259" },
        { source = "M4", endLoot = "253", vault = "263" },
        { source = "M5", endLoot = "256", vault = "263" },
        { source = "M6", endLoot = "259", vault = "266" },
        { source = "M7", endLoot = "259", vault = "269" },
        { source = "M8", endLoot = "263", vault = "269" },
        { source = "M9", endLoot = "263", vault = "269" },
        { source = "M10", endLoot = "266", vault = "272" },
    }

    local raidData = {
        { difficulty = "LFR",    normal = "233 - 237 - 240 - 243", mid = "237 - 240", late = "-" },
        { difficulty = locale == "fr" and "Normal"   or "Normal",  normal = "246 - 250 - 253 - 256", mid = "250 - 253", late = "256" },
        { difficulty = (locale == "fr" and "Héroïque") or (locale == "de" and "Heroisch") or (locale == "es" and "Heroico") or "Heroic",  normal = "259 - 263 - 266 - 269", mid = "263 - 266", late = "266" },
        { difficulty = (locale == "fr" and "Mythique") or (locale == "de" and "Mythisch") or (locale == "es" and "Mítico") or "Mythic",   normal = "272 - 276 - 279 - 282", mid = "276 - 279", late = "272" },
    }

    local raidData2 = {
        { difficulty = "LFR",    normal = "240 - 243", mid = "240", late = "-" },
        { difficulty = locale == "fr" and "Normal"   or "Normal",  normal = "253 - 256", mid = "253", late = "256" },
        { difficulty = (locale == "fr" and "Héroïque") or (locale == "de" and "Heroisch") or (locale == "es" and "Heroico") or "Heroic",  normal = "266 - 269", mid = "266", late = "266" },
        { difficulty = (locale == "fr" and "Mythique") or (locale == "de" and "Mythisch") or (locale == "es" and "Mítico") or "Mythic",   normal = "279 - 282", mid = "279", late = "272" },
    }

    local delveData = {
        { tier = "1", endLoot = "220", mapDrop = "-", vault = "-" },
        { tier = "2", endLoot = "224", mapDrop = "-", vault = "237" },
        { tier = "3", endLoot = "227", mapDrop = "-", vault = "240" },
        { tier = "4", endLoot = "230", mapDrop = "237", vault = "243" },
        { tier = "5", endLoot = "233", mapDrop = "243", vault = "246" },
        { tier = "6", endLoot = "237", mapDrop = "250", vault = "256" },
        { tier = "7", endLoot = "240", mapDrop = "256", vault = "256" },
        { tier = "8", endLoot = "250", mapDrop = "259", vault = "259" },
        { tier = "9", endLoot = "250", mapDrop = "259", vault = "259" },
        { tier = "10", endLoot = "250", mapDrop = "259", vault = "259" },
        { tier = "11", endLoot = "250", mapDrop = "259", vault = "259" },
    }

    return {
        upgradeTracks = upgradeTracksData,
        crafted = craftedData,
        dungeon = dungeonData,
        raid = raidData,
        raid2 = raidData2,
        delve = delveData,
    }
end

local iframe = CreateFrame("Frame", "MidnightIlvlFrame", UIParent, "BackdropTemplate")
iframe:SetSize(1080, 680)
iframe:SetPoint("CENTER")
iframe:SetBackdrop({
    bgFile = "Interface/Buttons/WHITE8X8",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
iframe:SetBackdropColor(0, 0, 0, 1)
iframe:SetBackdropBorderColor(1, 0.82, 0, 1)
if MidnightTracker and MidnightTracker.RegisterBorderedFrame  then MidnightTracker.RegisterBorderedFrame(iframe)  end
if MidnightTracker and MidnightTracker.RegisterWindowBgFrame  then MidnightTracker.RegisterWindowBgFrame(iframe)   end
iframe:SetMovable(true)
iframe:SetToplevel(true)
iframe:HookScript("OnShow", function()
    local wbc = MidnightObjectiveTrackerDB and MidnightObjectiveTrackerDB.windowBgColor or { r = 0, g = 0, b = 0 }
    iframe:SetBackdropColor(wbc.r, wbc.g, wbc.b, 1)
end)
iframe:EnableMouse(true)
iframe:RegisterForDrag("LeftButton")
iframe:SetScript("OnDragStart", function(self) self:StartMoving(); self:Raise() end)
iframe:SetScript("OnDragStop", iframe.StopMovingOrSizing)
iframe:Hide()
table.insert(UISpecialFrames, "MidnightIlvlFrame")

local ititle = iframe:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
ititle:SetPoint("TOP", iframe, "TOP", 0, -15)
do local ar, ag, ab = getAccent(); ititle:SetTextColor(ar, ag, ab) end

local iclose = CreateFrame("Button", nil, iframe, "UIPanelButtonTemplate")
iclose:SetSize(20, 20)
iclose:SetPoint("TOPRIGHT", iframe, "TOPRIGHT", -10, -10)
iclose:SetText("X")
iclose:SetNormalFontObject("GameFontNormalSmall")
iclose:SetHighlightFontObject("GameFontNormalSmall")
iclose:SetScript("OnClick", function()
    iframe:Hide()
end)
iclose:SetFrameLevel(iframe:GetFrameLevel() + 5)
if MidnightTracker and MidnightTracker.RegisterButtonText  then MidnightTracker.RegisterButtonText(iclose) end
if MidnightTracker and MidnightTracker.RegisterPanelButton then MidnightTracker.RegisterPanelButton(iclose) end

local content = CreateFrame("Frame", nil, iframe)
content:SetPoint("TOPLEFT", iframe, "TOPLEFT", 20, -35)
content:SetPoint("BOTTOMRIGHT", iframe, "BOTTOMRIGHT", -20, 20)

local rows = {}

local function colorizeIlvl(text, applyToAll)
    if not text or text == "" or text == "?" or text == "-" then return text end

    if applyToAll then
        return text:gsub("(%d+)", function(numStr)
            local n = tonumber(numStr)
            if not n then return numStr end
            if n >= 272 then return "|cff" .. MidnightL.C("mythic") .. numStr .. "|r"
            elseif n >= 259 then return "|cff" .. MidnightL.C("heroic") .. numStr .. "|r"
            elseif n >= 246 then return "|cff" .. MidnightL.C("champion") .. numStr .. "|r"
            elseif n >= 233 then return "|cff" .. MidnightL.C("veteran") .. numStr .. "|r"
            else return "|cff" .. MidnightL.C("adventurer") .. numStr .. "|r"
            end
        end)
    else
        local num = tonumber(text)
        if not num then return text end
        if num >= 272 then return "|cff" .. MidnightL.C("mythic") .. text .. "|r"
        elseif num >= 259 then return "|cff" .. MidnightL.C("heroic") .. text .. "|r"
        elseif num >= 246 then return "|cff" .. MidnightL.C("champion") .. text .. "|r"
        elseif num >= 233 then return "|cff" .. MidnightL.C("veteran") .. text .. "|r"
        else return "|cff" .. MidnightL.C("adventurer") .. text .. "|r"
        end
    end
end

local function renderTable(x, y, headers, dataRows, colWidths, title, colorFirstCol, specialColorCol, noColorCol, fontSize, leftAlignFirstCol, centerCols)
    fontSize = fontSize or "GameFontNormalSmall"
    local titleFont = "GameFontNormal"

    local totalWidth = 0
    for _, w in ipairs(colWidths) do totalWidth = totalWidth + w end
    local tableWidth = totalWidth + (#colWidths - 1) * 5

    if title then
        local titleBg = content:CreateTexture(nil, "BACKGROUND")
        do local ar, ag, ab = getAccent(); titleBg:SetColorTexture(ar, ag * 0.95, ab, 0.18) end
        titleBg:SetPoint("TOPLEFT", content, "TOPLEFT", x - 3, y + 2)
        titleBg:SetWidth(tableWidth + 6)
        titleBg:SetHeight(18)
        table.insert(rows, titleBg)

        local sectionTitle = content:CreateFontString(nil, "OVERLAY", titleFont)
        sectionTitle:SetPoint("TOPLEFT", content, "TOPLEFT", x - 3, y + 2)
        sectionTitle:SetWidth(tableWidth + 6)
        sectionTitle:SetHeight(18)
        sectionTitle:SetJustifyH("CENTER")
        sectionTitle:SetJustifyV("MIDDLE")
        sectionTitle:SetText(title)
        do local ar, ag, ab = getAccent(); sectionTitle:SetTextColor(ar, ag, ab) end
        table.insert(rows, sectionTitle)
        y = y - 20
    end

    local headerBg = content:CreateTexture(nil, "BACKGROUND")
    headerBg:SetColorTexture(0.08, 0.08, 0.14, 0.85)
    headerBg:SetPoint("TOPLEFT", content, "TOPLEFT", x - 3, y + 3)
    headerBg:SetWidth(tableWidth + 6)
    headerBg:SetHeight(17)
    table.insert(rows, headerBg)

    local headerX = x
    for i, htext in ipairs(headers) do
        local h = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        h:SetPoint("TOPLEFT", content, "TOPLEFT", headerX, y + 3)
        h:SetWidth(colWidths[i])
        h:SetHeight(17)
        h:SetJustifyH("CENTER")
        h:SetJustifyV("MIDDLE")
        h:SetText(htext)
        do local ar, ag, ab = getAccent(); h:SetTextColor(ar, ag, ab) end
        table.insert(rows, h)
        headerX = headerX + colWidths[i] + 5
    end
    y = y - 18

    for ri, row in ipairs(dataRows) do
        local rowX = x
        for ci, cellText in ipairs(row) do
            local displayText = cellText
            if ci == 1 and colorFirstCol then
                displayText = colorizeIlvl(cellText, false)
            elseif noColorCol and ci == noColorCol then
                displayText = cellText
            elseif specialColorCol and ci == specialColorCol then
                if title and (title:find("Paliers") or title:find("Upgrade") or title:find("upgrade")
                    or title:find("Aufwertung") or title:find("Mejoras")) then
                    displayText = colorizeTrack(cellText)
                end
            else
                displayText = colorizeIlvl(cellText, true)
            end

            local f = content:CreateFontString(nil, "OVERLAY", fontSize)
            f:SetPoint("TOPLEFT", content, "TOPLEFT", rowX, y - 2)
            f:SetWidth(colWidths[ci])
            f:SetHeight(14)
            f:SetWordWrap(false)
            f:SetJustifyH((centerCols and centerCols[ci]) and "CENTER" or "LEFT")
            f:SetText(displayText)
            f:SetTextColor(1, 1, 1)
            table.insert(rows, f)
            rowX = rowX + colWidths[ci] + 5
        end

        if (ri % 2) == 1 then
            local bg = content:CreateTexture(nil, "BACKGROUND")
            bg:SetColorTexture(0, 0, 0, 0.3)
            bg:SetPoint("TOPLEFT", content, "TOPLEFT", x - 2, y)
            bg:SetWidth(tableWidth + 4)
            bg:SetHeight(18)
            table.insert(rows, bg)
        end

        y = y - 18
    end

    return y
end

local function RefreshIlvl()
    for _, r in ipairs(rows) do
        if type(r.Hide) == 'function' then r:Hide() end
    end
    rows = {}

    ititle:SetText(MidnightL.S("ilvl_title"))

    local data = getLocalizedData()

    local col1X = 0
    local col2X = 371
    local col3X = 642

    local col1Y = -5

    local upgradeHeaders = {MidnightL.S("ilvl_ilvl"), MidnightL.S("ilvl_upgrade_tracks_short"), MidnightL.S("ilvl_crests")}
    local upgradeRows = {}
    for _, row in ipairs(data.upgradeTracks) do
        table.insert(upgradeRows, {row.ilvl, row.track, row.crests})
    end
    col1Y = renderTable(col1X, col1Y, upgradeHeaders, upgradeRows, {38, 120, 185}, MidnightL.S("ilvl_upgrade_tracks"), true, 2, 3, "GameFontNormalSmall", nil, {[1]=true, [2]=true, [3]=true})

    local col2Y = -5

    local dungeonHeaders = {MidnightL.S("ilvl_season"), MidnightL.S("ilvl_end_loot"), MidnightL.S("ilvl_great_vault")}
    local dungeonRows = {}
    for _, row in ipairs(data.dungeon) do
        table.insert(dungeonRows, {row.source, row.endLoot, row.vault})
    end
    col2Y = renderTable(col2X, col2Y, dungeonHeaders, dungeonRows, {110, 50, 80}, MidnightL.S("ilvl_dungeon"), false, nil, 1, "GameFontNormalSmall", true, {[1]=true, [2]=true, [3]=true})

    col2Y = col2Y - 10

    local delveHeaders = {MidnightL.S("ilvl_tier"), MidnightL.S("ilvl_end_loot"), MidnightL.S("ilvl_map_drop"), MidnightL.S("ilvl_great_vault")}
    local delveRows = {}
    for _, row in ipairs(data.delve) do
        table.insert(delveRows, {row.tier, row.endLoot, row.mapDrop, row.vault})
    end
    col2Y = renderTable(col2X, col2Y, delveHeaders, delveRows, {32, 52, 58, 78}, MidnightL.S("ilvl_delve"), false, nil, 1, "GameFontNormalSmall", nil, {[1]=true, [2]=true, [3]=true, [4]=true})

    local col3Y = -5

    local raidHeaders = {MidnightL.S("ilvl_difficulty"), MidnightL.S("ilvl_end_loot"), MidnightL.S("ilvl_raid_synth"), MidnightL.S("ilvl_great_vault")}
    local raidRows = {}
    for _, row in ipairs(data.raid) do
        table.insert(raidRows, {row.difficulty, row.normal, row.mid, row.late})
    end
    col3Y = renderTable(col3X, col3Y, raidHeaders, raidRows, {70, 130, 90, 88}, MidnightL.S("ilvl_raid"), false, nil, nil, "GameFontNormalSmall", true, {[1]=true, [2]=true, [3]=true, [4]=true})

    col3Y = col3Y - 12

    local raidRows2 = {}
    for _, row in ipairs(data.raid2) do
        table.insert(raidRows2, {row.difficulty, row.normal, row.mid, row.late})
    end
    col3Y = renderTable(col3X, col3Y, raidHeaders, raidRows2, {70, 130, 90, 88}, MidnightL.S("ilvl_raid2"), false, nil, nil, "GameFontNormalSmall", true, {[1]=true, [2]=true, [3]=true, [4]=true})

    col3Y = col3Y - 12

    local locale = MidnightL.GetLocale()
    local advHeader  = MidnightL.S("ilvl_adventurer")
    local vetHeader  = MidnightL.S("ilvl_veteran")
    local heroHeader = MidnightL.S("ilvl_hero")
    local mythHeader = MidnightL.S("ilvl_myth")
    local craftHeaders = {MidnightL.S("ilvl_quality"), advHeader, vetHeader, MidnightL.S("ilvl_champion"), heroHeader, mythHeader}
    local craftRows = {}
    for _, row in ipairs(data.crafted) do
        table.insert(craftRows, {row.quality, row.adv, row.vet, row.champ, row.hero, row.myth})
    end
    col3Y = renderTable(col3X, col3Y, craftHeaders, craftRows, {52, 70, 52, 56, 38, 40}, MidnightL.S("ilvl_crafted"), false, nil, 1, "GameFontNormalSmall", nil, {[1]=true, [2]=true, [3]=true, [4]=true, [5]=true, [6]=true})

    local PAD_TOP    = 35
    local PAD_BOTTOM = 20
    local minColY    = math.min(col1Y, col2Y, col3Y)
    local contentH   = math.abs(minColY) + 5
    iframe:SetSize(iframe:GetWidth(), PAD_TOP + contentH + PAD_BOTTOM)

end

function Ilvl.Show()
    ititle:SetText(MidnightL.S("ilvl_title"))
    do local ar, ag, ab = getAccent(); ititle:SetTextColor(ar, ag, ab) end
    RefreshIlvl()
    iframe:Show()
    C_Timer.After(0, RefreshIlvl)
end

function Ilvl.Hide()
    iframe:Hide()
end

if MidnightTracker and MidnightTracker.RegisterAccentColorCallback then
    MidnightTracker.RegisterAccentColorCallback(function(r, g, b)
        ititle:SetTextColor(r, g, b)
        if iframe:IsShown() then
            RefreshIlvl()
        end
    end)
end
