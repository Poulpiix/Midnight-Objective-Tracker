local Mplus = {}
_G["MidnightMplus"] = Mplus

local function getCSV()
    return MidnightL[MidnightL.GetLocale()].mplus_csv
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

local mframe = CreateFrame("Frame", "MidnightMplusFrame", UIParent, "BackdropTemplate")
mframe:SetSize(600, 500)
mframe:SetPoint("CENTER")
mframe:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
mframe:SetBackdropColor(0, 0, 0, 1)
mframe:SetBackdropBorderColor(1, 0.82, 0, 1)
mframe:SetMovable(true)
mframe:EnableMouse(true)
mframe:RegisterForDrag("LeftButton")
mframe:SetScript("OnDragStart", mframe.StartMoving)
mframe:SetScript("OnDragStop", mframe.StopMovingOrSizing)
mframe:Hide()

local mtitle = mframe:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
mtitle:SetPoint("TOP", mframe, "TOP", 0, -15)
mtitle:SetText(MidnightL.S("mplus_title"))

local headerHeight = 36
local headerFrame = CreateFrame("Frame", "MidnightMplusHeader", mframe, "BackdropTemplate")
headerFrame:SetHeight(headerHeight)
headerFrame:SetPoint("TOPLEFT", mframe, "TOPLEFT", 10, -36)
headerFrame:SetPoint("TOPRIGHT", mframe, "TOPRIGHT", -10, -36)
headerFrame:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 12,
    insets = { left = 6, right = 6, top = 6, bottom = 6 },
})
headerFrame:SetBackdropColor(0, 0, 0, 1)
headerFrame:SetBackdropBorderColor(0.9, 0.7, 0.2, 1)
headerFrame:SetFrameLevel((mframe:GetFrameLevel() or 0) + 10)

local mclose = CreateFrame("Button", nil, mframe, "UIPanelCloseButton")
mclose:SetPoint("TOPRIGHT", mframe, "TOPRIGHT", -6, -6)

local scroll = CreateFrame("ScrollFrame", nil, mframe, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", mframe, "TOPLEFT", 10, -(36 + headerHeight + 6))
scroll:SetPoint("BOTTOMRIGHT", mframe, "BOTTOMRIGHT", -10, 10)

local content = CreateFrame("Frame", nil, scroll)
content:SetWidth((mframe:GetWidth() or 600) - 20)
content:SetPoint("TOPLEFT", scroll, "TOPLEFT", 10, -4)
scroll:SetScrollChild(content)

local rows = {}

local function RefreshMplus()
    for _, r in ipairs(rows) do if type(r.Hide) == 'function' then r:Hide() end end
    rows = {}
    for _, v in ipairs({headerFrame:GetChildren()}) do if type(v.Hide) == 'function' then v:Hide() end end
    local y = -6
    local csv_data = getCSV()
    local parsed = parseCSV(csv_data)
    if #parsed == 0 then
        local placeholder = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        placeholder:SetPoint("TOPLEFT", 10, y)
        placeholder:SetJustifyH("LEFT")
        placeholder:SetText(MidnightL.S("no_data"))
        placeholder:SetTextColor(1,0.7,0)
        table.insert(rows, placeholder)
        content:SetHeight(-y)
        return
    end

    local headers = parsed[1] or {}
    local nCols = #headers
    local hx = 10
    local colGap = 12
    local frameW = (headerFrame:GetWidth() or mframe:GetWidth() or 600)
    local availableW = frameW - (2 * hx) - (nCols - 1) * colGap
    local colW = math.floor(availableW / nCols)
    local colWidths = {}
    for c = 1, nCols do colWidths[c] = colW end
    local leftover = availableW - colW * nCols
    if leftover > 0 then colWidths[nCols] = colWidths[nCols] + leftover end

    local curX = hx
    for c = 1, nCols do
        local hh = headerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        hh:SetPoint("TOPLEFT", headerFrame, "TOPLEFT", curX, 0)
        hh:SetWidth(colWidths[c])
        hh:SetHeight(headerHeight)
        hh:SetJustifyH("CENTER")
        hh:SetWordWrap(true)
        local htext = headers[c] or ("Col "..c)
        htext = htext:gsub("%s*%b()", "")
        htext = htext:gsub("^%s+", ""):gsub("%s+$", "")
        hh:SetText(htext)
        hh:SetTextColor(1,0.82,0)
        table.insert(rows, hh)
        curX = curX + colWidths[c] + colGap
    end

    local defaultRowHeight = 22
    for i = 2, #parsed do
        local row = parsed[i]
        local cellObjects = {}
        local maxContentH = 0
        local cx = hx

        for c = 1, nCols do
            local cell = row[c] or ""
            local f = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            f:SetWidth(colWidths[c])
            f:SetJustifyH("CENTER")
            f:SetWordWrap(true)

            local displayText = cell
            if cell == "TBA" then
                displayText = "|cff888888TBA|r"
            else
                local num, rest = cell:match("^%s*([%dX]+)%s*(.*)$")
                if num and rest and rest ~= "" then
                    local whiteNum = "|cffffffff" .. num .. "|r"
                    local leadX, restCore = rest:match("^%s*(x)%s*(.*)$")
                    local lead = ""
                    if leadX and leadX ~= "" then
                        lead = "|cffffffff" .. leadX .. "|r"
                    end
                    restCore = restCore or rest
                    local norm = restCore:gsub("\226\128\153", "'"):lower()
                    local coloredCore = "|cffffffff" .. restCore .. "|r"
                    if norm:find("mythique", 1, true) or norm:find("mythic dawn", 1, true) then
                        coloredCore = "|TInterface\\Icons\\inv_120_crest_myth:14:14:0:0|t |cffFFE07A" .. restCore .. "|r"
                    elseif norm:find("aube h", 1, true) or norm:find("heroic dawn", 1, true) then
                        coloredCore = "|TInterface\\Icons\\inv_120_crest_hero:14:14:0:0|t |cffFFB86A" .. restCore .. "|r"
                    elseif norm:find("aventure", 1, true) or norm:find("adventurer", 1, true) then
                        coloredCore = "|cff69C864" .. restCore .. "|r"
                    elseif (norm:find("ran", 1, true) and norm:find("aube", 1, true)) or norm:find("veteran dawn", 1, true) then
                        coloredCore = "|TInterface\\Icons\\inv_120_crest_veteran:14:14:0:0|t |cff6699FF" .. restCore .. "|r"
                    end
                    displayText = lead ~= "" and (whiteNum .. lead .. " " .. coloredCore) or (whiteNum .. " " .. coloredCore)
                elseif cell ~= "" then
                    displayText = "|cffffffff" .. cell .. "|r"
                end
            end

            f:SetText(displayText)
            f:SetTextColor(1,1,1)
            table.insert(rows, f)
            table.insert(cellObjects, {obj = f, x = cx})
            local fh = f:GetStringHeight() or 0
            if fh > maxContentH then maxContentH = fh end
            cx = cx + colWidths[c] + colGap
        end

        local usedHeight = math.max(defaultRowHeight, math.ceil(maxContentH) + 8)

        for _, co in ipairs(cellObjects) do
            local fh = co.obj:GetStringHeight() or 0
            local yOffset = y - math.floor((usedHeight - fh) / 2)
            co.obj:SetPoint("TOPLEFT", content, "TOPLEFT", co.x, yOffset)
        end

        if (i % 2) == 0 then
            local bg = content:CreateTexture(nil, "BACKGROUND")
            bg:SetColorTexture(0, 0, 0, 0.18)
            bg:SetPoint("TOPLEFT", content, "TOPLEFT", 10, y)
            bg:SetPoint("TOPRIGHT", content, "TOPRIGHT", -10, y)
            bg:SetHeight(usedHeight)
            table.insert(rows, bg)
        end

        y = y - usedHeight
    end

    content:SetHeight(-y)
    if scroll and scroll.SetHorizontalScroll then
        scroll:SetHorizontalScroll(0)
    end
end

function Mplus.Show()
    mtitle:SetText(MidnightL.S("mplus_title"))
    RefreshMplus()
    mframe:Show()
end

function Mplus.Hide()
    mframe:Hide()
end

MidnightMplusData = getCSV()
