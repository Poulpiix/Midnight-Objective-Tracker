local Mplus = {}
_G["MidnightMplus"] = Mplus

local SECTION_GAP = 8

local function getCSVSections()
    local loc = MidnightL[MidnightL.GetLocale()]
    return {
        { title = loc.mplus_section_raids,  csv = loc.mplus_csv_raids  },
        { title = loc.mplus_section_mplus,  csv = loc.mplus_csv_mplus  },
        { title = loc.mplus_section_delves, csv = loc.mplus_csv_delves },
        { title = loc.mplus_section_traque, csv = loc.mplus_csv_traque },
    }
end

local function parseCSV(s)
    local marker = "<<NL>>"
    local charsOut = {}
    local inQuotes = false
    for i = 1, #s do
        local c = s:sub(i,i)
        if c == '"' then
            if inQuotes and s:sub(i+1,i+1) == '"' then
                table.insert(charsOut, '"')
                i = i + 1
            else
                inQuotes = not inQuotes
            end
        elseif (c == '\n' or c == '\r') and inQuotes then
            table.insert(charsOut, marker)
        else
            table.insert(charsOut, c)
        end
    end
    local norm = table.concat(charsOut)

    local rawLines = {}
    local cur = ""
    for i = 1, #norm do
        local c = norm:sub(i,i)
        if c == '\n' then
            table.insert(rawLines, cur)
            cur = ""
        else
            cur = cur .. c
        end
    end
    if cur ~= "" then table.insert(rawLines, cur) end

    local rows = {}
    for _, line in ipairs(rawLines) do
        local row = {}
        local j = 1
        local L = #line
        while j <= L do
            local ch = line:sub(j,j)
            if ch == '"' then
                j = j + 1
                local buf = {}
                while j <= L do
                    local ch2 = line:sub(j,j)
                    if ch2 == '"' then
                        if line:sub(j+1,j+1) == '"' then
                            table.insert(buf, '"')
                            j = j + 2
                        else
                            j = j + 1
                            break
                        end
                    else
                        table.insert(buf, ch2)
                        j = j + 1
                    end
                end
                local field = table.concat(buf)
                field = field:gsub(marker, "\n")
                table.insert(row, field)
                if line:sub(j,j) == ',' then j = j + 1 end
            else
                local buf = {}
                while j <= L do
                    local ch2 = line:sub(j,j)
                    if ch2 == ',' then j = j + 1 break end
                    table.insert(buf, ch2)
                    j = j + 1
                end
                local field = table.concat(buf)
                field = field:gsub(marker, "\n")
                field = (field:gsub("^%s+", ""):gsub("%s+$", ""))
                table.insert(row, field)
            end
        end
        table.insert(rows, row)
    end
    return rows
end

local function getAccent()
    if MidnightTracker and MidnightTracker.GetAccentColor then
        return MidnightTracker.GetAccentColor()
    end
    return 1, 0.82, 0
end

local PAD_L = 15
local PAD_R = 15
local PAD_T = 48
local PAD_B = 14

local mframe = CreateFrame("Frame", "MidnightMplusFrame", UIParent, "BackdropTemplate")
mframe:SetSize(360, 200)
mframe:SetPoint("TOPRIGHT", MidnightTrackerFrame, "TOPLEFT", 6, 0)
mframe:SetBackdrop({
    bgFile = "Interface/Buttons/WHITE8X8",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets   = { left = 8, right = 8, top = 8, bottom = 8 },
})
mframe:SetBackdropColor(0, 0, 0, 1)
mframe:SetBackdropBorderColor(1, 0.82, 0, 1)
if MidnightTracker and MidnightTracker.RegisterBorderedFrame then MidnightTracker.RegisterBorderedFrame(mframe) end
mframe:SetMovable(true)
mframe:EnableMouse(true)
mframe:RegisterForDrag("LeftButton")
mframe:SetScript("OnDragStart", mframe.StartMoving)
mframe:SetScript("OnDragStop",  mframe.StopMovingOrSizing)
mframe:Hide()
table.insert(UISpecialFrames, "MidnightMplusFrame")

local mtitle = mframe:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
mtitle:SetPoint("TOP", mframe, "TOP", 0, -15)
do local ar, ag, ab = getAccent(); mtitle:SetTextColor(ar, ag, ab) end
mtitle:SetText(MidnightL.S("mplus_title"))

local msubtitle = mframe:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
msubtitle:SetPoint("TOP", mtitle, "BOTTOM", 0, -2)
msubtitle:SetText(MidnightL.FormatMplusSubtitle() or MidnightL.S("mplus_subtitle"))

local mclose = CreateFrame("Button", nil, mframe, "UIPanelButtonTemplate")
mclose:SetSize(20, 20)
mclose:SetPoint("TOPRIGHT", mframe, "TOPRIGHT", -10, -10)
mclose:SetText("X")
mclose:SetNormalFontObject("GameFontNormalSmall")
mclose:SetHighlightFontObject("GameFontNormalSmall")
mclose:SetScript("OnClick", function()
    mframe:Hide()
end)
mclose:SetFrameLevel(mframe:GetFrameLevel() + 5)
if MidnightTracker and MidnightTracker.RegisterButtonText then MidnightTracker.RegisterButtonText(mclose) end
if MidnightTracker and MidnightTracker.RegisterPanelButton then MidnightTracker.RegisterPanelButton(mclose) end

local content = CreateFrame("Frame", nil, mframe)
content:SetPoint("TOPLEFT", mframe, "TOPLEFT", PAD_L, -PAD_T)
content:SetSize(100, 100)

local rows = {}

local function RefreshMplus()
    for _, r in ipairs(rows) do if type(r.Hide) == 'function' then r:Hide() end end
    rows = {}

    local sections    = getCSVSections()
    local colSpacing  = 5
    local bgExtend    = 7
    local headerH     = 20
    local defaultRowH = 15
    local sectionTitleH = 18

    local availW = math.max(150, mframe:GetWidth() - PAD_L - PAD_R)
    local widths = { 115, math.max(60, availW - 115 - colSpacing) }
    local totalTableW = widths[1] + widths[2] + colSpacing

    local y = 0

    for si, section in ipairs(sections) do
        local parsed = parseCSV(section.csv or "")
        if #parsed >= 2 then
            local stitleBg = content:CreateTexture(nil, "BACKGROUND")
            do local ar, ag, ab = getAccent(); stitleBg:SetColorTexture(ar, ag * 0.95, ab, 0.18) end
            stitleBg:SetPoint("TOPLEFT", content, "TOPLEFT", -bgExtend, y)
            stitleBg:SetSize(totalTableW + bgExtend * 2, sectionTitleH)
            table.insert(rows, stitleBg)
            local stitle = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            stitle:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
            stitle:SetWidth(totalTableW)
            stitle:SetHeight(sectionTitleH)
            stitle:SetJustifyH("CENTER")
            stitle:SetJustifyV("MIDDLE")
            do local ar, ag, ab = getAccent(); stitle:SetTextColor(ar, ag, ab) end
            stitle:SetText(section.title or "")
            table.insert(rows, stitle)
            y = y - sectionTitleH
            local headerBg = content:CreateTexture(nil, "BACKGROUND")
            headerBg:SetColorTexture(0.08, 0.08, 0.14, 0.85)
            headerBg:SetPoint("TOPLEFT", content, "TOPLEFT", -bgExtend, y)
            headerBg:SetSize(totalTableW + bgExtend * 2, headerH)
            table.insert(rows, headerBg)
            local headers = parsed[1] or {}
            local hx = 0
            for ci = 1, 2 do
                local h = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                h:SetPoint("TOPLEFT", content, "TOPLEFT", hx, y)
                h:SetWidth(widths[ci] or 100)
                h:SetHeight(headerH)
                h:SetJustifyH("CENTER")
                h:SetJustifyV("MIDDLE")
                local htext = headers[ci] or ("Col " .. ci)
                if ci == 1 then
                    htext = MidnightL.S("ilvl_season")
                else
                    htext = htext:gsub("%s*%b()", ""):match("^%s*(.-)%s*$") or htext
                end
                h:SetText(htext)
                do local ar, ag, ab = getAccent(); h:SetTextColor(ar, ag, ab) end
                table.insert(rows, h)
                hx = hx + (widths[ci] or 100) + colSpacing
            end
            y = y - headerH

            for i = 2, #parsed do
                local row      = parsed[i]
                local cellObjs = {}
                local maxH     = 0
                local cx       = 0

                for c = 1, 2 do
                    local cell = row[c] or ""
                    local f = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                    f:SetWidth(widths[c] or 100)
                    f:SetJustifyH(c == 1 and "LEFT" or "CENTER")
                    f:SetWordWrap(true)

                    local displayText = cell
                    if cell == "TBA" then
                        displayText = "|cff888888TBA|r"
                    else
                        local num, rest = cell:match("^%s*([%dX?]+)%s*(.*)$")
                        if num and rest and rest ~= "" then
                            local whiteNum = "|cffffffff" .. num .. "|r"
                            local leadX, restCore = rest:match("^%s*(x)%s*(.*)$")
                            local lead = ""
                            if leadX and leadX ~= "" then
                                lead = "|cffffffff" .. leadX .. "|r"
                            end
                            restCore = restCore or rest
                            restCore = restCore:gsub("^x%s+", "")
                            local norm = restCore:gsub("\226\128\153", "'"):lower()
                            local coloredCore = "|cffffffff" .. restCore .. "|r"
                            if norm:find("mythique", 1, true) or norm:find("mythic dawn", 1, true)
                            or norm:find("mythisch", 1, true) or norm:find("amanecer m", 1, true) then
                                coloredCore = "|TInterface\\Icons\\inv_120_crest_myth:14:14:0:0|t |cff" .. MidnightL.C("mythic") .. restCore .. "|r"
                            elseif norm:find("aube h", 1, true) or norm:find("heroic dawn", 1, true)
                            or norm:find("heroisch", 1, true) or norm:find("amanecer hero", 1, true) then
                                coloredCore = "|TInterface\\Icons\\inv_120_crest_hero:14:14:0:0|t |cff" .. MidnightL.C("heroic") .. restCore .. "|r"
                            elseif norm:find("aventure", 1, true) or norm:find("adventurer", 1, true) or norm:find("abenteurer", 1, true) then
                                coloredCore = "|TInterface\\Icons\\inv_120_crest_adventurer:14:14:0:0|t |cff" .. MidnightL.C("adventurer") .. restCore .. "|r"
                            elseif (norm:find("ran", 1, true) and norm:find("aube", 1, true)) or norm:find("veteran", 1, true) then
                                coloredCore = "|TInterface\\Icons\\inv_120_crest_veteran:14:14:0:0|t |cff" .. MidnightL.C("veteran") .. restCore .. "|r"
                            elseif norm:find("champion", 1, true) or norm:find("campe", 1, true) then
                                coloredCore = "|TInterface\\Icons\\inv_120_crest_champion:14:14:0:0|t |cff" .. MidnightL.C("champion") .. restCore .. "|r"
                            end
                            displayText = lead ~= "" and (whiteNum .. lead .. " " .. coloredCore) or (whiteNum .. " " .. coloredCore)
                        elseif cell ~= "" then
                            displayText = "|cffffffff" .. cell .. "|r"
                        end
                    end

                    f:SetText(displayText)
                    f:SetTextColor(1, 1, 1)
                    table.insert(rows, f)
                    table.insert(cellObjs, { obj = f, x = cx })
                    local fh = f:GetStringHeight() or 0
                    if fh > maxH then maxH = fh end
                    cx = cx + (widths[c] or 100) + colSpacing
                end

                local usedH = math.max(defaultRowH, math.ceil(maxH) + 4)

                for _, co in ipairs(cellObjs) do
                    co.obj:SetPoint("TOPLEFT", content, "TOPLEFT", co.x, y)
                    co.obj:SetHeight(usedH)
                    co.obj:SetJustifyV("MIDDLE")
                end

                if (i % 2) == 0 then
                    local bg = content:CreateTexture(nil, "BACKGROUND")
                    bg:SetColorTexture(0, 0, 0, 0.25)
                    bg:SetPoint("TOPLEFT", content, "TOPLEFT", -bgExtend, y)
                    bg:SetSize(totalTableW + bgExtend * 2, usedH)
                    table.insert(rows, bg)
                end

                y = y - usedH
            end
        end

        if si < #sections then
            y = y - SECTION_GAP
        end
    end

    local contentH = -y
    content:SetSize(totalTableW, contentH)
    local frameW = totalTableW + PAD_L + PAD_R
    local frameH = PAD_T + contentH + PAD_B
    mframe:SetSize(math.max(200, frameW), math.max(80, frameH))
    content:ClearAllPoints()
    content:SetPoint("TOP", mframe, "TOP", 0, -PAD_T)
    content:Hide(); content:Show()
end

function Mplus.Show()
    mtitle:SetText(MidnightL.S("mplus_title"))
    do local ar, ag, ab = getAccent(); mtitle:SetTextColor(ar, ag, ab) end
    msubtitle:SetText(MidnightL.FormatMplusSubtitle() or MidnightL.S("mplus_subtitle"))
    RefreshMplus()
    mframe:Show()
    C_Timer.After(0, RefreshMplus)
end

function Mplus.Hide()
    mframe:Hide()
end

if MidnightTracker and MidnightTracker.RegisterAccentColorCallback then
    MidnightTracker.RegisterAccentColorCallback(function(r, g, b)
        mtitle:SetTextColor(r, g, b)
        if mframe:IsShown() then
            RefreshMplus()
        end
    end)
end
