local Midnight = {}
_G["MidnightTracker"] = Midnight

MidnightObjectiveTrackerDB = MidnightObjectiveTrackerDB or {}

do
    local function GetAddonVersion()
        if C_AddOns and C_AddOns.GetAddOnMetadata then
            return C_AddOns.GetAddOnMetadata("MidnightObjectiveTracker", "Version") or "0"
        elseif GetAddOnMetadata then
            return GetAddOnMetadata("MidnightObjectiveTracker", "Version") or "0"
        end
        return "0"
    end
    local currentVersion = GetAddonVersion()
    if MidnightObjectiveTrackerDB.addonVersion ~= currentVersion then
        MidnightObjectiveTrackerDB = {
            addonVersion  = currentVersion,
            checks        = MidnightObjectiveTrackerDB.checks,
            scale         = MidnightObjectiveTrackerDB.scale,
            opacity       = MidnightObjectiveTrackerDB.opacity,
            escCloses     = MidnightObjectiveTrackerDB.escCloses,
            minimapAngle  = MidnightObjectiveTrackerDB.minimapAngle,
            goldenBorder  = MidnightObjectiveTrackerDB.goldenBorder,
            titleColor    = MidnightObjectiveTrackerDB.titleColor,
            colorblindMode = MidnightObjectiveTrackerDB.colorblindMode,
            buttonBgColor  = MidnightObjectiveTrackerDB.buttonBgColor,
            windowBgColor  = MidnightObjectiveTrackerDB.windowBgColor,
            showCrestPanel = MidnightObjectiveTrackerDB.showCrestPanel,
            showVaultPanel = MidnightObjectiveTrackerDB.showVaultPanel,
        }
    end
end

MidnightObjectiveTrackerDB.checks = MidnightObjectiveTrackerDB.checks or {}
MidnightObjectiveTrackerDB.scale = MidnightObjectiveTrackerDB.scale or 1.0
MidnightObjectiveTrackerDB.opacity = MidnightObjectiveTrackerDB.opacity or 1.0
MidnightObjectiveTrackerDB.escCloses = (MidnightObjectiveTrackerDB.escCloses == nil) and false or MidnightObjectiveTrackerDB.escCloses
MidnightObjectiveTrackerDB.goldenBorder = (MidnightObjectiveTrackerDB.goldenBorder == nil) and true or MidnightObjectiveTrackerDB.goldenBorder
MidnightObjectiveTrackerDB.titleColor = MidnightObjectiveTrackerDB.titleColor or { r = 1, g = 0.82, b = 0 }
MidnightObjectiveTrackerDB.colorblindMode = MidnightObjectiveTrackerDB.colorblindMode or "none"
MidnightObjectiveTrackerDB.buttonBgColor  = MidnightObjectiveTrackerDB.buttonBgColor  or { r = 0.5, g = 0.0, b = 0.0 }
MidnightObjectiveTrackerDB.windowBgColor  = MidnightObjectiveTrackerDB.windowBgColor  or { r = 0, g = 0, b = 0 }
MidnightObjectiveTrackerDB.showCrestPanel = (MidnightObjectiveTrackerDB.showCrestPanel == nil) and true or MidnightObjectiveTrackerDB.showCrestPanel
MidnightObjectiveTrackerDB.showVaultPanel = (MidnightObjectiveTrackerDB.showVaultPanel == nil) and true or MidnightObjectiveTrackerDB.showVaultPanel

MidnightL.Init()
MidnightL.SetColorblindMode(MidnightObjectiveTrackerDB.colorblindMode)

local allBorderedFrames        = {}
local allTitleFontStrings      = {}
local allAccentTextures        = {}
local allButtonFontStrings     = {}
local allPanelButtons          = {}
local allAccentColorCallbacks  = {}
local allWindowBgFrames        = {}

local function GetAccentColor()
    local c = MidnightObjectiveTrackerDB.titleColor or { r = 1, g = 0.82, b = 0 }
    return c.r or 1, c.g or 0.82, c.b or 0
end

local function GetAccentColorHex()
    local r, g, b = GetAccentColor()
    return string.format("%02X%02X%02X",
        math.floor(r * 255 + 0.5),
        math.floor(g * 255 + 0.5),
        math.floor(b * 255 + 0.5))
end

local function RegisterBorderedFrame(f)
    table.insert(allBorderedFrames, f)
end

local function RegisterWindowBgFrame(f)
    table.insert(allWindowBgFrames, f)
end

local function RegisterTitleFontString(fs)
    table.insert(allTitleFontStrings, fs)
end

local function RegisterAccentTexture(tex)
    table.insert(allAccentTextures, tex)
end

local function RegisterButtonText(btn)
    local fs = btn and btn.GetFontString and btn:GetFontString()
    if fs then table.insert(allButtonFontStrings, fs) end
end

local function RegisterPanelButton(btn)
    if btn then
        for _, child in ipairs({btn:GetChildren()}) do
            if child and child.Hide then child:Hide() end
        end
        for _, region in ipairs({btn:GetRegions()}) do
            if region and region.GetObjectType and region:GetObjectType() == "Texture" then
                region:SetAlpha(0)
            end
        end
        local fs = btn:GetFontString()
        if fs then
            fs:ClearAllPoints()
            fs:SetPoint("TOPLEFT",     btn, "TOPLEFT",     0,  1)
            fs:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", 0,  1)
            fs:SetJustifyH("CENTER")
            fs:SetJustifyV("MIDDLE")
        end
        local c = MidnightObjectiveTrackerDB.buttonBgColor or { r = 0.5, g = 0, b = 0 }
        local bg = btn:CreateTexture(nil, "BACKGROUND", nil, -8)
        bg:SetAllPoints(btn)
        bg:SetColorTexture(c.r, c.g, c.b, 1)
        btn._midnightBg = bg
        table.insert(allPanelButtons, btn)
    end
end

local function RegisterAccentColorCallback(fn)
    table.insert(allAccentColorCallbacks, fn)
end

local ApplyMidnightBorder
local ApplyMidnightAccentColor

ApplyMidnightBorder = function(enabled)
    enabled = (enabled ~= false)
    MidnightObjectiveTrackerDB.goldenBorder = enabled
    local ar, ag, ab, aa
    if enabled then
        ar, ag, ab = GetAccentColor()
        aa = 1
    else
        ar, ag, ab, aa = 0, 0, 0, 0
    end
    for _, f in ipairs(allBorderedFrames) do
        if f and f.SetBackdropBorderColor then
            f:SetBackdropBorderColor(ar, ag, ab, aa)
        end
    end
end

ApplyMidnightAccentColor = function(r, g, b)
    MidnightObjectiveTrackerDB.titleColor = { r = r, g = g, b = b }
    if MidnightObjectiveTrackerDB.goldenBorder then
        ApplyMidnightBorder(true)
    end
    for _, entry in ipairs(allTitleFontStrings) do
        if entry and entry:GetObjectType() == "FontString" then
            entry:SetTextColor(r, g, b)
        end
    end
    for _, tex in ipairs(allAccentTextures) do
        if tex and tex.SetColorTexture then
            tex:SetColorTexture(r, g, b, 1)
        end
    end
    for _, fs in ipairs(allButtonFontStrings) do
        if fs and fs:GetObjectType() == "FontString" then
            fs:SetTextColor(r, g, b)
        end
    end
    for _, fn in ipairs(allAccentColorCallbacks) do
        pcall(fn, r, g, b)
    end
end

local ApplyButtonBgColor = function(r, g, b)
    MidnightObjectiveTrackerDB.buttonBgColor = { r = r, g = g, b = b }
    for _, btn in ipairs(allPanelButtons) do
        if btn and btn._midnightBg then
            btn._midnightBg:SetColorTexture(r, g, b, 1)
        end
    end
end

local function ApplyWindowBgColor(r, g, b)
    r = r or 0; g = g or 0; b = b or 0
    MidnightObjectiveTrackerDB.windowBgColor = { r = r, g = g, b = b }
    for _, f in ipairs(allWindowBgFrames) do
        if f and f.SetBackdropColor then
            f:SetBackdropColor(r, g, b, 1)
        end
    end
end

Midnight.RegisterBorderedFrame       = RegisterBorderedFrame
Midnight.RegisterWindowBgFrame       = RegisterWindowBgFrame
Midnight.RegisterTitleFontString     = RegisterTitleFontString
Midnight.RegisterAccentTexture       = RegisterAccentTexture
Midnight.RegisterButtonText          = RegisterButtonText
Midnight.RegisterPanelButton         = RegisterPanelButton
Midnight.RegisterAccentColorCallback = RegisterAccentColorCallback
Midnight.GetAccentColor              = GetAccentColor
Midnight.ApplyWindowBgColor          = function(r, g, b) ApplyWindowBgColor(r, g, b) end
Midnight.GetAccentColorHex           = GetAccentColorHex

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
    bgFile = "Interface/Buttons/WHITE8X8",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})

frame:SetBackdropColor(0,0,0,1)
frame:SetBackdropBorderColor(1, 0.82, 0, 1)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:Hide()
RegisterBorderedFrame(frame)
RegisterWindowBgFrame(frame)
frame:HookScript("OnShow", function()
    local wbc = MidnightObjectiveTrackerDB.windowBgColor or { r = 0, g = 0, b = 0 }
    ApplyWindowBgColor(wbc.r, wbc.g, wbc.b)
end)

local menuWidth = 110

local ilvlPanel = CreateFrame("Frame", "MidnightIlvlPanel", frame, "BackdropTemplate")
ilvlPanel:SetSize(menuWidth, 50)
ilvlPanel:SetPoint("TOPLEFT", frame, "TOPRIGHT", -6, 0)
ilvlPanel:SetBackdrop({
    bgFile = "Interface/Buttons/WHITE8X8",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
ilvlPanel:SetBackdropColor(0,0,0,1)
ilvlPanel:SetBackdropBorderColor(1, 0.82, 0, 1)
RegisterBorderedFrame(ilvlPanel)
RegisterWindowBgFrame(ilvlPanel)

local ilvlTitle = ilvlPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
ilvlTitle:SetPoint("CENTER", ilvlPanel, "CENTER", 0, 9)
ilvlTitle:SetJustifyH("CENTER")
ilvlTitle:SetText(MidnightL.S("ilvl_label"))
ilvlTitle:SetTextColor(1, 0.82, 0)
RegisterTitleFontString(ilvlTitle)

local ilvlText = ilvlPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
ilvlText:SetPoint("CENTER", ilvlPanel, "CENTER", 0, -5)
ilvlText:SetJustifyH("CENTER")
ilvlText:SetText("...")
ilvlText:SetTextColor(1, 1, 1)

local menu = CreateFrame("Frame", "MidnightSummaryMenu", frame, "BackdropTemplate")
menu:SetSize(menuWidth, 220)
menu:SetPoint("TOPLEFT", ilvlPanel, "BOTTOMLEFT", 0, 6)
menu:SetBackdrop({
    bgFile = "Interface/Buttons/WHITE8X8",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
menu:SetBackdropColor(0,0,0,1)
menu:SetBackdropBorderColor(1, 0.82, 0, 1)
RegisterBorderedFrame(menu)
RegisterWindowBgFrame(menu)

local menuContent = CreateFrame("Frame", nil, menu)
menuContent:SetPoint("TOPLEFT", 8, -8)
menuContent:SetPoint("BOTTOMRIGHT", -8, 8)

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
        ilvlText:SetText("|cffffffff" .. currentIlvl .. "|r / |cff" .. GetAccentColorHex() .. estimated .. "|r")
    else
        ilvlText:SetText("|cffffffff" .. currentIlvl .. "|r / |cff888888" .. MidnightL.S("ilvl_no_data") .. "|r")
    end
end

local function UpdateCrestPanel()
    if MidnightTracker.UpdateCrestPanel then MidnightTracker.UpdateCrestPanel() end
end

local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")

scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -36)
scrollFrame:SetPoint("BOTTOMRIGHT", -2, 10)

local content = CreateFrame("Frame", nil, scrollFrame)
content:SetSize(430, 1)
content:SetPoint("TOPLEFT", scrollFrame, "TOPLEFT", 2, -4)
scrollFrame:SetScrollChild(content)

C_Timer.After(0, function()
    local sb = scrollFrame.ScrollBar
    if sb then
        sb:SetAlpha(0)
        sb:EnableMouse(false)
        sb:Hide()
    end
end)

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
    local ar, ag, ab = GetAccentColor()
    for idx, entry in ipairs(menuButtons) do
        if entry and entry.txt then
            if idx == activeMenuIndex then
                entry.txt:SetTextColor(ar, ag, ab)
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

local menuNavGuard = false
local scrollTarget = nil
local smoothFrame  = CreateFrame("Frame")

local function activateScroll()
    smoothFrame:SetScript("OnUpdate", function(self, elapsed)
        if not scrollTarget then self:SetScript("OnUpdate", nil); return end
        local cur  = scrollFrame:GetVerticalScroll()
        local diff = scrollTarget - cur
        if math.abs(diff) < 1 then
            scrollFrame:SetVerticalScroll(scrollTarget)
            scrollTarget = nil
            self:SetScript("OnUpdate", nil)
            return
        end
        scrollFrame:SetVerticalScroll(cur + diff * math.min(1, elapsed * 12))
    end)
end

scrollFrame:EnableMouseWheel(true)
scrollFrame:SetScript("OnMouseWheel", function(self, delta)
    local cur = scrollTarget or self:GetVerticalScroll()
    local maxScroll = math.max(0, content:GetHeight() - self:GetHeight())
    scrollTarget = math.max(0, math.min(maxScroll, cur - delta * 40))
    activateScroll()
end)

local ilvlPoll = { timer = 0 }

scrollFrame:SetScript("OnVerticalScroll", function(self, value)
    if not menuNavGuard then
        UpdateMenuForScroll(value)
    end
end)

ilvlPanel:SetScript("OnUpdate", function(self, elapsed)
    if not frame:IsShown() then return end
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
    scrollTarget = target
    activateScroll()
end

local function isWeekFullyChecked(weekIndex, objectives)
    if not objectives or #objectives == 0 then return false end
    if not MidnightObjectiveTrackerDB.checks then return false end
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
            if not MidnightObjectiveTrackerDB.checks[checkKey] then
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
            s = s:gsub('[Aa]dventurer [Dd]awn [Cc]rests?', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_adventurer:14:14:0:0|t |cff'..cAdv..m..'|r'; return '@@PH'..#ph..'@@' end)
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
        elseif loc == "de" then
            s = s:gsub('[Hh]eroische[n]? Morgenwappen', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_hero:14:14:0:0|t |cff'..cHero..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('[Mm]ythische[n]? Morgenwappen', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_myth:14:14:0:0|t |cff'..cMyth..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('Champion%-Morgenwappen', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_champion:14:14:0:0|t |cff'..cChamp..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('Veteran%-Morgenwappen', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_veteran:14:14:0:0|t |cff'..cVet..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('Abenteurer%-Morgenwappen', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_adventurer:14:14:0:0|t |cff'..cAdv..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('[Aa]benteurer[^ %.,%(]*', "|cff" .. cAdv .. "%0|r")
            s = s:gsub('[Vv]eteran[^ %.,%(]*', "|cff" .. cVet .. "%0|r")
            s = s:gsub('[Cc]hampion[^ %.,%(]*', "|cff" .. cChamp .. "%0|r")
            s = s:gsub('[Hh]eld[^ %.,%(]*', "|cff" .. cHero .. "%0|r")
            s = s:gsub('[Hh]eroisch[^ %.,%(]*', "|cff" .. cHero .. "%0|r")
            s = s:gsub('[Mm]ythisch[^ %.,%(]*', "|cff" .. cMyth .. "%0|r")
        elseif loc == "es" then
            s = s:gsub('Blasones? del amanecer [Hh]eroicos?', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_hero:14:14:0:0|t |cff'..cHero..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('Blasones? del amanecer [Mm]íticos?', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_myth:14:14:0:0|t |cff'..cMyth..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('Blasones? del amanecer [Cc]ampeón', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_champion:14:14:0:0|t |cff'..cChamp..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('Blasones? del amanecer [Vv]eteranos?', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_veteran:14:14:0:0|t |cff'..cVet..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('Blasones? del amanecer [Aa]ventureros?', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_adventurer:14:14:0:0|t |cff'..cAdv..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('[Aa]ventureros?[^ %.,%(]*', "|cff" .. cAdv .. "%0|r")
            s = s:gsub('[Vv]eteranos?[^ %.,%(]*', "|cff" .. cVet .. "%0|r")
            s = s:gsub('[Cc]ampeón', "|cff" .. cChamp .. "%0|r")
            s = s:gsub('[Hh]eroicos?[^ %.,%(]*', "|cff" .. cHero .. "%0|r")
            s = s:gsub('[Hh]éroes?[^ %.,%(]*', "|cff" .. cHero .. "%0|r")
            s = s:gsub('[Mm]íticos?[^ %.,%(]*', "|cff" .. cMyth .. "%0|r")
        else
            s = s:gsub('[Ee]cus? de l.aube d.aventure',   function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_adventurer:14:14:0:0|t |cff'..cAdv..m..'|r';  return '@@PH'..#ph..'@@' end)
            s = s:gsub('Écus? de l.aube d.aventure',        function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_adventurer:14:14:0:0|t |cff'..cAdv..m..'|r';  return '@@PH'..#ph..'@@' end)
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
            s = s:gsub("%f[%a][Hh]éro%f[%A]", "|cff" .. cHero .. "%0|r")
            s = s:gsub("%f[%a]([Hh])ero%f[%A]", function(h) return "|cff" .. cHero .. h .. "éro|r" end)
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
            local display = "|cff" .. GetAccentColorHex() .. prefix .. "|r"
            if rest ~= "" then
                local coloredRest
                if pat:find("Niveau d") or pat:find("Estimated gear") or pat:find("Gegenstandsstufe") or pat:find("objeto estimado") then
                    local stripped = rest:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
                    coloredRest = "|cffffffff" .. stripped .. "|r"
                else
                    coloredRest = colorizeText(rest) or rest
                    coloredRest = coloredRest:gsub("(%d+/%d+)", "|cffffffff%1|r")
                    coloredRest = coloredRest:gsub("(%s)et(%s)", "%1|cffffffffet|r%2")
                    coloredRest = coloredRest:gsub("(%s)and(%s)", "%1|cffffffffand|r%2")
                end

                display = "|cff" .. GetAccentColorHex() .. prefix .. "|r" .. " " .. coloredRest

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
    if not MidnightObjectiveTrackerDB.checks then MidnightObjectiveTrackerDB.checks = {} end
    local isChecked = MidnightObjectiveTrackerDB.checks[checkKey] or false

    local cb = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    cb:SetSize(20, 20)
    cb:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, yOffset + 3)
    cb:SetChecked(isChecked)
    cb:SetFrameLevel(parent:GetFrameLevel() + 2)

    local num = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    num:SetPoint("TOPLEFT", parent, "TOPLEFT", 22, yOffset)
    num:SetText(index .. ".")
    do local ar, ag, ab = GetAccentColor(); num:SetTextColor(ar, ag, ab) end

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

    local function doToggle(newChecked)
        MidnightObjectiveTrackerDB.checks[checkKey] = newChecked or nil
        applyCheckState(newChecked)
        if newChecked and Midnight.weekInfo and Midnight.weekInfo[weekIndex] then
            if isWeekFullyChecked(weekIndex, Midnight.weekInfo[weekIndex]) then
                C_Timer.After(0.3, function() Midnight:Refresh() end)
            end
        end
    end

    cb:SetScript("OnClick", function(self)
        doToggle(self:GetChecked())
    end)

    local rowHeight = label:GetStringHeight() + 12

local rowBtn = CreateFrame("Button", nil, parent)
    rowBtn:SetPoint("TOPLEFT", parent, "TOPLEFT", 24, yOffset)
    rowBtn:SetWidth(computeAvailableW(24))
    rowBtn:SetHeight(rowHeight)
    rowBtn:SetFrameLevel(parent:GetFrameLevel() + 1)
    rowBtn:EnableMouse(true)

    local hoverTex = rowBtn:CreateTexture(nil, "BACKGROUND")
    hoverTex:SetAllPoints()
    do local hr, hg, hb = GetAccentColor(); hoverTex:SetColorTexture(hr, hg, hb, 0.08) end
    hoverTex:Hide()

    rowBtn:SetScript("OnEnter", function()
        hoverTex:Show()
    end)
    rowBtn:SetScript("OnLeave", function()
        hoverTex:Hide()
    end)
    rowBtn:SetScript("OnClick", function()
        local checked = not cb:GetChecked()
        cb:SetChecked(checked)
        doToggle(checked)
    end)

    Midnight.allCheckboxes = Midnight.allCheckboxes or {}
    table.insert(Midnight.allCheckboxes, { cb = cb, applyFn = applyCheckState })

    return rowHeight
end

function Midnight:Refresh()
    MidnightObjectiveTrackerDB.checks = MidnightObjectiveTrackerDB.checks or {}
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

        local contentW = math.max(100, (scrollFrame:GetWidth() or 0) + 4)
        if contentW < 10 then contentW = 430 end
        local ar, ag, ab = GetAccentColor()
        local titleBg = content:CreateTexture(nil, "BACKGROUND")
        titleBg:SetColorTexture(ar, ag * 0.95, ab, 0.18)
        titleBg:SetPoint("TOPLEFT", content, "TOPLEFT", -2, yOffset)
        titleBg:SetSize((frame:GetWidth() or 500) - 18, 26)

        local weekTitle = content:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        weekTitle:SetPoint("TOPLEFT", content, "TOPLEFT", -2, yOffset)
        weekTitle:SetWidth((frame:GetWidth() or 500) - 18)
        weekTitle:SetHeight(26)
        weekTitle:SetJustifyH("CENTER")
        weekTitle:SetJustifyV("MIDDLE")
        weekTitle:SetText(MidnightL.FormatWeekTitle(wIndex) or week.title)
        weekTitle:SetTextColor(ar, ag, ab)

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
        do local ar, ag, ab = GetAccentColor(); bullet:SetTextColor(ar, ag, ab) end
        bullet:SetText("•")

        local txt = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        txt:SetPoint("LEFT", 14, 0)
        txt:SetJustifyH("LEFT")
        txt:SetText(MidnightL.FormatMenuLabel(wIndex) or menuLabels[wIndex] or week.title or ("Week " .. wIndex))
        txt:SetTextColor(1,1,1)

        menuButtons[vIdx] = { btn = btn, txt = txt, bullet = bullet }

        btn:SetScript("OnClick", function()
            activeMenuIndex = vIdx
            UpdateMenuActive()
            UpdateIlvlPanel()
            UpdateCrestPanel()
            menuNavGuard = true
            C_Timer.After(0.6, function() menuNavGuard = false end)
            ScrollToWeek(vIdx)
        end)
        btn:SetScript("OnEnter", function(self)
            if menuButtons[vIdx] and menuButtons[vIdx].txt then
                local mar, mag, mab = GetAccentColor()
                menuButtons[vIdx].txt:SetTextColor(mar, mag, mab)
            end
            if self.LockHighlight then self:LockHighlight() end
        end)
        btn:SetScript("OnLeave", function(self)
            if activeMenuIndex == vIdx then
                if menuButtons[vIdx] and menuButtons[vIdx].txt then
                    local mar, mag, mab = GetAccentColor()
                    menuButtons[vIdx].txt:SetTextColor(mar, mag, mab)
                end
            else
                if menuButtons[vIdx] and menuButtons[vIdx].txt then menuButtons[vIdx].txt:SetTextColor(1,1,1) end
            end
            if self.UnlockHighlight then self:UnlockHighlight() end
        end)
    end

local numVisible = #visibleWeeks
    local newMenuH = (numVisible > 0) and ((numVisible - 1) * 20 + 34) or 34
    menu:SetHeight(newMenuH)

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
    RegisterPanelButton(btn)
    return btn
end

local resetConfirmPopup = CreateFrame("Frame", "MidnightResetConfirmPopup", UIParent, "BackdropTemplate")
resetConfirmPopup:SetSize(300, 110)
resetConfirmPopup:SetPoint("CENTER")
resetConfirmPopup:SetBackdrop({
    bgFile = "Interface/Buttons/WHITE8X8",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets   = { left = 8, right = 8, top = 8, bottom = 8 },
})
resetConfirmPopup:SetBackdropColor(0, 0, 0, 1)
resetConfirmPopup:SetBackdropBorderColor(1, 0.82, 0, 1)
RegisterBorderedFrame(resetConfirmPopup)
RegisterWindowBgFrame(resetConfirmPopup)
resetConfirmPopup:SetFrameStrata("DIALOG")
resetConfirmPopup:SetFrameLevel(100)
resetConfirmPopup:Hide()

local resetConfirmTitle = resetConfirmPopup:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
resetConfirmTitle:SetPoint("TOP", resetConfirmPopup, "TOP", 0, -14)
resetConfirmTitle:SetTextColor(1, 0.82, 0)
RegisterTitleFontString(resetConfirmTitle)

local resetConfirmMsg = resetConfirmPopup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
resetConfirmMsg:SetPoint("TOP", resetConfirmTitle, "BOTTOM", 0, -8)
resetConfirmMsg:SetWidth(260)
resetConfirmMsg:SetJustifyH("CENTER")
resetConfirmMsg:SetWordWrap(true)
resetConfirmMsg:SetTextColor(1, 1, 1)

local resetConfirmYes = CreateFrame("Button", nil, resetConfirmPopup, "UIPanelButtonTemplate")
resetConfirmYes:SetSize(80, 22)
resetConfirmYes:SetPoint("BOTTOMRIGHT", resetConfirmPopup, "BOTTOM", -6, 10)
resetConfirmYes:SetNormalFontObject("GameFontNormalSmall")
resetConfirmYes:SetHighlightFontObject("GameFontNormalSmall")
resetConfirmYes:SetScript("OnClick", function()
    resetConfirmPopup:Hide()
    MidnightObjectiveTrackerDB.checks = {}
    Midnight:Refresh()
end)
RegisterPanelButton(resetConfirmYes)

local resetConfirmNo = CreateFrame("Button", nil, resetConfirmPopup, "UIPanelButtonTemplate")
resetConfirmNo:SetSize(80, 22)
resetConfirmNo:SetPoint("BOTTOMLEFT", resetConfirmPopup, "BOTTOM", 6, 10)
resetConfirmNo:SetNormalFontObject("GameFontNormalSmall")
resetConfirmNo:SetHighlightFontObject("GameFontNormalSmall")
resetConfirmNo:SetScript("OnClick", function()
    resetConfirmPopup:Hide()
end)
RegisterPanelButton(resetConfirmNo)

local function ShowResetConfirmPopup()
    resetConfirmTitle:SetText(MidnightL.S("reset_confirm_title"))
    resetConfirmMsg:SetText(MidnightL.S("reset_confirm_msg"))
    resetConfirmYes:SetText(MidnightL.S("reset_confirm_yes"))
    resetConfirmNo:SetText(MidnightL.S("reset_confirm_no"))
    resetConfirmPopup:Show()
end

local resetButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
resetButton:SetSize(42, 20)
resetButton:SetText("Reset")
resetButton:SetNormalFontObject("GameFontNormalSmall")
resetButton:SetHighlightFontObject("GameFontNormalSmall")
resetButton:SetScript("OnClick", function()
    ShowResetConfirmPopup()
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
RegisterPanelButton(resetButton)

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
ilvlRefButton:SetFrameLevel(frame:GetFrameLevel() + 5)
RegisterPanelButton(ilvlRefButton)

local SCALE_MIN = 0.6
local SCALE_MAX = 1.6
local SCALE_STEP = 0.05

local function ApplyMidnightScale(scale)
    scale = math.max(SCALE_MIN, math.min(SCALE_MAX, scale))
    MidnightObjectiveTrackerDB.scale = scale
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
    if MidnightColorblindFrame and MidnightColorblindFrame.SetScale then
        MidnightColorblindFrame:SetScale(scale)
    end
    if MidnightCopyrightFrame and MidnightCopyrightFrame.SetScale then
        MidnightCopyrightFrame:SetScale(scale)
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

local function ApplyMidnightOpacity(opacity)
    opacity = math.max(0.45, math.min(1, opacity))
    MidnightObjectiveTrackerDB.opacity = opacity
    frame:SetAlpha(opacity)
    if MidnightMplusFrame and MidnightMplusFrame.SetAlpha then
        MidnightMplusFrame:SetAlpha(opacity)
    end
    if MidnightPlanningContenuFrame and MidnightPlanningContenuFrame.SetAlpha then
        MidnightPlanningContenuFrame:SetAlpha(opacity)
    end
    if MidnightIlvlFrame and MidnightIlvlFrame.SetAlpha then
        MidnightIlvlFrame:SetAlpha(opacity)
    end
    if MidnightColorblindFrame and MidnightColorblindFrame.SetAlpha then
        MidnightColorblindFrame:SetAlpha(opacity)
    end
    if MidnightCopyrightFrame and MidnightCopyrightFrame.SetAlpha then
        MidnightCopyrightFrame:SetAlpha(opacity)
    end
end

do
    local _hoverTimer = 0
    local _hoverActive = false
    local _hoverPoll = CreateFrame("Frame")
    _hoverPoll:SetScript("OnUpdate", function(self, elapsed)
        _hoverTimer = _hoverTimer + elapsed
        if _hoverTimer < 0.05 then return end
        _hoverTimer = 0
        local savedOpacity = MidnightObjectiveTrackerDB.opacity or 1.0
        if savedOpacity >= 1.0 then
            _hoverActive = false
            return
        end
        local function checkF(f) return f and f.IsShown and f:IsShown() and MouseIsOver(f) end
        local isOver = checkF(frame)
            or checkF(MidnightColorblindFrame)
            or checkF(MidnightCopyrightFrame)
            or checkF(MidnightMplusFrame)
            or checkF(MidnightPlanningContenuFrame)
            or checkF(MidnightIlvlFrame)
            or checkF(MidnightCrestPanel)
            or checkF(MidnightVaultPanel)
        if isOver and not _hoverActive then
            frame:SetAlpha(1.0)
            if MidnightColorblindFrame then MidnightColorblindFrame:SetAlpha(1.0) end
            if MidnightCopyrightFrame   then MidnightCopyrightFrame:SetAlpha(1.0) end
            if MidnightMplusFrame       then MidnightMplusFrame:SetAlpha(1.0) end
            if MidnightPlanningContenuFrame then MidnightPlanningContenuFrame:SetAlpha(1.0) end
            if MidnightIlvlFrame        then MidnightIlvlFrame:SetAlpha(1.0) end
            _hoverActive = true
        elseif not isOver and _hoverActive then
            frame:SetAlpha(savedOpacity)
            if MidnightColorblindFrame then MidnightColorblindFrame:SetAlpha(savedOpacity) end
            if MidnightCopyrightFrame   then MidnightCopyrightFrame:SetAlpha(savedOpacity) end
            if MidnightMplusFrame       then MidnightMplusFrame:SetAlpha(savedOpacity) end
            if MidnightPlanningContenuFrame then MidnightPlanningContenuFrame:SetAlpha(savedOpacity) end
            if MidnightIlvlFrame        then MidnightIlvlFrame:SetAlpha(savedOpacity) end
            _hoverActive = false
        end
    end)
end

local function UpdateEscBehavior(escCloses)
    MidnightObjectiveTrackerDB.escCloses = escCloses
    for i = #UISpecialFrames, 1, -1 do
        if UISpecialFrames[i] == "MidnightTrackerFrame" then
            table.remove(UISpecialFrames, i)
        end
    end
    if escCloses then
        table.insert(UISpecialFrames, "MidnightTrackerFrame")
    end
end

local scaleDownBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
scaleDownBtn:SetSize(20, 20)
scaleDownBtn:SetText("-")
scaleDownBtn:SetNormalFontObject("GameFontNormal")
scaleDownBtn:SetHighlightFontObject("GameFontNormal")
scaleDownBtn:SetFrameLevel(frame:GetFrameLevel() + 5)
scaleDownBtn:SetScript("OnClick", function(self, button)
    if button == "RightButton" then
        ApplyMidnightScale(1.0)
    else
        local cur = MidnightObjectiveTrackerDB.scale or 1.0
        ApplyMidnightScale(cur - SCALE_STEP)
    end
end)
scaleDownBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
RegisterPanelButton(scaleDownBtn)

local scaleUpBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
scaleUpBtn:SetSize(20, 20)
scaleUpBtn:SetText("+")
scaleUpBtn:SetNormalFontObject("GameFontNormal")
scaleUpBtn:SetHighlightFontObject("GameFontNormal")
scaleUpBtn:SetFrameLevel(frame:GetFrameLevel() + 5)
scaleUpBtn:SetScript("OnClick", function(self, button)
    if button == "RightButton" then
        ApplyMidnightScale(1.0)
    else
        local cur = MidnightObjectiveTrackerDB.scale or 1.0
        ApplyMidnightScale(cur + SCALE_STEP)
    end
end)
scaleUpBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
RegisterPanelButton(scaleUpBtn)

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

local closeBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
closeBtn:SetSize(20, 20)
closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -10, -10)
closeBtn:SetText("X")
closeBtn:SetNormalFontObject("GameFontNormalSmall")
closeBtn:SetHighlightFontObject("GameFontNormalSmall")
closeBtn:SetScript("OnClick", function()
    frame:Hide()
end)
closeBtn:SetFrameLevel(frame:GetFrameLevel() + 5)
RegisterPanelButton(closeBtn)

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
planningButton:SetFrameLevel(frame:GetFrameLevel() + 5)
RegisterPanelButton(planningButton)

ilvlRefButton:ClearAllPoints()
ilvlRefButton:SetPoint("TOPRIGHT", planningButton, "TOPLEFT", -4, 0)

local mplusButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
mplusButton:SetSize(55, 20)
mplusButton:SetPoint("TOPRIGHT", ilvlRefButton, "TOPLEFT", -4, 0)
mplusButton:SetText(MidnightL.S("crests"))
mplusButton:SetNormalFontObject("GameFontNormalSmall")
mplusButton:SetHighlightFontObject("GameFontNormalSmall")
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
RegisterPanelButton(mplusButton)

local cbSettingsFrame = CreateFrame("Frame", "MidnightColorblindFrame", UIParent, "BackdropTemplate")
cbSettingsFrame:SetSize(185, 468)
cbSettingsFrame:SetPoint("TOPRIGHT", frame, "TOPLEFT", 6, 0)
cbSettingsFrame:SetBackdrop({
    bgFile = "Interface/Buttons/WHITE8X8",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
cbSettingsFrame:SetBackdropColor(0, 0, 0, 1)
cbSettingsFrame:SetBackdropBorderColor(1, 0.82, 0, 1)
RegisterBorderedFrame(cbSettingsFrame)
RegisterWindowBgFrame(cbSettingsFrame)
cbSettingsFrame:SetFrameStrata("DIALOG")
cbSettingsFrame:EnableMouse(true)
cbSettingsFrame:Hide()
cbSettingsFrame:HookScript("OnShow", function()
    local wbc = MidnightObjectiveTrackerDB.windowBgColor or { r = 0, g = 0, b = 0 }
    cbSettingsFrame:SetBackdropColor(wbc.r, wbc.g, wbc.b, 1)
end)
table.insert(UISpecialFrames, "MidnightColorblindFrame")

local cbTitle = cbSettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
cbTitle:SetPoint("TOP", cbSettingsFrame, "TOP", 0, -14)
cbTitle:SetText(MidnightL.S("colorblind_title"))
cbTitle:SetTextColor(1, 0.82, 0)
RegisterTitleFontString(cbTitle)

local cbCloseBtn = CreateFrame("Button", nil, cbSettingsFrame, "UIPanelButtonTemplate")
cbCloseBtn:SetSize(20, 20)
cbCloseBtn:SetPoint("TOPRIGHT", cbSettingsFrame, "TOPRIGHT", -10, -10)
cbCloseBtn:SetText("X")
cbCloseBtn:SetNormalFontObject("GameFontNormalSmall")
cbCloseBtn:SetHighlightFontObject("GameFontNormalSmall")
cbCloseBtn:SetScript("OnClick", function() cbSettingsFrame:Hide() end)
cbCloseBtn:SetFrameLevel(cbSettingsFrame:GetFrameLevel() + 5)
RegisterPanelButton(cbCloseBtn)

local opTopY = -34

local opTitle = cbSettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
opTitle:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, opTopY - 6)
opTitle:SetTextColor(1, 0.82, 0)
opTitle:SetText(MidnightL.S("opacity_label"))
opTitle:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(MidnightL.S("opacity_label"), 1, 0.82, 0)
    GameTooltip:AddLine(MidnightL.S("opacity_tooltip"), 1, 1, 1, true)
    GameTooltip:Show()
end)
opTitle:SetScript("OnLeave", function() GameTooltip:Hide() end)
opTitle:EnableMouse(true)
RegisterTitleFontString(opTitle)

local opSlider = CreateFrame("Slider", "MidnightOpacitySlider", cbSettingsFrame, "UISliderTemplate")
opSlider:SetMinMaxValues(0.45, 1)
opSlider:SetValueStep(0.05)
opSlider:SetWidth(155)
opSlider:SetHeight(16)
opSlider:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, opTopY - 24)
if opSlider.SetObeyStepOnDrag then opSlider:SetObeyStepOnDrag(true) end

local opValueLabel = cbSettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
opValueLabel:SetPoint("TOP", opSlider, "BOTTOM", 0, 2)
opValueLabel:SetTextColor(1, 1, 1)

local savedOpacity = math.max(0.45, math.min(1.0, MidnightObjectiveTrackerDB.opacity or 1.0))
opSlider:SetValue(savedOpacity)
opValueLabel:SetText(string.format("%d%%", math.floor(savedOpacity * 100 + 0.5)))

opSlider:SetScript("OnValueChanged", function(self, value)
    value = math.floor(value * 20 + 0.5) / 20
    MidnightObjectiveTrackerDB.opacity = value
    opValueLabel:SetText(string.format("%d%%", math.floor(value * 100 + 0.5)))
    ApplyMidnightOpacity(value)
end)

local escTopY = opTopY - 54

local escCb = CreateFrame("CheckButton", nil, cbSettingsFrame)
escCb:SetSize(18, 18)
escCb:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, escTopY - 8)
escCb:SetFrameLevel(cbSettingsFrame:GetFrameLevel() + 2)

local escBgTex = escCb:CreateTexture(nil, "BACKGROUND")
escBgTex:SetAllPoints()
escBgTex:SetColorTexture(0.2, 0.2, 0.2, 0.8)

local escCheckTex = escCb:CreateTexture(nil, "OVERLAY")
escCheckTex:SetSize(12, 12)
escCheckTex:SetPoint("CENTER")
escCheckTex:SetColorTexture(1, 0.82, 0, 1)
escCb:SetCheckedTexture(escCheckTex)
RegisterAccentTexture(escCheckTex)

local escLabel = cbSettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
escLabel:SetPoint("LEFT", escCb, "RIGHT", 6, 0)
escLabel:SetText(MidnightL.S("esc_closes"))
escLabel:SetTextColor(1, 1, 1)

escCb:SetChecked(MidnightObjectiveTrackerDB.escCloses)
escCb:SetScript("OnClick", function(self)
    UpdateEscBehavior(self:GetChecked())
end)

local borderTopY = escTopY - 30

local borderCb = CreateFrame("CheckButton", nil, cbSettingsFrame)
borderCb:SetSize(18, 18)
borderCb:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, borderTopY - 8)
borderCb:SetFrameLevel(cbSettingsFrame:GetFrameLevel() + 2)

local borderBgTex = borderCb:CreateTexture(nil, "BACKGROUND")
borderBgTex:SetAllPoints()
borderBgTex:SetColorTexture(0.2, 0.2, 0.2, 0.8)

local borderCheckTex = borderCb:CreateTexture(nil, "OVERLAY")
borderCheckTex:SetSize(12, 12)
borderCheckTex:SetPoint("CENTER")
borderCheckTex:SetColorTexture(1, 0.82, 0, 1)
borderCb:SetCheckedTexture(borderCheckTex)
RegisterAccentTexture(borderCheckTex)

local borderLabel = cbSettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
borderLabel:SetPoint("LEFT", borderCb, "RIGHT", 6, 0)
borderLabel:SetText(MidnightL.S("golden_border"))
borderLabel:SetTextColor(1, 1, 1)

borderCb:SetChecked(MidnightObjectiveTrackerDB.goldenBorder ~= false)
borderCb:SetScript("OnClick", function(self)
    ApplyMidnightBorder(self:GetChecked())
end)
borderCb:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(MidnightL.S("golden_border"), 1, 0.82, 0)
    GameTooltip:AddLine(MidnightL.S("golden_border_desc"), 1, 1, 1, true)
    GameTooltip:Show()
end)
borderCb:SetScript("OnLeave", function() GameTooltip:Hide() end)

local dispTopY = borderTopY - 32

local showCrestCb = CreateFrame("CheckButton", nil, cbSettingsFrame)
showCrestCb:SetSize(18, 18)
showCrestCb:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, dispTopY - 8)
showCrestCb:SetFrameLevel(cbSettingsFrame:GetFrameLevel() + 2)
local showCrestBgTex = showCrestCb:CreateTexture(nil, "BACKGROUND")
showCrestBgTex:SetAllPoints()
showCrestBgTex:SetColorTexture(0.2, 0.2, 0.2, 0.8)
local showCrestCheckTex = showCrestCb:CreateTexture(nil, "OVERLAY")
showCrestCheckTex:SetSize(12, 12)
showCrestCheckTex:SetPoint("CENTER")
showCrestCheckTex:SetColorTexture(1, 0.82, 0, 1)
showCrestCb:SetCheckedTexture(showCrestCheckTex)
RegisterAccentTexture(showCrestCheckTex)
local showCrestLabel = cbSettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
showCrestLabel:SetPoint("LEFT", showCrestCb, "RIGHT", 6, 0)
showCrestLabel:SetText(MidnightL.S("show_crest_panel"))
showCrestLabel:SetTextColor(1, 1, 1)
showCrestCb:SetChecked(MidnightObjectiveTrackerDB.showCrestPanel ~= false)
showCrestCb:SetScript("OnClick", function(self)
    MidnightObjectiveTrackerDB.showCrestPanel = self:GetChecked()
    if MidnightCrestPanel then
        if self:GetChecked() and frame:IsShown() then
            MidnightCrestPanel:Show()
        else
            MidnightCrestPanel:Hide()
        end
    end
end)

local showVaultCb = CreateFrame("CheckButton", nil, cbSettingsFrame)
showVaultCb:SetSize(18, 18)
showVaultCb:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, dispTopY - 30)
showVaultCb:SetFrameLevel(cbSettingsFrame:GetFrameLevel() + 2)
local showVaultBgTex = showVaultCb:CreateTexture(nil, "BACKGROUND")
showVaultBgTex:SetAllPoints()
showVaultBgTex:SetColorTexture(0.2, 0.2, 0.2, 0.8)
local showVaultCheckTex = showVaultCb:CreateTexture(nil, "OVERLAY")
showVaultCheckTex:SetSize(12, 12)
showVaultCheckTex:SetPoint("CENTER")
showVaultCheckTex:SetColorTexture(1, 0.82, 0, 1)
showVaultCb:SetCheckedTexture(showVaultCheckTex)
RegisterAccentTexture(showVaultCheckTex)
local showVaultLabel = cbSettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
showVaultLabel:SetPoint("LEFT", showVaultCb, "RIGHT", 6, 0)
showVaultLabel:SetText(MidnightL.S("show_vault_panel"))
showVaultLabel:SetTextColor(1, 1, 1)
showVaultCb:SetChecked(MidnightObjectiveTrackerDB.showVaultPanel ~= false)
showVaultCb:SetScript("OnClick", function(self)
    MidnightObjectiveTrackerDB.showVaultPanel = self:GetChecked()
    if MidnightVaultPanel then
        if self:GetChecked() and frame:IsShown() then
            MidnightVaultPanel:Show()
        else
            MidnightVaultPanel:Hide()
        end
    end
end)

local colorTopY = borderTopY - 92

local bgSwatchBg

local colorTitle = cbSettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
colorTitle:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, colorTopY)
colorTitle:SetTextColor(1, 0.82, 0)
colorTitle:SetText(MidnightL.S("title_color_label"))
colorTitle:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(MidnightL.S("title_color_label"), 1, 0.82, 0)
    GameTooltip:AddLine(MidnightL.S("title_color_desc"), 1, 1, 1, true)
    GameTooltip:Show()
end)
colorTitle:SetScript("OnLeave", function() GameTooltip:Hide() end)
colorTitle:EnableMouse(true)
RegisterTitleFontString(colorTitle)

local colorSwatch = CreateFrame("Button", nil, cbSettingsFrame)
colorSwatch:SetSize(26, 18)
colorSwatch:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, colorTopY - 20)

local colorSwatchBg = colorSwatch:CreateTexture(nil, "BACKGROUND")
colorSwatchBg:SetAllPoints()
do
    local cr, cg, cb2 = GetAccentColor()
    colorSwatchBg:SetColorTexture(cr, cg, cb2, 1)
end

local colorSwatchBorder = colorSwatch:CreateTexture(nil, "OVERLAY")
colorSwatchBorder:SetAllPoints()
colorSwatchBorder:SetColorTexture(0.8, 0.8, 0.8, 0.5)
colorSwatchBorder:SetSize(26, 18)

local colorResetBtn = CreateFrame("Button", nil, cbSettingsFrame, "UIPanelButtonTemplate")
colorResetBtn:SetSize(100, 18)
colorResetBtn:SetPoint("TOPLEFT", colorSwatch, "TOPRIGHT", 6, 0)
colorResetBtn:SetText("Reset")
colorResetBtn:SetNormalFontObject("GameFontNormalSmall")
colorResetBtn:SetHighlightFontObject("GameFontNormalSmall")
RegisterPanelButton(colorResetBtn)
colorResetBtn:SetScript("OnClick", function()
    ApplyMidnightAccentColor(1, 0.82, 0)
    colorSwatchBg:SetColorTexture(1, 0.82, 0, 1)
    borderCheckTex:SetColorTexture(1, 0.82, 0, 1)
    ApplyWindowBgColor(0, 0, 0)
    if bgSwatchBg then bgSwatchBg:SetColorTexture(0, 0, 0, 1) end
    ApplyMidnightOpacity(MidnightObjectiveTrackerDB.opacity or 1.0)
    if Midnight and Midnight.Refresh and frame and frame:IsShown() then Midnight:Refresh() end
end)

colorSwatch:SetScript("OnClick", function()
    local tc = MidnightObjectiveTrackerDB.titleColor or { r = 1, g = 0.82, b = 0 }
    local function onColorChanged()
        local r, g, b
        if ColorPickerFrame.GetColorRGB then
            r, g, b = ColorPickerFrame:GetColorRGB()
        else
            r, g, b = ColorPickerFrame.r or tc.r, ColorPickerFrame.g or tc.g, ColorPickerFrame.b or tc.b
        end
        ApplyMidnightAccentColor(r, g, b)
        colorSwatchBg:SetColorTexture(r, g, b, 1)
        if Midnight and Midnight.Refresh and frame and frame:IsShown() then Midnight:Refresh() end
    end
    local function onColorCancelled(prevValues)
        local r, g, b
        if type(prevValues) == "table" then
            r, g, b = prevValues.r, prevValues.g, prevValues.b
        else
            r, g, b = prevValues or tc.r, ColorPickerFrame.previousValues or tc.g, tc.b
        end
        r = r or tc.r; g = g or tc.g; b = b or tc.b
        ApplyMidnightAccentColor(r, g, b)
        colorSwatchBg:SetColorTexture(r, g, b, 1)
        if Midnight and Midnight.Refresh and frame and frame:IsShown() then Midnight:Refresh() end
    end
    if ColorPickerFrame.SetupColorPickerAndShow then

        ColorPickerFrame:SetupColorPickerAndShow({
            r = tc.r, g = tc.g, b = tc.b, opacity = nil,
            hasOpacity = false,
            swatchFunc  = onColorChanged,
            cancelFunc  = onColorCancelled,
        })
    else

        ColorPickerFrame:SetColorRGB(tc.r, tc.g, tc.b)
        ColorPickerFrame.previousValues = { r = tc.r, g = tc.g, b = tc.b }
        ColorPickerFrame.func    = onColorChanged
        ColorPickerFrame.cancelFunc = onColorCancelled
        ColorPickerFrame:Show()
    end
end)
colorSwatch:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(MidnightL.S("title_color_label"), 1, 0.82, 0)
    GameTooltip:AddLine(MidnightL.S("title_color_desc"), 1, 1, 1, true)
    GameTooltip:Show()
end)
colorSwatch:SetScript("OnLeave", function() GameTooltip:Hide() end)

local bgColorTopY = colorTopY - 50

local bgColorTitle = cbSettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
bgColorTitle:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, bgColorTopY)
bgColorTitle:SetTextColor(1, 0.82, 0)
bgColorTitle:SetText(MidnightL.S("window_bg_color_label"))
bgColorTitle:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(MidnightL.S("window_bg_color_label"), 1, 0.82, 0)
    GameTooltip:AddLine(MidnightL.S("window_bg_color_desc"), 1, 1, 1, true)
    GameTooltip:Show()
end)
bgColorTitle:SetScript("OnLeave", function() GameTooltip:Hide() end)
bgColorTitle:EnableMouse(true)
RegisterTitleFontString(bgColorTitle)

local bgColorSwatch = CreateFrame("Button", nil, cbSettingsFrame)
bgColorSwatch:SetSize(26, 18)
bgColorSwatch:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, bgColorTopY - 20)

bgSwatchBg = bgColorSwatch:CreateTexture(nil, "BACKGROUND")
bgSwatchBg:SetAllPoints()
do
    local wc = MidnightObjectiveTrackerDB.windowBgColor or { r = 0, g = 0, b = 0 }
    bgSwatchBg:SetColorTexture(wc.r, wc.g, wc.b, 1)
end

local bgSwatchBorder = bgColorSwatch:CreateTexture(nil, "OVERLAY")
bgSwatchBorder:SetAllPoints()
bgSwatchBorder:SetColorTexture(0.8, 0.8, 0.8, 0.5)
bgSwatchBorder:SetSize(26, 18)

local bgColorResetBtn = CreateFrame("Button", nil, cbSettingsFrame, "UIPanelButtonTemplate")
bgColorResetBtn:SetSize(100, 18)
bgColorResetBtn:SetPoint("TOPLEFT", bgColorSwatch, "TOPRIGHT", 6, 0)
bgColorResetBtn:SetText("Reset")
bgColorResetBtn:SetNormalFontObject("GameFontNormalSmall")
bgColorResetBtn:SetHighlightFontObject("GameFontNormalSmall")
RegisterPanelButton(bgColorResetBtn)
RegisterButtonText(bgColorResetBtn)
bgColorResetBtn:SetScript("OnClick", function()
    ApplyWindowBgColor(0, 0, 0)
    bgSwatchBg:SetColorTexture(0, 0, 0, 1)
end)

bgColorSwatch:SetScript("OnClick", function()
    local wc = MidnightObjectiveTrackerDB.windowBgColor or { r = 0, g = 0, b = 0 }
    local function onBgColorChanged()
        local r, g, b
        if ColorPickerFrame.GetColorRGB then
            r, g, b = ColorPickerFrame:GetColorRGB()
        else
            r, g, b = ColorPickerFrame.r or wc.r, ColorPickerFrame.g or wc.g, ColorPickerFrame.b or wc.b
        end
        ApplyWindowBgColor(r, g, b)
        bgSwatchBg:SetColorTexture(r, g, b, 1)
    end
    local function onBgColorCancelled(prevValues)
        local r, g, b
        if type(prevValues) == "table" then
            r, g, b = prevValues.r, prevValues.g, prevValues.b
        else
            r, g, b = wc.r, wc.g, wc.b
        end
        r = r or wc.r; g = g or wc.g; b = b or wc.b
        ApplyWindowBgColor(r, g, b)
        bgSwatchBg:SetColorTexture(r, g, b, 1)
    end
    if ColorPickerFrame.SetupColorPickerAndShow then
        ColorPickerFrame:SetupColorPickerAndShow({
            r = wc.r, g = wc.g, b = wc.b, opacity = nil,
            hasOpacity = false,
            swatchFunc  = onBgColorChanged,
            cancelFunc  = onBgColorCancelled,
        })
    else
        ColorPickerFrame:SetColorRGB(wc.r, wc.g, wc.b)
        ColorPickerFrame.previousValues = { r = wc.r, g = wc.g, b = wc.b }
        ColorPickerFrame.func       = onBgColorChanged
        ColorPickerFrame.cancelFunc = onBgColorCancelled
        ColorPickerFrame:Show()
    end
end)
bgColorSwatch:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(MidnightL.S("window_bg_color_label"), 1, 0.82, 0)
    GameTooltip:AddLine(MidnightL.S("window_bg_color_desc"), 1, 1, 1, true)
    GameTooltip:Show()
end)
bgColorSwatch:SetScript("OnLeave", function() GameTooltip:Hide() end)

local btnColorTopY = colorTopY - 100

local btnColorTitle = cbSettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
btnColorTitle:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, btnColorTopY)
btnColorTitle:SetTextColor(1, 0.82, 0)
btnColorTitle:SetText(MidnightL.S("btn_color_label"))
btnColorTitle:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(MidnightL.S("btn_color_label"), 1, 0.82, 0)
    GameTooltip:AddLine(MidnightL.S("btn_color_desc"), 1, 1, 1, true)
    GameTooltip:Show()
end)
btnColorTitle:SetScript("OnLeave", function() GameTooltip:Hide() end)
btnColorTitle:EnableMouse(true)
RegisterTitleFontString(btnColorTitle)

local btnColorSwatch = CreateFrame("Button", nil, cbSettingsFrame)
btnColorSwatch:SetSize(26, 18)
btnColorSwatch:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, btnColorTopY - 20)

local btnSwatchBg = btnColorSwatch:CreateTexture(nil, "BACKGROUND")
btnSwatchBg:SetAllPoints()
do
    local bc = MidnightObjectiveTrackerDB.buttonBgColor or { r = 0.5, g = 0, b = 0 }
    btnSwatchBg:SetColorTexture(bc.r, bc.g, bc.b, 1)
end

local btnSwatchBorder = btnColorSwatch:CreateTexture(nil, "OVERLAY")
btnSwatchBorder:SetAllPoints()
btnSwatchBorder:SetColorTexture(0.8, 0.8, 0.8, 0.5)
btnSwatchBorder:SetSize(26, 18)

local btnColorResetBtn = CreateFrame("Button", nil, cbSettingsFrame, "UIPanelButtonTemplate")
btnColorResetBtn:SetSize(100, 18)
btnColorResetBtn:SetPoint("TOPLEFT", btnColorSwatch, "TOPRIGHT", 6, 0)
btnColorResetBtn:SetText("Reset")
btnColorResetBtn:SetNormalFontObject("GameFontNormalSmall")
btnColorResetBtn:SetHighlightFontObject("GameFontNormalSmall")
RegisterPanelButton(btnColorResetBtn)
RegisterButtonText(btnColorResetBtn)
btnColorResetBtn:SetScript("OnClick", function()
    ApplyButtonBgColor(0.5, 0.0, 0.0)
    btnSwatchBg:SetColorTexture(0.5, 0.0, 0.0, 1)
end)

btnColorSwatch:SetScript("OnClick", function()
    local bc = MidnightObjectiveTrackerDB.buttonBgColor or { r = 0.5, g = 0, b = 0 }
    local function onBtnColorChanged()
        local r, g, b
        if ColorPickerFrame.GetColorRGB then
            r, g, b = ColorPickerFrame:GetColorRGB()
        else
            r, g, b = ColorPickerFrame.r or bc.r, ColorPickerFrame.g or bc.g, ColorPickerFrame.b or bc.b
        end
        ApplyButtonBgColor(r, g, b)
        btnSwatchBg:SetColorTexture(r, g, b, 1)
    end
    local function onBtnColorCancelled(prevValues)
        local r, g, b
        if type(prevValues) == "table" then
            r, g, b = prevValues.r, prevValues.g, prevValues.b
        else
            r, g, b = bc.r, bc.g, bc.b
        end
        r = r or bc.r; g = g or bc.g; b = b or bc.b
        ApplyButtonBgColor(r, g, b)
        btnSwatchBg:SetColorTexture(r, g, b, 1)
    end
    if ColorPickerFrame.SetupColorPickerAndShow then
        ColorPickerFrame:SetupColorPickerAndShow({
            r = bc.r, g = bc.g, b = bc.b, opacity = nil,
            hasOpacity = false,
            swatchFunc  = onBtnColorChanged,
            cancelFunc  = onBtnColorCancelled,
        })
    else
        ColorPickerFrame:SetColorRGB(bc.r, bc.g, bc.b)
        ColorPickerFrame.previousValues = { r = bc.r, g = bc.g, b = bc.b }
        ColorPickerFrame.func       = onBtnColorChanged
        ColorPickerFrame.cancelFunc = onBtnColorCancelled
        ColorPickerFrame:Show()
    end
end)
btnColorSwatch:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(MidnightL.S("btn_color_label"), 1, 0.82, 0)
    GameTooltip:AddLine(MidnightL.S("btn_color_desc"), 1, 1, 1, true)
    GameTooltip:Show()
end)
btnColorSwatch:SetScript("OnLeave", function() GameTooltip:Hide() end)

local elvTopY = colorTopY - 150

local elvTitle = cbSettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
elvTitle:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, elvTopY)
elvTitle:SetTextColor(1, 0.82, 0)
elvTitle:SetText(MidnightL.S("elvui_sync_title"))
RegisterTitleFontString(elvTitle)

local elvBtn = CreateFrame("Button", nil, cbSettingsFrame, "UIPanelButtonTemplate")
elvBtn:SetSize(157, 22)
elvBtn:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, elvTopY - 20)
elvBtn:SetText(MidnightL.S("elvui_sync_btn"))
elvBtn:SetNormalFontObject("GameFontNormalSmall")
elvBtn:SetHighlightFontObject("GameFontNormalSmall")
RegisterPanelButton(elvBtn)
elvBtn:SetScript("OnClick", function()

    local E = ElvUI and ElvUI[1]
    if not E then
        print("|cffFFD100[Midnight]|r " .. MidnightL.S("elvui_not_found"))
        return
    end
    local db = E.db and E.db.general
    if not db then
        print("|cffFFD100[Midnight]|r " .. MidnightL.S("elvui_not_found"))
        return
    end

    local bd = db.backdropfadecolor or db.backdropcolor
    if bd then
        local br = bd.r or 0.06
        local bg_r = bd.g or 0.06
        local bb = bd.b or 0.06
        ApplyWindowBgColor(br, bg_r, bb)
        bgSwatchBg:SetColorTexture(br, bg_r, bb, 1)
    end

    local bc = db.bordercolor
    if bc then

        local vc = db.valuecolor
        local nr = vc and vc.r or bc.r or 0
        local ng = vc and vc.g or bc.g or 0
        local nb = vc and vc.b or bc.b or 0

        local lumi = nr * 0.299 + ng * 0.587 + nb * 0.114
        if lumi < 0.15 and not vc then
            nr, ng, nb = 1, 0.82, 0
        end
        MidnightObjectiveTrackerDB.titleColor = { r = nr, g = ng, b = nb }
        ApplyMidnightAccentColor(nr, ng, nb)
        colorSwatchBg:SetColorTexture(nr, ng, nb, 1)

        if MidnightObjectiveTrackerDB.goldenBorder then
            ApplyMidnightBorder(true)
        end
    end
    if Midnight and Midnight.Refresh and frame and frame:IsShown() then Midnight:Refresh() end
    print("|cffFFD100[Midnight]|r " .. MidnightL.S("elvui_sync_ok"))
end)
elvBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(MidnightL.S("elvui_sync_title"), 1, 0.82, 0)
    GameTooltip:AddLine(MidnightL.S("elvui_sync_desc"), 1, 1, 1, true)
    GameTooltip:Show()
end)
elvBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)

local cbSectionTopY = elvTopY - 54

local cbSectionTitle = cbSettingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
cbSectionTitle:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, cbSectionTopY)
cbSectionTitle:SetTextColor(1, 0.82, 0)
cbSectionTitle:SetText(MidnightL.S("colorblind_section_title"))
RegisterTitleFontString(cbSectionTitle)

local cbModeBtn = CreateFrame("Button", nil, cbSettingsFrame, "BackdropTemplate")
cbModeBtn:SetSize(157, 22)
cbModeBtn:SetPoint("TOPLEFT", cbSettingsFrame, "TOPLEFT", 14, cbSectionTopY - 18)
cbModeBtn:SetBackdrop({
    bgFile   = "Interface/Buttons/WHITE8x8",
    edgeFile = "Interface/Buttons/WHITE8x8",
    edgeSize = 1,
    insets   = { left = 1, right = 1, top = 1, bottom = 1 },
})
cbModeBtn:SetBackdropColor(0.04, 0.04, 0.04, 0.98)
cbModeBtn:SetBackdropBorderColor(1, 0.82, 0, 0.65)
RegisterBorderedFrame(cbModeBtn)

local cbModeBtnLabel = cbModeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
cbModeBtnLabel:SetPoint("LEFT",  cbModeBtn, "LEFT",   6, 0)
cbModeBtnLabel:SetPoint("RIGHT", cbModeBtn, "RIGHT", -16, 0)
cbModeBtnLabel:SetJustifyH("LEFT")
cbModeBtnLabel:SetJustifyV("MIDDLE")
cbModeBtnLabel:SetTextColor(1, 1, 1)
cbModeBtn._label = cbModeBtnLabel

local cbModeBtnArrow = cbModeBtn:CreateTexture(nil, "OVERLAY")
cbModeBtnArrow:SetSize(10, 6)
cbModeBtnArrow:SetPoint("RIGHT", cbModeBtn, "RIGHT", -5, 0)
cbModeBtnArrow:SetTexture("Interface/Buttons/UI-ScrollBar-ScrollDownButton-Up")
cbModeBtnArrow:SetVertexColor(1, 0.82, 0)
cbModeBtn._arrow = cbModeBtnArrow

cbModeBtn:SetScript("OnEnter", function(self)
    local r, g, b = GetAccentColor()
    self:SetBackdropBorderColor(r, g, b, 1)
    self:SetBackdropColor(0.10, 0.10, 0.10, 0.98)
end)
cbModeBtn:SetScript("OnLeave", function(self)
    local r, g, b = GetAccentColor()
    self:SetBackdropBorderColor(r, g, b, 0.65)
    self:SetBackdropColor(0.04, 0.04, 0.04, 0.98)
end)

local cbDropdown = CreateFrame("Frame", "MidnightCBDropdownList", UIParent, "BackdropTemplate")
cbDropdown:SetBackdrop({
    bgFile   = "Interface/Buttons/WHITE8x8",
    edgeFile = "Interface/Buttons/WHITE8x8",
    edgeSize = 1,
    insets   = { left = 1, right = 1, top = 1, bottom = 1 },
})
cbDropdown:SetBackdropColor(0.04, 0.04, 0.04, 0.98)
cbDropdown:SetBackdropBorderColor(1, 0.82, 0, 0.65)
cbDropdown:SetFrameStrata("TOOLTIP")
cbDropdown:SetFrameLevel(200)
cbDropdown:SetClampedToScreen(true)
cbDropdown:Hide()
RegisterBorderedFrame(cbDropdown)

local cbCatcher = CreateFrame("Button", nil, UIParent)
cbCatcher:SetAllPoints(UIParent)
cbCatcher:SetFrameStrata("TOOLTIP")
cbCatcher:SetFrameLevel(cbDropdown:GetFrameLevel() - 1)
cbCatcher:EnableMouse(true)
cbCatcher:Hide()
cbCatcher:SetScript("OnMouseDown", function()
    cbDropdown._closedAt = GetTime()
    cbDropdown:Hide()
end)

local cbModeCategories = {
    { key = nil,                            modes = { "none" } },
    { key = "colorblind_cat_trichromacy",   modes = { "deuteranomaly", "protanomaly", "tritanomaly" } },
    { key = "colorblind_cat_dichromacy",    modes = { "deuteranopia", "protanopia", "tritanopia" } },
    { key = "colorblind_cat_other",         modes = { "achromatopsia", "monochromacy" } },
}

local cbDropdownEntries = {}
for _, cat in ipairs(cbModeCategories) do
    if cat.key then
        table.insert(cbDropdownEntries, { entryType = "header", key = cat.key })
    end
    for _, mode in ipairs(cat.modes) do
        table.insert(cbDropdownEntries, { entryType = "item", mode = mode })
    end
end

local CB_ITEM_H   = 20
local CB_HEADER_H = 18
local DROPDOWN_W  = 157

local totalH = 6
for _, e in ipairs(cbDropdownEntries) do
    totalH = totalH + (e.entryType == "header" and CB_HEADER_H or CB_ITEM_H)
end
cbDropdown:SetSize(DROPDOWN_W, totalH)

local function UpdateCBDropdownSelection(selectedMode)
    for _, e in ipairs(cbDropdownEntries) do
        if e.entryType == "item" and e.fs then
            if e.mode == selectedMode then
                e.fs:SetTextColor(1, 0.82, 0)
                if e.bullet then e.bullet:Show() end
            else
                e.fs:SetTextColor(1, 1, 1)
                if e.bullet then e.bullet:Hide() end
            end
        end
    end
    if cbModeBtn._label then
        cbModeBtn._label:SetText(MidnightL.S("colorblind_" .. selectedMode))
    end
end

local yDropOff = -3
for _, e in ipairs(cbDropdownEntries) do
    if e.entryType == "header" then

        if yDropOff < -3 then
            local sep = cbDropdown:CreateTexture(nil, "ARTWORK")
            sep:SetColorTexture(1, 0.82, 0, 0.2)
            sep:SetHeight(1)
            sep:SetPoint("TOPLEFT",  cbDropdown, "TOPLEFT",  6, yDropOff)
            sep:SetPoint("TOPRIGHT", cbDropdown, "TOPRIGHT", -6, yDropOff)
            yDropOff = yDropOff - 1
        end
        local hdr = cbDropdown:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        hdr:SetPoint("TOPLEFT",  cbDropdown, "TOPLEFT",  8, yDropOff)
        hdr:SetPoint("TOPRIGHT", cbDropdown, "TOPRIGHT", -8, yDropOff)
        hdr:SetHeight(CB_HEADER_H - 1)
        hdr:SetJustifyH("LEFT")
        hdr:SetJustifyV("MIDDLE")
        hdr:SetTextColor(0.60, 0.60, 0.60)
        hdr:SetText(MidnightL.S(e.key))
        yDropOff = yDropOff - CB_HEADER_H
    else
        local btn = CreateFrame("Button", nil, cbDropdown)
        btn:SetHeight(CB_ITEM_H)
        btn:SetPoint("TOPLEFT",  cbDropdown, "TOPLEFT",  2, yDropOff)
        btn:SetPoint("TOPRIGHT", cbDropdown, "TOPRIGHT", -2, yDropOff)
        btn:SetFrameLevel(cbDropdown:GetFrameLevel() + 2)

        local hover = btn:CreateTexture(nil, "BACKGROUND")
        hover:SetAllPoints()
        hover:SetColorTexture(1, 0.82, 0, 0.12)
        hover:Hide()

        local bullet = btn:CreateTexture(nil, "OVERLAY")
        bullet:SetSize(5, 5)
        bullet:SetPoint("LEFT", btn, "LEFT", 6, 0)
        bullet:SetColorTexture(1, 0.82, 0, 1)
        bullet:Hide()
        RegisterAccentTexture(bullet)

        local fs = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        fs:SetPoint("LEFT",  btn, "LEFT",  18, 0)
        fs:SetPoint("RIGHT", btn, "RIGHT", -4, 0)
        fs:SetJustifyH("LEFT")
        fs:SetJustifyV("MIDDLE")
        fs:SetText(MidnightL.S("colorblind_" .. e.mode))
        fs:SetTextColor(1, 1, 1)

        btn:SetScript("OnEnter", function(self)
            hover:Show()
            local descKey = "colorblind_" .. e.mode .. "_desc"
            if MidnightL.S(descKey) ~= descKey then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:ClearLines()
                GameTooltip:AddLine(MidnightL.S("colorblind_" .. e.mode), 1, 0.82, 0)
                GameTooltip:AddLine(MidnightL.S(descKey), 1, 1, 1, true)
                GameTooltip:Show()
            end
        end)
        btn:SetScript("OnLeave", function()
            hover:Hide()
            GameTooltip:Hide()
        end)

        local captureMode = e.mode
        btn:SetScript("OnClick", function()
            MidnightObjectiveTrackerDB.colorblindMode = captureMode
            MidnightL.SetColorblindMode(captureMode)
            UpdateCBDropdownSelection(captureMode)
            cbDropdown:Hide()
            if Midnight and Midnight.Refresh and frame and frame:IsShown() then
                Midnight:Refresh()
            end
        end)

        e.fs     = fs
        e.bullet = bullet
        e.btn    = btn
        yDropOff = yDropOff - CB_ITEM_H
    end
end

cbModeBtn:SetScript("OnClick", function()
    if cbDropdown:IsShown() then
        cbDropdown:Hide()
    else

        if cbDropdown._closedAt and (GetTime() - cbDropdown._closedAt) < 0.2 then
            cbDropdown._closedAt = nil
            return
        end
        cbDropdown:ClearAllPoints()
        cbDropdown:SetPoint("TOPLEFT",  cbModeBtn, "BOTTOMLEFT",  0, -2)
        cbDropdown:SetPoint("TOPRIGHT", cbModeBtn, "BOTTOMRIGHT", 0, -2)
        cbDropdown:Show()
        cbDropdown:SetFrameLevel(200)
        cbCatcher:SetFrameLevel(199)
    end
end)

cbDropdown:SetScript("OnHide", function()
    GameTooltip:Hide()
    cbCatcher:Hide()
    if cbModeBtn._arrow then
        cbModeBtn._arrow:SetTexture("Interface/Buttons/UI-ScrollBar-ScrollDownButton-Up")
    end
end)
cbDropdown:SetScript("OnShow", function()
    cbCatcher:Show()
    if cbModeBtn._arrow then
        cbModeBtn._arrow:SetTexture("Interface/Buttons/UI-ScrollBar-ScrollUpButton-Up")
    end
end)

UpdateCBDropdownSelection(MidnightObjectiveTrackerDB.colorblindMode or "none")

local gearBtn = CreateFrame("Button", nil, frame)
gearBtn:SetSize(20, 20)
gearBtn:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
gearBtn:SetNormalTexture("Interface\\Scenarios\\ScenarioIcon-Interact")
gearBtn:SetHighlightTexture("Interface\\Scenarios\\ScenarioIcon-Interact")
gearBtn:GetHighlightTexture():SetAlpha(0.4)
gearBtn:SetFrameLevel(frame:GetFrameLevel() + 5)
gearBtn:SetScript("OnClick", function()
    if cbSettingsFrame:IsShown() then
        cbSettingsFrame:Hide()
    else
        local cr = MidnightCopyrightFrame
        if cr and cr:IsShown() then cr:Hide() end
        cbSettingsFrame:Show()
    end
end)

resetButton:SetPoint("TOPRIGHT", mplusButton, "TOPLEFT", -4, 0)

local copyrightFrame = CreateFrame("Frame", "MidnightCopyrightFrame", UIParent, "BackdropTemplate")
copyrightFrame:SetSize(230, 180)
copyrightFrame:SetPoint("TOPRIGHT", frame, "TOPLEFT", 6, 0)
copyrightFrame:SetBackdrop({
    bgFile = "Interface/Buttons/WHITE8X8",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
copyrightFrame:SetBackdropColor(0, 0, 0, 1)
copyrightFrame:SetBackdropBorderColor(1, 0.82, 0, 1)
RegisterBorderedFrame(copyrightFrame)
RegisterWindowBgFrame(copyrightFrame)
copyrightFrame:SetFrameStrata("DIALOG")
copyrightFrame:EnableMouse(true)
copyrightFrame:SetMovable(true)
copyrightFrame:RegisterForDrag("LeftButton")
copyrightFrame:SetScript("OnDragStart", copyrightFrame.StartMoving)
copyrightFrame:SetScript("OnDragStop",  copyrightFrame.StopMovingOrSizing)
copyrightFrame:Hide()
copyrightFrame:HookScript("OnShow", function()
    local wbc = MidnightObjectiveTrackerDB.windowBgColor or { r = 0, g = 0, b = 0 }
    copyrightFrame:SetBackdropColor(wbc.r, wbc.g, wbc.b, 1)
end)
table.insert(UISpecialFrames, "MidnightCopyrightFrame")

local crTitle = copyrightFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
crTitle:SetPoint("TOP", copyrightFrame, "TOP", 0, -14)
crTitle:SetText("Midnight Tracker")
crTitle:SetTextColor(1, 0.82, 0)
RegisterTitleFontString(crTitle)

local crCloseBtn = CreateFrame("Button", nil, copyrightFrame, "UIPanelButtonTemplate")
crCloseBtn:SetSize(20, 20)
crCloseBtn:SetPoint("TOPRIGHT", copyrightFrame, "TOPRIGHT", -10, -10)
crCloseBtn:SetText("X")
crCloseBtn:SetNormalFontObject("GameFontNormalSmall")
crCloseBtn:SetHighlightFontObject("GameFontNormalSmall")
RegisterPanelButton(crCloseBtn)
crCloseBtn:SetScript("OnClick", function() copyrightFrame:Hide() end)
crCloseBtn:SetFrameLevel(copyrightFrame:GetFrameLevel() + 5)

local contactBtn = CreateFrame("Button", nil, copyrightFrame, "UIPanelButtonTemplate")
contactBtn:SetSize(195, 24)
contactBtn:SetPoint("TOP", copyrightFrame, "TOP", 0, -38)
contactBtn:SetText(MidnightL.S("contact_me"))
contactBtn:SetScript("OnClick", function()
    if ChatEdit_ChooseBoxForSend then
        local editBox = ChatEdit_ChooseBoxForSend()
        ChatEdit_ActivateChat(editBox)
        editBox:Insert("https://linktr.ee/poulpix")
        editBox:HighlightText()
    end
end)
contactBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(MidnightL.S("contact_me"), 1, 0.82, 0)
    GameTooltip:AddLine(MidnightL.S("contact_me_tooltip"), 1, 1, 1, true)
    GameTooltip:Show()
end)
contactBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
RegisterPanelButton(contactBtn)

local supportBtn = CreateFrame("Button", nil, copyrightFrame, "UIPanelButtonTemplate")
supportBtn:SetSize(195, 24)
supportBtn:SetPoint("TOP", contactBtn, "BOTTOM", 0, -6)
supportBtn:SetText(MidnightL.S("support_me"))
supportBtn:SetScript("OnClick", function()
    if ChatEdit_ChooseBoxForSend then
        local editBox = ChatEdit_ChooseBoxForSend()
        ChatEdit_ActivateChat(editBox)
        editBox:Insert("buymeacoffee.com/poulpix")
        editBox:HighlightText()
    end
end)
supportBtn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(MidnightL.S("support_me"), 1, 0.82, 0)
    GameTooltip:AddLine(MidnightL.S("support_me_tooltip"), 1, 1, 1, true)
    GameTooltip:Show()
end)
supportBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
RegisterPanelButton(supportBtn)

local crResLabel = copyrightFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
crResLabel:SetPoint("TOP", supportBtn, "BOTTOM", 0, -14)
crResLabel:SetTextColor(1, 0.82, 0)
crResLabel:SetText(MidnightL.S("resources"))

local crResDesc = copyrightFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
crResDesc:SetPoint("TOP", crResLabel, "BOTTOM", 0, -4)
crResDesc:SetWidth(205)
crResDesc:SetJustifyH("CENTER")
crResDesc:SetTextColor(0.75, 0.75, 0.75)
crResDesc:SetWordWrap(true)
crResDesc:SetText(MidnightL.S("resources_short_desc"))

local function ResizeCopyrightFrame()
    local fixedBottom = 38 + 24 + 6 + 24 + 14 + (crResLabel:GetStringHeight() or 14) + 4
    local descH = crResDesc:GetStringHeight() or 0
    local PAD_B = 14
    copyrightFrame:SetHeight(math.ceil(fixedBottom + descH + PAD_B))
end
copyrightFrame:SetScript("OnShow", function()
    C_Timer.After(0, ResizeCopyrightFrame)
end)
C_Timer.After(0, ResizeCopyrightFrame)

local copyrightButton = createLetterButton("\194\169", 32, -10,
    function()
        if copyrightFrame:IsShown() then
            copyrightFrame:Hide()
        else
            cbSettingsFrame:Hide()
            copyrightFrame:Show()
        end
    end,
    nil, nil)

scaleDownBtn:SetPoint("TOPLEFT", copyrightButton, "TOPRIGHT", 4, 0)
scaleUpBtn:SetPoint("TOPLEFT", scaleDownBtn, "TOPRIGHT", 4, 0)

SLASH_MIDNIGHTTRACKER1 = "/som"
SlashCmdList["MIDNIGHTTRACKER"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
        Midnight:Refresh()
    end
end

MidnightObjectiveTrackerDB.minimap = MidnightObjectiveTrackerDB.minimap or {}

local LDB        = LibStub("LibDataBroker-1.1")
local LibDBIcon  = LibStub("LibDBIcon-1.0")

LDB:NewDataObject("MidnightObjectiveTracker", {
    type = "data source",
    text = "MidnightObjectiveTracker",
    icon = "Interface\\AddOns\\MidnightObjectiveTracker\\logo-32-circle",
    OnClick = function(self, button)
        if button == "LeftButton" then
            if frame:IsShown() then
                frame:Hide()
            else
                frame:Show()
                Midnight:Refresh()
            end
        elseif button == "RightButton" then
            GameTooltip:Hide()
            if cbSettingsFrame:IsShown() then
                cbSettingsFrame:Hide()
            else
                local cr = MidnightCopyrightFrame
                if cr and cr:IsShown() then cr:Hide() end
                cbSettingsFrame:Show()
            end
        elseif button == "MiddleButton" then
            if MidnightIlvl and MidnightIlvl.Show and MidnightIlvl.Hide then
                if MidnightIlvlFrame and MidnightIlvlFrame:IsShown() then
                    MidnightIlvl.Hide()
                else
                    MidnightIlvl.Show()
                end
            end
        end
    end,
    OnTooltipShow = function(tooltip)
        tooltip:AddLine("Midnight Objective Tracker", 1, 0.82, 0)
        tooltip:AddLine(MidnightL.S("minimap_open_close"), 1, 1, 1)
        tooltip:AddLine(MidnightL.S("minimap_right_click"), 1, 1, 1)
        tooltip:AddLine(MidnightL.S("minimap_middle_click"), 1, 1, 1)
    end,
})

LibDBIcon:Register("MidnightObjectiveTracker", LDB:GetDataObjectByName("MidnightObjectiveTracker"), MidnightObjectiveTrackerDB.minimap)

C_Timer.After(0, function()
    local savedScale = MidnightObjectiveTrackerDB.scale or 1.0
    ApplyMidnightScale(savedScale)
    ApplyMidnightOpacity(MidnightObjectiveTrackerDB.opacity or 1.0)
    UpdateEscBehavior(MidnightObjectiveTrackerDB.escCloses)
    local tc = MidnightObjectiveTrackerDB.titleColor or { r = 1, g = 0.82, b = 0 }

    colorSwatchBg:SetColorTexture(tc.r or 1, tc.g or 0.82, tc.b or 0, 1)

    ApplyMidnightAccentColor(tc.r or 1, tc.g or 0.82, tc.b or 0)

    local bc = MidnightObjectiveTrackerDB.buttonBgColor or { r = 0.5, g = 0.0, b = 0.0 }
    btnSwatchBg:SetColorTexture(bc.r, bc.g, bc.b, 1)
    ApplyButtonBgColor(bc.r, bc.g, bc.b)

    local wbc = MidnightObjectiveTrackerDB.windowBgColor or { r = 0, g = 0, b = 0 }
    bgSwatchBg:SetColorTexture(wbc.r, wbc.g, wbc.b, 1)
    ApplyWindowBgColor(wbc.r, wbc.g, wbc.b)
end)

do
    local allTextBtns = {
        resetButton, ilvlRefButton, scaleDownBtn, scaleUpBtn, closeBtn,
        planningButton, mplusButton, copyrightButton,
        cbCloseBtn, colorResetBtn, elvBtn,
        resetConfirmYes, resetConfirmNo,
        crCloseBtn, contactBtn, supportBtn,
    }
    for _, btn in ipairs(allTextBtns) do
        RegisterButtonText(btn)
    end
end

local midnightWasShownOnZone = false

local midnightZoneFrame = CreateFrame("Frame")
midnightZoneFrame:RegisterEvent("PLAYER_LEAVING_WORLD")
midnightZoneFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
midnightZoneFrame:SetScript("OnEvent", function(self, event, isInitialLogin, isReloadingUi)
    if event == "PLAYER_LEAVING_WORLD" then
        midnightWasShownOnZone = frame:IsShown()
    elseif event == "PLAYER_ENTERING_WORLD" then
        if isInitialLogin or isReloadingUi then return end
        if midnightWasShownOnZone then
            frame:Show()
            Midnight:Refresh()
        end
        midnightWasShownOnZone = false
    end
end)
