local Midnight = {}
_G["MidnightTracker"] = Midnight

MidnightTrackerDB = MidnightTrackerDB or {}
MidnightTrackerDB.checks = MidnightTrackerDB.checks or {}
MidnightTrackerDB.scale = MidnightTrackerDB.scale or 1.0
MidnightTrackerDB.colorblindMode = MidnightTrackerDB.colorblindMode or "none"

MidnightL.Init()
MidnightL.SetColorblindMode(MidnightTrackerDB.colorblindMode)

local function getWeeks()
    return MidnightL[MidnightL.GetLocale()].weeks
end

local function getMenuLabels()
    return MidnightL[MidnightL.GetLocale()].menuLabels
end

local function getSummaryPatterns()
    return MidnightL[MidnightL.GetLocale()].summaryPatterns
end

local frame = CreateFrame("Frame", "MidnightTrackerFrame", UIParent, "BackdropTemplate")
frame:SetSize(500, 400)
frame:SetPoint("CENTER")
frame:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})

frame:SetBackdropColor(0,0,0,0.95)
frame:SetBackdropBorderColor(1, 0.82, 0, 1)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:Hide()
table.insert(UISpecialFrames, "MidnightTrackerFrame")

local titlePanel = CreateFrame("Frame", "MidnightTitlePanel", frame, "BackdropTemplate")
titlePanel:SetSize(200, 36)
titlePanel:SetPoint("BOTTOM", frame, "TOP", 0, 4)
titlePanel:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
titlePanel:SetBackdropColor(0,0,0,0.95)
titlePanel:SetBackdropBorderColor(1, 0.82, 0, 1)

local title = titlePanel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("CENTER", titlePanel, "CENTER", 0, 0)
title:SetText(MidnightL.S("title"))
C_Timer.After(0, function()
    local w = title:GetStringWidth() or 200
    titlePanel:SetSize(w + 24, 36)
end)
titlePanel:Hide()

local menuWidth = 110

local ilvlPanel = CreateFrame("Frame", "MidnightIlvlPanel", frame, "BackdropTemplate")
ilvlPanel:SetSize(menuWidth, 50)
ilvlPanel:SetPoint("TOPLEFT", frame, "TOPRIGHT", 10, -36)
ilvlPanel:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
ilvlPanel:SetBackdropColor(0,0,0,0.95)
ilvlPanel:SetBackdropBorderColor(1, 0.82, 0, 1)

local ilvlTitle = ilvlPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
ilvlTitle:SetPoint("CENTER", ilvlPanel, "CENTER", 0, 9)
ilvlTitle:SetJustifyH("CENTER")
ilvlTitle:SetText(MidnightL.S("ilvl_label"))
ilvlTitle:SetTextColor(1, 0.82, 0)

local ilvlText = ilvlPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
ilvlText:SetPoint("CENTER", ilvlPanel, "CENTER", 0, -5)
ilvlText:SetJustifyH("CENTER")
ilvlText:SetText("...")
ilvlText:SetTextColor(1, 1, 1)

local menu = CreateFrame("Frame", "MidnightSummaryMenu", frame, "BackdropTemplate")
menu:SetSize(menuWidth, 220)
menu:SetPoint("TOPLEFT", ilvlPanel, "BOTTOMLEFT", 0, -4)
menu:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
menu:SetBackdropColor(0,0,0,0.95)
menu:SetBackdropBorderColor(1, 0.82, 0, 1)

local menuContent = CreateFrame("Frame", nil, menu)
menuContent:SetPoint("TOPLEFT", 8, -8)
menuContent:SetPoint("BOTTOMRIGHT", -8, 8)

local function getCrestInfo(currencyID)
    if currencyID and currencyID > 0 and C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
        local info = C_CurrencyInfo.GetCurrencyInfo(currencyID)
        if info then
            return info.quantity or 0, info.maxQuantity or 0
        end
    end
    return 0, 0
end

local crestPanel = CreateFrame("Frame", "MidnightCrestPanel", frame, "BackdropTemplate")
crestPanel:SetHeight(38)
crestPanel:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, 4)
crestPanel:SetPoint("TOPRIGHT", frame, "BOTTOMRIGHT", 0, 4)
crestPanel:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
crestPanel:SetBackdropColor(0,0,0,0.95)
crestPanel:SetBackdropBorderColor(1, 0.82, 0, 1)

local currencyRows = {
    { key = "adventurer", color = "7FB8FF", currID = 3383, icon = "Interface\\Icons\\inv_120_crest_adventurer" },
    { key = "veteran",    color = "C0A0FF", currID = 3341, icon = "Interface\\Icons\\inv_120_crest_veteran" },
    { key = "champion",   color = "ff3b3b", currID = 3343, icon = "Interface\\Icons\\inv_120_crest_champion" },
    { key = "heroic",     color = "FFB86A", currID = 3345, icon = "Interface\\Icons\\inv_120_crest_hero" },
    { key = "mythic",     color = "FFE07A", currID = 3347, icon = "Interface\\Icons\\inv_120_crest_myth" },
    { key = "sparks",     color = "FFD100", itemID = 232875, icon = "Interface\\Icons\\inv_12_profession_questandcrafting_sparkwhole_gold" },
}

local crestLineRows = {}
local crestContent = CreateFrame("Frame", nil, crestPanel)
crestContent:SetPoint("TOPLEFT", 10, 0)
crestContent:SetPoint("BOTTOMRIGHT", -10, 0)

local currencyNames = {
    adventurer = { fr = "Ecu de l'aube d'aventurier", en = "Adventurer Dawn Crest" },
    veteran    = { fr = "Ecu de l'aube vétéran", en = "Veteran Dawn Crest" },
    champion   = { fr = "Ecu de l'aube de champion", en = "Champion Dawn Crest" },
    heroic     = { fr = "Ecu de l'aube héroïque", en = "Heroic Dawn Crest" },
    mythic     = { fr = "Ecu de l'aube mythique", en = "Mythic Dawn Crest" },
    sparks     = { fr = "Etincelle de radiance", en = "Spark of Radiance" },
}

local crestIconButtons = {}
for i, cr in ipairs(currencyRows) do
    local btn = CreateFrame("Button", nil, crestContent)
    btn:SetSize(20, 20)
    btn:EnableMouse(true)
    local tex = btn:CreateTexture(nil, "ARTWORK")
    tex:SetAllPoints()
    tex:SetTexture(cr.icon)
    local valFs = crestContent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    valFs:SetJustifyH("CENTER")
    valFs:SetWordWrap(false)
    crestLineRows[cr.key] = { fs = valFs, btn = btn, currID = cr.currID, itemID = cr.itemID, color = cr.color, icon = cr.icon, idx = i }
    crestIconButtons[i] = { btn = btn, valFs = valFs, cr = cr }

    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:ClearLines()
        local loc = MidnightL.GetLocale()
        local name = currencyNames[cr.key] and currencyNames[cr.key][loc] or cr.key
        local cur
        if cr.itemID then
            cur = GetItemCount and GetItemCount(cr.itemID, true) or 0
        else
            cur = getCrestInfo(cr.currID)
        end
        GameTooltip:AddLine("|T" .. cr.icon .. ":16:16:0:0|t " .. name, 1, 0.82, 0)
        GameTooltip:AddLine("|cffffffff" .. tostring(cur) .. "|r", 1, 1, 1)
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local weekEstimatedIlvl = {}
local weekScrolls = {}
local menuButtons = {}
local activeMenuIndex = nil

local function parseEstimatedIlvl(objectives)
    for _, obj in ipairs(objectives) do
        local totalIlvl, totalCount = 0, 0
        for count, ilvl in obj:gmatch("(%d+)%s*x%s*(%d+)") do
            local n = tonumber(count)
            local v = tonumber(ilvl)
            if n and v and v >= 200 and v <= 350 then
                totalIlvl = totalIlvl + (n * v)
                totalCount = totalCount + n
            end
        end
        if totalCount >= 10 then
            return math.floor((totalIlvl / totalCount) * 10 + 0.5) / 10
        end
    end
    return nil
end

local function UpdateIlvlPanel()
    local currentIlvl = 0
    if GetAverageItemLevel then
        local _, equipped = GetAverageItemLevel()
        currentIlvl = math.floor((equipped or 0) + 0.5)
    end
    local idx = activeMenuIndex or 1
    local estimated = weekEstimatedIlvl[idx]
    if estimated then
        ilvlText:SetText("|cffffffff" .. currentIlvl .. "|r / |cffFFD100" .. estimated .. "|r")
    else
        ilvlText:SetText("|cffffffff" .. currentIlvl .. "|r / |cff888888" .. MidnightL.S("ilvl_no_data") .. "|r")
    end
end

local function UpdateCrestPanel()
    local nItems = #currencyRows
    local totalW = crestContent:GetWidth() or (frame:GetWidth() - 20)
    local iconSize = 20
    local iconValGap = 3
    local itemSpacing = 12
    local valEstW = 22
    local itemW = iconSize + iconValGap + valEstW
    local totalItemsW = nItems * itemW + (nItems - 1) * itemSpacing
    local startX = math.floor((totalW - totalItemsW) / 2)
    if startX < 0 then startX = 0 end

    for i, cr in ipairs(currencyRows) do
        local entry = crestLineRows[cr.key]
        if entry then
            local cur
            if entry.itemID then
                cur = GetItemCount and GetItemCount(entry.itemID, true) or 0
            else
                cur = getCrestInfo(entry.currID)
            end
            local valStr = tostring(cur)
            local valColor = cur <= 0 and "ffff4040" or "ffffd34d"

            local x = startX + (i - 1) * (itemW + itemSpacing)
            entry.btn:ClearAllPoints()
            entry.btn:SetPoint("LEFT", crestContent, "LEFT", x, 0)
            entry.btn:SetSize(iconSize, iconSize)
            entry.btn:Show()

            entry.fs:ClearAllPoints()
            entry.fs:SetPoint("LEFT", entry.btn, "RIGHT", iconValGap, 0)
            entry.fs:SetText("|c" .. valColor .. valStr .. "|r")
        end
    end
end

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
        UpdateIlvlPanel()
        UpdateCrestPanel()
    end
end

local poll = { last = -1, timer = 0 }
local ilvlPoll = { timer = 0 }
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

ilvlPanel:SetScript("OnUpdate", function(self, elapsed)
    ilvlPoll.timer = ilvlPoll.timer + (elapsed or 0)
    if ilvlPoll.timer < 2 then return end
    ilvlPoll.timer = 0
    UpdateIlvlPanel()
    UpdateCrestPanel()
end)

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

local function isWeekFullyChecked(weekIndex, objectives)
    if not objectives or #objectives == 0 then return false end
    local summaryPrefixPatterns = getSummaryPatterns()
    local hasCheckable = false
    for oIndex, objective in ipairs(objectives) do
        local isSummary = false
        for _, pat in ipairs(summaryPrefixPatterns) do
            if objective:match(pat) then
                isSummary = true
                break
            end
        end
        if not isSummary then
            hasCheckable = true
            local checkKey = "w" .. weekIndex .. "_" .. oIndex
            if not MidnightTrackerDB.checks[checkKey] then
                return false
            end
        end
    end
    return hasCheckable
end

local function CreateObjective(parent, text, index, yOffset, weekIndex)
    local function colorizeText(s)
        if not s or s == "" then return s end
        local loc = MidnightL.GetLocale()
        local cAdv = MidnightL.C("adventurer")
        local cVet = MidnightL.C("veteran")
        local cChamp = MidnightL.C("champion")
        local cHero = MidnightL.C("heroic")
        local cMyth = MidnightL.C("mythic")
        local ph = {}
        if loc == "en" then
            s = s:gsub('[Cc]hampion [Dd]awn [Cc]rest[s]?', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_champion:14:14:0:0|t |cff'..cChamp..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('[Vv]eteran [Dd]awn [Cc]rest[s]?', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_veteran:14:14:0:0|t |cff'..cVet..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('[Hh]eroic [Dd]awn [Cc]rest[s]?', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_hero:14:14:0:0|t |cff'..cHero..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('[Mm]ythic [Dd]awn [Cc]rest[s]?', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_myth:14:14:0:0|t |cff'..cMyth..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub("[Aa]dventur[^ %.,%(]*", "|cff" .. cAdv .. "%0|r")
            s = s:gsub("%f[%a][Hh]eroic%f[%A]", "|cff" .. cHero .. "%0|r")
            s = s:gsub("%f[%a][Mm]ythic%f[%A]", "|cff" .. cMyth .. "%0|r")
            s = s:gsub("%f[%a][Vv]eteran%f[%A]", "|cff" .. cVet .. "%0|r")
            s = s:gsub("%f[%a][Cc]hampion%f[%A]", "|cff" .. cChamp .. "%0|r")
            s = s:gsub("%f[%a][Hh]ero%f[%A]", "|cff" .. cHero .. "%0|r")
            s = s:gsub("%f[%a][Mm]yth%f[%A]", "|cff" .. cMyth .. "%0|r")
        else
            s = s:gsub('[Ee]cus? de l.aube de [Cc]hampion', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_champion:14:14:0:0|t |cff'..cChamp..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('Écus? de l.aube de [Cc]hampion',   function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_champion:14:14:0:0|t |cff'..cChamp..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('[Ee]cus? de l.aube [Vv]étéran',    function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_veteran:14:14:0:0|t |cff'..cVet..m..'|r';   return '@@PH'..#ph..'@@' end)
            s = s:gsub('Écus? de l.aube [Vv]étéran',       function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_veteran:14:14:0:0|t |cff'..cVet..m..'|r';   return '@@PH'..#ph..'@@' end)
            s = s:gsub('[Ee]cus? de l.aube [Hh]éroïque',   function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_hero:14:14:0:0|t |cff'..cHero..m..'|r';    return '@@PH'..#ph..'@@' end)
            s = s:gsub('Écus? de l.aube [Hh]éroïque',      function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_hero:14:14:0:0|t |cff'..cHero..m..'|r';    return '@@PH'..#ph..'@@' end)
            s = s:gsub('[Ee]cus? de l.aube mythique',       function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_myth:14:14:0:0|t |cff'..cMyth..m..'|r';    return '@@PH'..#ph..'@@' end)
            s = s:gsub('Écus? de l.aube mythique',          function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_myth:14:14:0:0|t |cff'..cMyth..m..'|r';    return '@@PH'..#ph..'@@' end)
            s = s:gsub("[Aa]vent[^ %.,%(]*", "|cff" .. cAdv .. "%0|r")
            s = s:gsub("Héroïque",  "|cff" .. cHero .. "%0|r")
            s = s:gsub("héroïque",  "|cff" .. cHero .. "%0|r")
            s = s:gsub("Heroïque",  "|cff" .. cHero .. "%0|r")
            s = s:gsub("heroïque",  "|cff" .. cHero .. "%0|r")
            s = s:gsub("Héroique",  "|cff" .. cHero .. "%0|r")
            s = s:gsub("heroique",  "|cff" .. cHero .. "%0|r")
            s = s:gsub("Vétéran",   "|cff" .. cVet  .. "%0|r")
            s = s:gsub("vétéran",   "|cff" .. cVet  .. "%0|r")
            s = s:gsub("%f[%a][Mm]ythe%f[%A]",   "|cff" .. cMyth  .. "%0|r")
            s = s:gsub("%f[%a][Cc]hampion%f[%A]", "|cff" .. cChamp .. "%0|r")
        end
        if #ph > 0 then
            s = s:gsub("@@PH(%d+)@@", function(n) return ph[tonumber(n)] end)
        end
        return s
    end

    local function highlightPrefix(s)
        if not s then return s end
        local prefix, rest = s:match("^(.-:)%s*(.*)$")
        if prefix then
            prefix = "|cff" .. MidnightL.C("prefix") .. prefix .. "|r"
            if rest == "" then
                return prefix
            else
                return prefix .. " " .. colorizeText(rest)
            end
        end
        return colorizeText(s)
    end

    local summaryPrefixPatterns = getSummaryPatterns()
    for _, pat in ipairs(summaryPrefixPatterns) do
        if text:match(pat) then
            local prefix, rest = text:match("^(.-:)%s*(.*)$")
            prefix = prefix or text
            rest = rest or ""
            local display = "|cffFFD100" .. prefix .. "|r"
            if rest ~= "" then
                local coloredRest
                if pat:find("Niveau d") or pat:find("Estimated gear") then
                    local stripped = rest:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
                    coloredRest = "|cffffffff" .. stripped .. "|r"
                else
                    coloredRest = colorizeText(rest) or rest
                    coloredRest = coloredRest:gsub("(%d+/%d+)", "|cffffffff%1|r")
                    coloredRest = coloredRest:gsub("(%s)et(%s)", "%1|cffffffffet|r%2")
                    coloredRest = coloredRest:gsub("(%s)and(%s)", "%1|cffffffffand|r%2")
                end

                display = display .. " " .. coloredRest

                local centerLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
                local leftPad = 10
                centerLabel:SetWidth(computeAvailableW(leftPad))
                centerLabel:SetJustifyH("LEFT")
                centerLabel:SetWordWrap(true)
                centerLabel:SetText(display)
                centerLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", leftPad, yOffset)

                return centerLabel:GetStringHeight() + 12
            end

            local centerLabel = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            local leftPad = 10
            centerLabel:SetWidth(computeAvailableW(leftPad))
            centerLabel:SetJustifyH("LEFT")
            centerLabel:SetWordWrap(true)
            centerLabel:SetText(display)
            centerLabel:SetPoint("TOPLEFT", parent, "TOPLEFT", leftPad, yOffset)
            return centerLabel:GetStringHeight() + 12
        end
    end

    local checkKey = "w" .. weekIndex .. "_" .. index
    local isChecked = MidnightTrackerDB.checks[checkKey] or false

    local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    cb:SetSize(20, 20)
    cb:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, yOffset + 3)
    cb:SetChecked(isChecked)
    cb:SetFrameLevel(parent:GetFrameLevel() + 2)

    local num = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    num:SetPoint("TOPLEFT", parent, "TOPLEFT", 22, yOffset)
    num:SetText(index .. ".")
    num:SetTextColor(1, 0.82, 0)

    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", 42, yOffset)
    do
        local offset = 42
        label:SetWidth(computeAvailableW(offset))
    end
    label:SetJustifyH("LEFT")
    label:SetWordWrap(true)
    label:SetTextColor(1,1,1)

    label:SetText(highlightPrefix(text))

    local function applyCheckState(checked)
        if checked then
            label:SetAlpha(0.35)
            num:SetAlpha(0.35)
        else
            label:SetAlpha(1)
            num:SetAlpha(1)
        end
    end

    applyCheckState(isChecked)

    cb:SetScript("OnClick", function(self)
        local checked = self:GetChecked()
        MidnightTrackerDB.checks[checkKey] = checked or nil
        applyCheckState(checked)
        if checked and Midnight.weekInfo and Midnight.weekInfo[weekIndex] then
            if isWeekFullyChecked(weekIndex, Midnight.weekInfo[weekIndex]) then
                C_Timer.After(0.3, function() Midnight:Refresh() end)
            end
        end
    end)

    Midnight.allCheckboxes = Midnight.allCheckboxes or {}
    table.insert(Midnight.allCheckboxes, { cb = cb, applyFn = applyCheckState })

    return label:GetStringHeight() + 12
end

function Midnight:Refresh()
    Midnight.allCheckboxes = {}
    content:Hide()
    content:SetSize(1,1)

    for _, c in ipairs({content:GetChildren()}) do
        c:Hide()
        c:SetParent(nil)
    end
    for _, r in ipairs({content:GetRegions()}) do
        r:Hide()
        r:SetParent(nil)
    end

    weekScrolls = {}

    if not frame or not frame:IsShown() then
        poll.last = -1
        poll.timer = 0
        return
    end
    local yOffset = -10

    local weeks = getWeeks()
    Midnight.weekInfo = {}
    local visibleWeeks = {}
    for wIndex, week in ipairs(weeks) do
        Midnight.weekInfo[wIndex] = week.objectives
        if not isWeekFullyChecked(wIndex, week.objectives) then
            table.insert(visibleWeeks, wIndex)
        end
    end

    for vIdx, wIndex in ipairs(visibleWeeks) do
        local week = weeks[wIndex]

        if vIdx > 1 then
            yOffset = yOffset - 20
        end

        local contentW = math.max(100, (scrollFrame:GetWidth() or 0) - 4)
        if contentW < 10 then contentW = 430 end
        local titleBg = content:CreateTexture(nil, "BACKGROUND")
        titleBg:SetColorTexture(1, 0.78, 0, 0.18)
        titleBg:SetPoint("TOPLEFT", content, "TOPLEFT", -2, yOffset)
        titleBg:SetSize(contentW + 2, 26)

        local weekTitle = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
        weekTitle:SetPoint("TOPLEFT", content, "TOPLEFT", -2, yOffset)
        weekTitle:SetWidth(contentW + 2)
        weekTitle:SetHeight(26)
        weekTitle:SetJustifyH("CENTER")
        weekTitle:SetJustifyV("MIDDLE")
        weekTitle:SetText(week.title)
        weekTitle:SetTextColor(1, 0.82, 0)
        
        weekScrolls[vIdx] = -yOffset - 4
        yOffset = yOffset - 30

            for oIndex, objective in ipairs(week.objectives) do
                local height = CreateObjective(content, objective, oIndex, yOffset, wIndex)
                yOffset = yOffset - height
            end
    end

    yOffset = yOffset - 10

    content:SetHeight(-yOffset)
    content:Show()
    
    for _, c in ipairs({menuContent:GetChildren()}) do c:Hide(); c:SetParent(nil) end
    
    menuButtons = {}
    local menuLabels = getMenuLabels()
    for vIdx, wIndex in ipairs(visibleWeeks) do
        local week = weeks[wIndex]
        local btn = CreateFrame("Button", nil, menuContent)
        btn:SetSize(menuWidth - 16, 18)
        btn:SetPoint("TOPLEFT", 0, -((vIdx - 1) * 20))
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
        txt:SetText(menuLabels[wIndex] or week.title or ("Week " .. wIndex))
        txt:SetTextColor(1,1,1)

        menuButtons[vIdx] = { btn = btn, txt = txt, bullet = bullet }

        btn:SetScript("OnClick", function()
            activeMenuIndex = vIdx
            UpdateMenuActive()
            UpdateIlvlPanel()
            UpdateCrestPanel()
            ScrollToWeek(vIdx)
        end)
        btn:SetScript("OnEnter", function(self)
            if menuButtons[vIdx] and menuButtons[vIdx].txt then
                menuButtons[vIdx].txt:SetTextColor(1, 0.82, 0)
            end
            if self.LockHighlight then self:LockHighlight() end
        end)
        btn:SetScript("OnLeave", function(self)
            if activeMenuIndex == vIdx then
                if menuButtons[vIdx] and menuButtons[vIdx].txt then menuButtons[vIdx].txt:SetTextColor(1, 0.82, 0) end
            else
                if menuButtons[vIdx] and menuButtons[vIdx].txt then menuButtons[vIdx].txt:SetTextColor(1,1,1) end
            end
            if self.UnlockHighlight then self:UnlockHighlight() end
        end)
    end
    
    weekEstimatedIlvl = {}
    for vIdx, wIndex in ipairs(visibleWeeks) do
        weekEstimatedIlvl[vIdx] = parseEstimatedIlvl(weeks[wIndex].objectives)
    end

    activeMenuIndex = (#visibleWeeks > 0) and 1 or nil
    UpdateMenuActive()
    UpdateIlvlPanel()
    UpdateCrestPanel()
end

local function createLetterButton(letter, xOff, yOff, onClick, title, desc)
    local btn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    btn:SetSize(20, 20)
    btn:SetPoint("TOPLEFT", frame, "TOPLEFT", xOff, yOff)
    btn:SetText(letter)
    btn:SetNormalFontObject("GameFontNormalSmall")
    btn:SetHighlightFontObject("GameFontNormalSmall")

    local fs = btn:GetFontString()
    if fs then
        fs:ClearAllPoints()
        fs:SetPoint("CENTER", 0, 0)
        fs:SetJustifyH("CENTER")
        fs:SetJustifyV("MIDDLE")
    end

    btn:SetScript("OnClick", onClick)
    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_NONE")
        GameTooltip:SetPoint("TOPRIGHT", frame, "TOPLEFT", -4, 0)
        GameTooltip:ClearLines()
        if title then GameTooltip:AddLine(title) end
        if desc then GameTooltip:AddLine(desc, 1,1,1, true) end
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
    btn:SetFrameLevel(frame:GetFrameLevel() + 5)
    return btn
end

local discordButton = createLetterButton("D", 10, -10,
    function()
        if ChatEdit_ChooseBoxForSend then
            local editBox = ChatEdit_ChooseBoxForSend()
            ChatEdit_ActivateChat(editBox)
            editBox:Insert("https://discord.gg/D7zMBtPfGn")
            editBox:HighlightText()
        end
    end,
    "Discord",
    MidnightL.S("discord_desc"))

local twitchButton = createLetterButton("T", 54, -10,
    function()
        if ChatEdit_ChooseBoxForSend then
            local editBox = ChatEdit_ChooseBoxForSend()
            ChatEdit_ActivateChat(editBox)
            editBox:Insert("twitch.tv/poulpi_x")
            editBox:HighlightText()
        end
    end,
    "Twitch",
    MidnightL.S("twitch_desc"))

local resourcesButton = createLetterButton("?", 76, -10,
    function() end,
    MidnightL.S("resources"),
    MidnightL.S("resources_short_desc"))

local xButton = createLetterButton("X", 32, -10,
    function()
        if ChatEdit_ChooseBoxForSend then
            local editBox = ChatEdit_ChooseBoxForSend()
            ChatEdit_ActivateChat(editBox)
            editBox:Insert("https://x.com/poulpi_x")
            editBox:HighlightText()
        end
    end,
    "X",
    MidnightL.S("x_desc"))

local resetButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
resetButton:SetSize(42, 20)
resetButton:SetPoint("TOPLEFT", frame, "TOPLEFT", 98, -10)
resetButton:SetText("Reset")
resetButton:SetNormalFontObject("GameFontNormalSmall")
resetButton:SetHighlightFontObject("GameFontNormalSmall")
resetButton:SetScript("OnClick", function()
    MidnightTrackerDB.checks = {}
    Midnight:Refresh()
end)
resetButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_NONE")
    GameTooltip:SetPoint("TOPRIGHT", frame, "TOPLEFT", -4, 0)
    GameTooltip:ClearLines()
    GameTooltip:AddLine(MidnightL.S("reset_checks"))
    GameTooltip:AddLine(MidnightL.S("reset_checks_desc"), 1,1,1, true)
    GameTooltip:Show()
end)
resetButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
resetButton:SetFrameLevel(frame:GetFrameLevel() + 5)

local ilvlRefButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
ilvlRefButton:SetSize(42, 20)
ilvlRefButton:SetText(MidnightL.S("ilvl_button"))
ilvlRefButton:SetNormalFontObject("GameFontNormalSmall")
ilvlRefButton:SetHighlightFontObject("GameFontNormalSmall")
ilvlRefButton:SetScript("OnClick", function()
    if MidnightIlvl and MidnightIlvl.Show and MidnightIlvl.Hide then
        if MidnightIlvlFrame and MidnightIlvlFrame:IsShown() then
            MidnightIlvl.Hide()
        else
            MidnightIlvl.Show()
        end
    end
end)
ilvlRefButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_NONE")
    GameTooltip:SetPoint("TOPRIGHT", frame, "TOPLEFT", -4, 0)
    GameTooltip:ClearLines()
    GameTooltip:AddLine(MidnightL.S("ilvl_button_title"))
    GameTooltip:AddLine(MidnightL.S("ilvl_button_desc"), 1,1,1, true)
    GameTooltip:Show()
end)
ilvlRefButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
ilvlRefButton:SetFrameLevel(frame:GetFrameLevel() + 5)

local SCALE_MIN = 0.6
local SCALE_MAX = 1.6
local SCALE_STEP = 0.05

local function ApplyMidnightScale(scale)
    scale = math.max(SCALE_MIN, math.min(SCALE_MAX, scale))
    MidnightTrackerDB.scale = scale
    frame:SetScale(scale)
    if MidnightMplusFrame and MidnightMplusFrame.SetScale then
        MidnightMplusFrame:SetScale(scale)
    end
    if MidnightPlanningContenuFrame and MidnightPlanningContenuFrame.SetScale then
        MidnightPlanningContenuFrame:SetScale(scale)
    end
    if MidnightIlvlFrame and MidnightIlvlFrame.SetScale then
        MidnightIlvlFrame:SetScale(scale)
    end
    C_Timer.After(0, function()
        if MidnightMplusFrame and MidnightMplusFrame:IsShown() and MidnightMplus then
            MidnightMplus.Show()
        end
        if MidnightPlanningContenuFrame and MidnightPlanningContenuFrame:IsShown() and MidnightPlanningContenu then
            MidnightPlanningContenu.Show()
        end
        if MidnightIlvlFrame and MidnightIlvlFrame:IsShown() and MidnightIlvl then
            MidnightIlvl.Show()
        end
    end)
end

local scaleDownBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
scaleDownBtn:SetSize(20, 20)
scaleDownBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -30, 22)
scaleDownBtn:SetText("-")
scaleDownBtn:SetNormalFontObject("GameFontNormalSmall")
scaleDownBtn:SetHighlightFontObject("GameFontNormalSmall")
scaleDownBtn:SetFrameLevel(frame:GetFrameLevel() + 5)
scaleDownBtn:SetScript("OnClick", function(self, button)
    if button == "RightButton" then
        ApplyMidnightScale(1.0)
    else
        local cur = MidnightTrackerDB.scale or 1.0
        ApplyMidnightScale(cur - SCALE_STEP)
    end
end)
scaleDownBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")

local scaleUpBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
scaleUpBtn:SetSize(20, 20)
scaleUpBtn:SetPoint("LEFT", scaleDownBtn, "RIGHT", 2, 0)
scaleUpBtn:SetText("+")
scaleUpBtn:SetNormalFontObject("GameFontNormalSmall")
scaleUpBtn:SetHighlightFontObject("GameFontNormalSmall")
scaleUpBtn:SetFrameLevel(frame:GetFrameLevel() + 5)
scaleUpBtn:SetScript("OnClick", function(self, button)
    if button == "RightButton" then
        ApplyMidnightScale(1.0)
    else
        local cur = MidnightTrackerDB.scale or 1.0
        ApplyMidnightScale(cur + SCALE_STEP)
    end
end)
scaleUpBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")

local helpBtn = CreateFrame("Button", nil, frame)
helpBtn:SetSize(20, 20)
helpBtn:SetPoint("TOPRIGHT", menu, "TOPRIGHT", 6, 6)
helpBtn:SetNormalTexture("Interface/Common/help-i")
helpBtn:SetHighlightTexture("Interface/Common/help-i")
helpBtn:GetHighlightTexture():SetAlpha(0.4)
helpBtn:SetFrameLevel(menu:GetFrameLevel() + 5)
helpBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:ClearLines()
    GameTooltip:AddLine("Info")
    GameTooltip:AddLine(MidnightL.S("reset_info"), 1,1,1, true)
    GameTooltip:Show()
end)
helpBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -6, -6)
closeBtn:SetScript("OnClick", function()
    frame:Hide()
end)
closeBtn:SetFrameLevel(frame:GetFrameLevel() + 5)

local planningButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
planningButton:SetSize(28, 20)
planningButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -34, -10)
planningButton:SetText("|TInterface\\Icons\\INV_Misc_Note_01:14:14:0:0|t")
planningButton:SetScript("OnClick", function()
    if MidnightPlanningContenu and MidnightPlanningContenu.Show and MidnightPlanningContenu.Hide then
        if MidnightPlanningContenuFrame and MidnightPlanningContenuFrame:IsShown() then
            MidnightPlanningContenu.Hide()
        else
            MidnightPlanningContenu.Show()
        end
    end
end)
planningButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_NONE")
    GameTooltip:SetPoint("TOPRIGHT", frame, "TOPLEFT", -4, 0)
    GameTooltip:ClearLines()
    GameTooltip:AddLine(MidnightL.S("planning_title"))
    GameTooltip:Show()
end)
planningButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
planningButton:SetFrameLevel(frame:GetFrameLevel() + 5)

ilvlRefButton:ClearAllPoints()
ilvlRefButton:SetPoint("TOPRIGHT", planningButton, "TOPLEFT", -2, 0)

local mplusButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
mplusButton:SetSize(43, 20)
mplusButton:SetPoint("TOPRIGHT", ilvlRefButton, "TOPLEFT", -2, 0)
mplusButton:SetText(MidnightL.S("crests"))
mplusButton:SetScript("OnClick", function()
    if MidnightMplus and MidnightMplus.Show and MidnightMplus.Hide then
        if MidnightMplusFrame and MidnightMplusFrame:IsShown() then
            MidnightMplus.Hide()
        else
            MidnightMplus.Show()
        end
    end
end)
mplusButton:SetFrameLevel(frame:GetFrameLevel() + 5)

local cbSettingsFrame = CreateFrame("Frame", "MidnightColorblindFrame", UIParent, "BackdropTemplate")
cbSettingsFrame:SetSize(185, 250)
cbSettingsFrame:SetPoint("TOPRIGHT", frame, "TOPLEFT", -10, 0)
cbSettingsFrame:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
cbSettingsFrame:SetBackdropColor(0, 0, 0, 0.95)
cbSettingsFrame:SetBackdropBorderColor(1, 0.82, 0, 1)
cbSettingsFrame:SetFrameStrata("DIALOG")
cbSettingsFrame:EnableMouse(true)
cbSettingsFrame:Hide()
table.insert(UISpecialFrames, "MidnightColorblindFrame")

local cbTitle = cbSettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
cbTitle:SetPoint("TOP", cbSettingsFrame, "TOP", 0, -14)
cbTitle:SetText(MidnightL.S("colorblind_title"))
cbTitle:SetTextColor(1, 0.82, 0)

local cbCloseBtn = CreateFrame("Button", nil, cbSettingsFrame, "UIPanelCloseButton")
cbCloseBtn:SetPoint("TOPRIGHT", cbSettingsFrame, "TOPRIGHT", -2, -2)
cbCloseBtn:SetScript("OnClick", function() cbSettingsFrame:Hide() end)

local cbRadioButtons = {}
local cbModes = MidnightL.ColorblindModes

local function UpdateCBRadios()
    local current = MidnightL.GetColorblindMode()
    for _, entry in ipairs(cbRadioButtons) do
        entry.cb:SetChecked(entry.mode == current)
    end
end

local function ApplyColorblindMode(mode)
    MidnightTrackerDB.colorblindMode = mode
    MidnightL.SetColorblindMode(mode)
    UpdateCBRadios()
    if Midnight and Midnight.Refresh then Midnight:Refresh() end
    if MidnightPlanningContenu and MidnightPlanningContenuFrame and MidnightPlanningContenuFrame:IsShown() and MidnightPlanningContenu.Show then
        MidnightPlanningContenu.Show()
    end
    if MidnightMplus and MidnightMplusFrame and MidnightMplusFrame:IsShown() and MidnightMplus.Show then
        MidnightMplus.Show()
    end
end

for i, mode in ipairs(cbModes) do
    local yOff = -36 - (i - 1) * 28

    local cb = CreateFrame("CheckButton", nil, cbSettingsFrame)
    cb:SetSize(18, 18)
    cb:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, yOff)
    cb:SetFrameLevel(cbSettingsFrame:GetFrameLevel() + 2)

    local bgTex = cb:CreateTexture(nil, "BACKGROUND")
    bgTex:SetAllPoints()
    bgTex:SetColorTexture(0.2, 0.2, 0.2, 0.8)

    local checkTex = cb:CreateTexture(nil, "OVERLAY")
    checkTex:SetSize(12, 12)
    checkTex:SetPoint("CENTER")
    checkTex:SetColorTexture(1, 0.82, 0, 1)
    cb:SetCheckedTexture(checkTex)

    local label = cbSettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("LEFT", cb, "RIGHT", 6, 0)
    label:SetText(MidnightL.S("colorblind_" .. mode))
    label:SetTextColor(1, 1, 1)

    cb:SetScript("OnClick", function()
        ApplyColorblindMode(mode)
    end)
    cb:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:ClearLines()
        GameTooltip:AddLine(MidnightL.S("colorblind_" .. mode), 1, 0.82, 0)
        GameTooltip:AddLine(MidnightL.S("colorblind_" .. mode .. "_desc"), 1, 1, 1, true)
        local palette = MidnightL.ColorPalettes[mode]
        if palette then
            GameTooltip:AddLine(" ")
            GameTooltip:AddLine("|cff" .. palette.adventurer .. "Adventurer|r  |cff" .. palette.veteran .. "Veteran|r  |cff" .. palette.champion .. "Champion|r")
            GameTooltip:AddLine("|cff" .. palette.heroic .. "Heroic|r  |cff" .. palette.mythic .. "Mythic|r  |cff" .. palette.spark .. "Spark|r")
        end
        GameTooltip:Show()
    end)
    cb:SetScript("OnLeave", function() GameTooltip:Hide() end)

    table.insert(cbRadioButtons, { cb = cb, mode = mode, label = label })
end

UpdateCBRadios()

local gearBtn = CreateFrame("Button", nil, frame)
gearBtn:SetSize(20, 20)
gearBtn:SetPoint("TOPRIGHT", mplusButton, "TOPLEFT", -4, 0)
gearBtn:SetNormalTexture("Interface\\Scenarios\\ScenarioIcon-Interact")
gearBtn:SetHighlightTexture("Interface\\Scenarios\\ScenarioIcon-Interact")
gearBtn:GetHighlightTexture():SetAlpha(0.4)
gearBtn:SetFrameLevel(frame:GetFrameLevel() + 5)
gearBtn:SetScript("OnClick", function()
    if cbSettingsFrame:IsShown() then
        cbSettingsFrame:Hide()
    else
        cbSettingsFrame:Show()
    end
end)

SLASH_MIDNIGHTTRACKER1 = "/som"
SlashCmdList["MIDNIGHTTRACKER"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
        Midnight:Refresh()
    end
end

C_Timer.After(0, function()
    local savedScale = MidnightTrackerDB.scale or 1.0
    ApplyMidnightScale(savedScale)
end)

local welcomeFrame = CreateFrame("Frame", "MidnightWelcomeFrame", UIParent, "BackdropTemplate")
welcomeFrame:SetSize(380, 110)
welcomeFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 60)
welcomeFrame:SetFrameStrata("DIALOG")
welcomeFrame:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
welcomeFrame:SetBackdropColor(0, 0, 0, 0.95)
welcomeFrame:SetBackdropBorderColor(1, 0.82, 0, 1)
welcomeFrame:Hide()

local welcomeTitle = welcomeFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
welcomeTitle:SetPoint("TOP", welcomeFrame, "TOP", 0, -14)
welcomeTitle:SetTextColor(1, 0.82, 0)

local welcomeMsg = welcomeFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
welcomeMsg:SetPoint("TOP", welcomeTitle, "BOTTOM", 0, -10)
welcomeMsg:SetWidth(340)
welcomeMsg:SetJustifyH("CENTER")
welcomeMsg:SetTextColor(1, 1, 1)

local welcomeOK = CreateFrame("Button", nil, welcomeFrame, "UIPanelButtonTemplate")
welcomeOK:SetSize(80, 22)
welcomeOK:SetPoint("BOTTOM", welcomeFrame, "BOTTOM", 0, 12)
welcomeOK:SetText("OK")
welcomeOK:SetScript("OnClick", function() welcomeFrame:Hide() end)

local welcomeEvent = CreateFrame("Frame")
welcomeEvent:RegisterEvent("PLAYER_ENTERING_WORLD")
welcomeEvent:SetScript("OnEvent", function()
    if MidnightTrackerDB.welcomeShown then return end
    MidnightTrackerDB.welcomeShown = true
    welcomeTitle:SetText(MidnightL.S("welcome_title"))
    welcomeMsg:SetText(MidnightL.S("welcome_msg"))
    C_Timer.After(2, function() welcomeFrame:Show() end)
end)

