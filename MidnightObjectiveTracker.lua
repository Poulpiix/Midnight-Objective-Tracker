local addonName = ...
local Midnight = {}
_G["MidnightTracker"] = Midnight

MidnightTrackerDB = MidnightTrackerDB or {}

local MPLUS_ICON_TEST = true
_G.MPLUS_ICON_TEST = MPLUS_ICON_TEST

MidnightL.Init()

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

frame:SetBackdropColor(0,0,0,1)
frame:SetBackdropBorderColor(1, 0.82, 0, 1)
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
frame:Hide()

local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -10)
title:SetText(MidnightL.S("title"))

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
menu:SetBackdropColor(0,0,0,1)
menu:SetBackdropBorderColor(1, 0.82, 0, 1)

local menuContent = CreateFrame("Frame", nil, menu)
menuContent:SetPoint("TOPLEFT", 8, -8)
menuContent:SetPoint("BOTTOMRIGHT", -8, 8)

local ilvlPanel = CreateFrame("Frame", "MidnightIlvlPanel", frame, "BackdropTemplate")
ilvlPanel:SetSize(menuWidth, 50)
ilvlPanel:SetPoint("TOPLEFT", menu, "BOTTOMLEFT", 0, -4)
ilvlPanel:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
ilvlPanel:SetBackdropColor(0,0,0,1)
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

local function CreateObjective(parent, text, index, yOffset, weekIndex)
    MidnightTrackerDB = MidnightTrackerDB or {}
    MidnightTrackerDB.checks = MidnightTrackerDB.checks or {}
    local function colorizeText(s)
        if not s or s == "" then return s end
        local loc = MidnightL.GetLocale()
        local ph = {}
        if loc == "en" then
            s = s:gsub('[Cc]hampion [Dd]awn [Cc]rest[s]?', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_champion:14:14:0:0|t |cffff3b3b'..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('[Vv]eteran [Dd]awn [Cc]rest[s]?', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_veteran:14:14:0:0|t |cffC0A0FF'..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('[Hh]eroic [Dd]awn [Cc]rest[s]?', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_hero:14:14:0:0|t |cffFFB86A'..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('[Mm]ythic [Dd]awn [Cc]rest[s]?', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_myth:14:14:0:0|t |cffFFE07A'..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub("[Aa]dventur[^ %.,%(]*", "|cff7FB8FF%0|r")
            s = s:gsub("%f[%a][Hh]eroic%f[%A]", "|cffFFB86A%0|r")
            s = s:gsub("%f[%a][Mm]ythic%f[%A]", "|cffFFE07A%0|r")
            s = s:gsub("%f[%a][Vv]eteran%f[%A]", "|cffC0A0FF%0|r")
            s = s:gsub("%f[%a][Cc]hampion%f[%A]", "|cffff3b3b%0|r")
            s = s:gsub("%f[%a][Hh]ero%f[%A]", "|cffFFB86A%0|r")
            s = s:gsub("%f[%a][Mm]yth%f[%A]", "|cffFFE07A%0|r")
        else
            s = s:gsub('[Eeé]cu[s]? de l.aube de [Cc]hampion', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_champion:14:14:0:0|t |cffff3b3b'..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('[Eeé]cu[s]? de l.aube [Vv][eé]t[eé]ran', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_veteran:14:14:0:0|t |cffC0A0FF'..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('[Eeé]cu[s]? de l.aube [Hh]éroïque', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_hero:14:14:0:0|t |cffFFB86A'..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub('[Eeé]cu[s]? de l.aube mythique', function(m) ph[#ph+1]='|TInterface\\Icons\\inv_120_crest_myth:14:14:0:0|t |cffFFE07A'..m..'|r'; return '@@PH'..#ph..'@@' end)
            s = s:gsub("[Aa]vent[^ %.,%(]*", "|cff7FB8FF%0|r")
            s = s:gsub("%f[%a][Hh][eé]ro[iï]?que%f[%A]", "|cffFFB86A%0|r")
            s = s:gsub("%f[%a][Hh][eé]ro%f[%A]", "|cffFFB86A%0|r")
            s = s:gsub("%f[%a][Mm]ythe%f[%A]", "|cffFFE07A%0|r")
            s = s:gsub("%f[%a][Vv][eé]t[eé]ran%f[%A]", "|cffC0A0FF%0|r")
            s = s:gsub("%f[%a][Cc]hampion%f[%A]", "|cffff3b3b%0|r")
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
            prefix = "|cff7CFFB8" .. prefix .. "|r"
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

    weekScrolls = {}

        if not frame or not frame:IsShown() then
            poll.last = -1
            poll.timer = 0
            return
        end
    local yOffset = -10

    local weeks = getWeeks()
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
    local menuLabels = getMenuLabels()
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
        txt:SetText(menuLabels[i] or week.title or ("Week " .. i))
        txt:SetTextColor(1,1,1)

        menuButtons[i] = { btn = btn, txt = txt, bullet = bullet }

        btn:SetScript("OnClick", function()
            activeMenuIndex = i
            UpdateMenuActive()
            UpdateIlvlPanel()
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
    
    weekEstimatedIlvl = {}
    local weeks2 = getWeeks()
    for i, week in ipairs(weeks2) do
        weekEstimatedIlvl[i] = parseEstimatedIlvl(week.objectives)
    end

    if not activeMenuIndex then activeMenuIndex = 1 end
    UpdateMenuActive()
    UpdateIlvlPanel()
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
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
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

local resourcesButton = createLetterButton("R", 76, -10,
    function()
        local url = "https://docs.google.com/document/u/1/d/e/2PACX-1vTAN9Hjl-_ZhxofBUn4qKM0UNkEx2MTePWg61IcD_b5Vo6istu8YAivtINMz5QX5oxY7prnKfACIQcx/pub"
        if ChatEdit_ChooseBoxForSend then
            local editBox = ChatEdit_ChooseBoxForSend()
            ChatEdit_ActivateChat(editBox)
            editBox:Insert(url)
            editBox:HighlightText()
        end
    end,
    MidnightL.S("resources"),
    MidnightL.S("resources_desc"))

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
    if Midnight.allCheckboxes then
        for _, entry in ipairs(Midnight.allCheckboxes) do
            if entry.cb and entry.cb.SetChecked then
                entry.cb:SetChecked(false)
            end
            if entry.applyFn then
                entry.applyFn(false)
            end
        end
    end
end)
resetButton:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    GameTooltip:ClearLines()
    GameTooltip:AddLine(MidnightL.S("reset_checks"))
    GameTooltip:AddLine(MidnightL.S("reset_checks_desc"), 1,1,1, true)
    GameTooltip:Show()
end)
resetButton:SetScript("OnLeave", function() GameTooltip:Hide() end)
resetButton:SetFrameLevel(frame:GetFrameLevel() + 5)

local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -6, -6)
closeBtn:SetScript("OnClick", function()
    frame:Hide()
end)
closeBtn:SetFrameLevel(frame:GetFrameLevel() + 5)

local planningButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
planningButton:SetSize(57, 22)
planningButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -34, -6)
planningButton:SetText(MidnightL.S("planning"))
planningButton:SetScript("OnClick", function()
    if MidnightPlanning and MidnightPlanning.Show and MidnightPlanning.Hide then
        if MidnightPlanningFrame and MidnightPlanningFrame:IsShown() then
            MidnightPlanning.Hide()
        else
            MidnightPlanning.Show()
        end
    end
end)
planningButton:SetFrameLevel(frame:GetFrameLevel() + 5)

local mplusButton = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
mplusButton:SetSize(43, 22)
mplusButton:SetPoint("TOPRIGHT", planningButton, "TOPLEFT", -2, 0)
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

SLASH_MIDNIGHTTRACKER1 = "/som"
SlashCmdList["MIDNIGHTTRACKER"] = function()
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
        Midnight:Refresh()
    end
end

print(MidnightL.S("slash_msg"))

