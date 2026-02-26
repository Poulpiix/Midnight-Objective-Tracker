local Planning = {}
_G["MidnightPlanning"] = Planning

local function getPlanningCSV()
    return MidnightL[MidnightL.GetLocale()].planning_csv
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

    for _, r in ipairs(rows) do
        for k = 1, #r do
            if type(r[k]) == 'string' then
                r[k] = (r[k]:gsub("^%s+", ""):gsub("%s+$", ""))
            end
        end
    end
    return rows
end

local function buildPlanningTableFromCSV(csv)
    local rows = parseCSV(csv)
    if #rows == 0 then return { headers = {}, rows = {} } end
    local headers = rows[1]
    local data = {}
    for i = 2, #rows do
        table.insert(data, rows[i])
    end
    return { headers = headers, rows = data }
end

local planningTable = {}
local planningBuilt = false
local columnOffset = 0
local maxVisibleColumns = 11
local function isHeaderHidden(h)
    if not h then return false end
    h = (h:gsub("^%s+", ""):gsub("%s+$", ""))
    if h:match("^[Qq]u[eè]t") or h:match("^Quêtes") or h:match("^[Qq]uests") then return true end
    return false
end
local colRangeLabel = nil
local headerHeight = 36
local DEBUG_ALIGN = false

local function getUsedCols(headers, dataRows)
    local maxCols = #headers
    for _, r in ipairs(dataRows) do if #r > maxCols then maxCols = #r end end
    local usedCols = {}
    for ci = 1, maxCols do
        local keep = false
        if headers[ci] and headers[ci]:match('%S') and not isHeaderHidden(headers[ci]) then
            keep = true
        end
        if not keep then
            for _, r in ipairs(dataRows) do
                if r[ci] and r[ci]:match('%S') then
                    if not isHeaderHidden(headers[ci]) then keep = true end
                    break
                end
            end
        end
        if keep then table.insert(usedCols, ci) end
    end
    return usedCols
end

local function ensurePlanningBuilt()
    if planningBuilt then return end
    local ok, res = pcall(buildPlanningTableFromCSV, getPlanningCSV())
    if not ok then
        print(MidnightL.S("csv_error") .. tostring(res))
        planningTable = { headers = {}, rows = {} }
        planningBuilt = true
        return
    end
    planningTable = res or { headers = {}, rows = {} }
    planningBuilt = true
end

local pframe = CreateFrame("Frame", "MidnightPlanningFrame", UIParent, "BackdropTemplate")
pframe:SetSize(1200, 760)
pframe:SetPoint("CENTER")
pframe:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})

pframe:SetBackdropColor(0, 0, 0, 1)
pframe:SetBackdropBorderColor(1, 0.82, 0, 1)
pframe:SetMovable(true)
pframe:EnableMouse(true)
pframe:RegisterForDrag("LeftButton")
pframe:SetScript("OnDragStart", pframe.StartMoving)
pframe:SetScript("OnDragStop", pframe.StopMovingOrSizing)
pframe:Hide()

local ptitle = pframe:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
ptitle:SetPoint("TOP", pframe, "TOP", 0, -15)
ptitle:SetText(MidnightL.S("planning_title"))

local pclose = CreateFrame("Button", nil, pframe, "UIPanelCloseButton")
pclose:SetPoint("TOPRIGHT", pframe, "TOPRIGHT", -6, -6)

local headerFrame = CreateFrame("Frame", "MidnightPlanningHeader", pframe, "BackdropTemplate")
headerFrame:SetHeight(headerHeight)
headerFrame:SetPoint("TOPLEFT", nil, "TOPLEFT", 0, 0)
headerFrame:SetBackdrop({
    bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 12,
    insets = { left = 6, right = 6, top = 6, bottom = 6 },
})
headerFrame:SetBackdropColor(0, 0, 0, 1)
headerFrame:SetBackdropBorderColor(0.9, 0.7, 0.2, 1)

local prevColBtn = CreateFrame("Button", nil, pframe, "UIPanelButtonTemplate")
prevColBtn:SetSize(28, 20)
prevColBtn:SetPoint("TOPRIGHT", pframe, "TOPRIGHT", -84, -8)
prevColBtn:SetText("<")
prevColBtn:SetScript("OnClick", function()
    ensurePlanningBuilt()
    local usedCols = getUsedCols(planningTable.headers or {}, planningTable.rows or {})
    local total = #usedCols
    local maxVisible = maxVisibleColumns or 8
    columnOffset = math.max(0, columnOffset - 1)
    columnOffset = math.min(columnOffset, math.max(0, total - maxVisible))
    RefreshPlanning()
end)
prevColBtn:Hide()

local nextColBtn = CreateFrame("Button", nil, pframe, "UIPanelButtonTemplate")
nextColBtn:SetSize(28, 20)
nextColBtn:SetPoint("TOPRIGHT", pframe, "TOPRIGHT", -48, -8)
nextColBtn:SetText(">")
nextColBtn:SetScript("OnClick", function()
    ensurePlanningBuilt()
    local usedCols = getUsedCols(planningTable.headers or {}, planningTable.rows or {})
    local total = #usedCols
    local maxVisible = maxVisibleColumns or 8
    columnOffset = math.min(columnOffset + 1, math.max(0, total - maxVisible))
    RefreshPlanning()
end)
nextColBtn:Hide()

colRangeLabel = pframe:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
colRangeLabel:SetPoint("TOP", pframe, "TOP", 0, -28)
colRangeLabel:SetText("")
colRangeLabel:Hide()

local scroll = CreateFrame("ScrollFrame", nil, pframe, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", pframe, "TOPLEFT", 10, - (36 + headerHeight + 6))
scroll:SetPoint("BOTTOMRIGHT", pframe, "BOTTOMRIGHT", -10, 10)

local content = CreateFrame("Frame", nil, scroll)
content:SetSize(1140, 1)
content:SetPoint("TOPLEFT", scroll, "TOPLEFT", 10, -4)
scroll:SetScrollChild(content)

headerFrame:ClearAllPoints()
    headerFrame:SetPoint("TOPLEFT", pframe, "TOPLEFT", 10, -36)
    headerFrame:SetPoint("TOPRIGHT", pframe, "TOPRIGHT", -10, -36)
headerFrame:SetFrameLevel((pframe:GetFrameLevel() or 0) + 10)

local rows = {}

local ICON_SPARK = "|TInterface\\Icons\\inv_12_profession_questandcrafting_sparkwhole_gold:14:14:0:0|t "
local ICON_ADV   = "|TInterface\\Icons\\inv_120_crest_adventurer:14:14:0:0|t "
local ICON_VET   = "|TInterface\\Icons\\inv_120_crest_veteran:14:14:0:0|t "
local ICON_HERO  = "|TInterface\\Icons\\inv_120_crest_hero:14:14:0:0|t "
local ICON_MYTH  = "|TInterface\\Icons\\inv_120_crest_myth:14:14:0:0|t "
local ICON_CHAMP = "|TInterface\\Icons\\inv_120_crest_champion:14:14:0:0|t "

local function colorizeIlvlNumber(text)
    if not text or text == "" then return text end
    return text:gsub("(%d+)", function(numStr)
        local n = tonumber(numStr)
        if not n then return numStr end
        if n >= 272 and n <= 289 then
            return "|cffFFE07A" .. numStr .. "|r"
        elseif n >= 259 and n <= 271 then
            return "|cffFFB86A" .. numStr .. "|r"
        elseif n >= 246 and n <= 258 then
            return "|cffff3b3b" .. numStr .. "|r"
        elseif n >= 233 and n <= 245 then
            return "|cffC0A0FF" .. numStr .. "|r"
        elseif n >= 207 and n <= 232 then
            return "|cff7FB8FF" .. numStr .. "|r"
        end
        return numStr
    end)
end

local function colorizePlanningCell(text)
    if not text or text == "" then return text end
    text = text:gsub(" +\n", "\n")
    local loc = MidnightL.GetLocale()
    if loc == "en" then
        text = text:gsub("(Spark of Radiance)", ICON_SPARK .. "|cffFFD100%1|r")
        text = text:gsub("(Champion Dawn Crest[s]?)", ICON_CHAMP .. "|cffff3b3b%1|r")
        text = text:gsub("(Veteran Dawn Crest[s]?)", ICON_VET .. "|cffC0A0FF%1|r")
        text = text:gsub("(Heroic Dawn Crest[s]?)", ICON_HERO .. "|cffFFB86A%1|r")
        text = text:gsub("(Mythic Dawn Crest[s]?)", ICON_MYTH .. "|cffFFE07A%1|r")
        text = text:gsub("(Adventurer Dawn Crest[s]?)", ICON_ADV .. "|cff7FB8FF%1|r")
    else
        text = text:gsub("(Etincelle de radiance)", ICON_SPARK .. "|cffFFD100%1|r")
        text = text:gsub("([Ee]cu[s]? de l'aube de [Cc]hampion)", ICON_CHAMP .. "|cffff3b3b%1|r")
        text = text:gsub("([Ee]cu[s]? de l'aube vétéran)", ICON_VET .. "|cffC0A0FF%1|r")
        text = text:gsub("([Ee]cu[s]? de l'aube héroïque)", ICON_HERO .. "|cffFFB86A%1|r")
        text = text:gsub("([Ee]cu[s]? de l'aube mythique)", ICON_MYTH .. "|cffFFE07A%1|r")
        text = text:gsub("([Ee]cu[s]? de l'aube d'aventure)", ICON_ADV .. "|cff7FB8FF%1|r")
    end
    return text
end

local function RefreshPlanning()
    for _, r in ipairs(rows) do r:Hide() end
    rows = {}
    local y = -6
    planningBuilt = false
    ensurePlanningBuilt()
    local headers = planningTable.headers or {}
    local dataRows = planningTable.rows or {}

    if #dataRows == 0 then
        local placeholder = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        placeholder:SetPoint("TOPLEFT", 10, y)
        placeholder:SetJustifyH("LEFT")
        placeholder:SetText(MidnightL.S("no_csv_data"))
        placeholder:SetTextColor(1,0.7,0)
        table.insert(rows, placeholder)
        y = y - 18
        content:SetHeight(-y)
        return
    end
    local usedCols = getUsedCols(headers, dataRows)
    if #usedCols == 0 then usedCols = {1} end
    local maxVisible = maxVisibleColumns or 8
    local totalUsed = #usedCols

    local visibleCols = {}
    for _, ci in ipairs(usedCols) do table.insert(visibleCols, ci) end
    local truncated = false

    local totalWidth = math.max(100, math.floor((headerFrame:GetWidth() or scroll:GetWidth() or content:GetWidth()) - 20))
    local colSpacing = 8
    local nCols = #visibleCols

    local headerTexts = {}
    for vi, ci in ipairs(visibleCols) do
        local rawh = headers[ci] and headers[ci] ~= "" and headers[ci] or ("Col "..ci)
        local htext
        if ci == 1 then
            htext = (headers[ci] and headers[ci] ~= "") and headers[ci] or "ilvl"
        else
            if rawh:match("[Qq]u[eè]te") or rawh:match("[Qq]uests?") then
                htext = MidnightL.GetLocale() == "en" and "Expedition" or "Expédition"
            else
                htext = rawh
            end
        end
        headerTexts[vi] = htext
    end

    local fixedByIdx = {}
    local flexCandidates = {}
    for vi, txt in ipairs(headerTexts) do
        if txt:match("Chambre forte") or txt:match("Vault") then
            fixedByIdx[vi] = 80
        elseif txt:match("Gouffre Abondant") or txt:match("Bountiful") then
            fixedByIdx[vi] = 70
        elseif txt:match("Gouffre Primes") or txt:match("Gouffre Prime") or txt:match("Prime Delve") then
            fixedByIdx[vi] = 72
        elseif txt:match("Traque") or txt:match("Prey") then
            fixedByIdx[vi] = 90
        elseif txt:match("[Qq]u[eè]te") or txt:match("Expédition") or txt:match("Expedition") then
            fixedByIdx[vi] = 110
        elseif txt:match("[Bb]oss") or txt:match("Boss Monde") or txt:match("World Boss") then
            fixedByIdx[vi] = 100
        else

            local est = math.max(70, math.ceil(#txt * 9) + 24)
            flexCandidates[vi] = est
        end
    end

    local function computeWidths()
        local fixedSum = 0
        for _, w in pairs(fixedByIdx) do fixedSum = fixedSum + w end
        local remaining = totalWidth - fixedSum - (nCols-1)*colSpacing
        local flexCount = 0
        for _ in pairs(flexCandidates) do flexCount = flexCount + 1 end
        local flexWidth = 100
        if flexCount > 0 then flexWidth = math.max(60, math.floor(remaining / flexCount)) end
        return flexWidth, remaining, flexCount
    end

    local flexWidth, remaining, flexCount = computeWidths()
    for vi, est in pairs(flexCandidates) do
        if est > flexWidth then
            fixedByIdx[vi] = est
            flexCandidates[vi] = nil
        end
    end
    flexWidth, remaining, flexCount = computeWidths()
    flexWidth = math.max(50, math.floor(flexWidth * 0.75))

    local widths = {}
    for vi = 1, nCols do widths[vi] = fixedByIdx[vi] or flexWidth end

    local startX = 10
    local padding = 10
    local sumWidths = 0
    for _, w in ipairs(widths) do sumWidths = sumWidths + w end
    local allowed = math.max(50, totalWidth - startX - padding - (nCols-1)*colSpacing)
        if sumWidths > 0 and sumWidths > allowed then
            local scale = allowed / sumWidths
            for vi = 1, nCols do
                local nw = math.max(40, math.floor(widths[vi] * scale))
                widths[vi] = nw
            end
            sumWidths = 0
            for _, w in ipairs(widths) do sumWidths = sumWidths + w end
        end

    local usedWidth = startX + sumWidths + (nCols - 1) * colSpacing + padding
    local frameAvail = headerFrame:GetWidth() or totalWidth
    local leftover = frameAvail - usedWidth
    if leftover > 2 and nCols >= 2 then
        local half = math.floor(leftover / 2)
        widths[1] = widths[1] + half
        widths[nCols] = widths[nCols] + (leftover - half)
        sumWidths = 0
        for _, w in ipairs(widths) do sumWidths = sumWidths + w end
    end

    local requiredWidth = startX + sumWidths + (nCols - 1) * colSpacing + padding
    content:SetWidth(math.max(content:GetWidth() or 0, requiredWidth, frameAvail))

    for _, v in ipairs({headerFrame:GetChildren()}) do if type(v.Hide) == 'function' then v:Hide() end end
    local hx = 10
    local firstHeaderObj = nil
    for idx, ci in ipairs(visibleCols) do
        local htext = headerTexts[idx]
        local thisWidth = widths[idx] or 80
        local h = headerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        h:SetPoint("TOPLEFT", headerFrame, "TOPLEFT", hx, 0)
        h:SetWidth(thisWidth)
        h:SetHeight(headerHeight)
        h:SetJustifyH("CENTER")
        h:SetWordWrap(true)
        h:SetText(htext)
        h:SetTextColor(1,0.82,0)
        table.insert(rows, h)
        if not firstHeaderObj then firstHeaderObj = h end
        hx = hx + thisWidth + colSpacing
    end

    local defaultRowHeight = 26
    local firstCellObj = nil
    for ri = 1, #dataRows do
        local row = dataRows[ri]
        local x = 10
        local maxContentH = 0
        local cellObjects = {}
        for vi, ci in ipairs(visibleCols) do
            local cell = row[ci] or ""
            if ci == 1 then
                cell = colorizeIlvlNumber(cell)
            else
                cell = colorizePlanningCell(cell)
            end
            local f = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            local thisWidth = widths[vi] or 80
            f:SetWidth(thisWidth)
            f:SetJustifyH("CENTER")
            f:SetWordWrap(true)
            f:SetText(cell)
            f:SetTextColor(1,1,1)
            table.insert(rows, f)
            table.insert(cellObjects, {obj = f, x = x})
            if not firstCellObj then firstCellObj = f end
            local fh = f:GetStringHeight() or 0
            if fh > maxContentH then maxContentH = fh end
            x = x + thisWidth + colSpacing
        end

        local usedHeight = math.max(defaultRowHeight, math.ceil(maxContentH) + 8)

        for _, co in ipairs(cellObjects) do
            local fh = co.obj:GetStringHeight() or 0
            local yOffset = y - math.floor((usedHeight - fh) / 2)
            co.obj:SetPoint("TOPLEFT", content, "TOPLEFT", co.x, yOffset)
        end

        if (ri % 2) == 1 then
            local bg = content:CreateTexture(nil, "BACKGROUND")
            bg:SetColorTexture(0, 0, 0, 0.28)
            bg:SetPoint("TOPLEFT", content, "TOPLEFT", startX, y)
            local totalColsSpacing = math.max(0, (nCols - 1) * colSpacing)
            local availableWidth = 0
            if headerFrame and headerFrame.GetWidth then
                availableWidth = (headerFrame:GetWidth() or 0) - startX - padding
            end
            local targetWidth = math.max(0, sumWidths + totalColsSpacing)
            if availableWidth > 0 then targetWidth = math.max(targetWidth, availableWidth) end
            bg:SetWidth(targetWidth)
            bg:SetHeight(usedHeight)
            table.insert(rows, bg)
        end

        if truncated then
            local more = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            more:SetPoint("TOPLEFT", content, "TOPLEFT", x, y)
            more:SetText("...")
            more:SetTextColor(1,1,1)
            table.insert(rows, more)
        end

        y = y - usedHeight
    end

    content:SetHeight(-y)
    if DEBUG_ALIGN and firstHeaderObj and firstCellObj then
        local hL = firstHeaderObj:GetLeft()
        local cL = firstCellObj:GetLeft()
        local hW = firstHeaderObj:GetWidth()
        local cW = firstCellObj:GetWidth()
        print(string.format("[Midnight debug] HeaderLeft=%.1f CellLeft=%.1f diff=%.1f Hw=%.1f Cw=%.1f", hL or 0, cL or 0, (hL and cL) and (hL - cL) or 0, hW or 0, cW or 0))
    end

    if headerFrame then
        headerFrame:Hide()
        headerFrame:Show()
    end
    if content then
        content:Hide()
        content:Show()
    end
    if scroll and scroll.SetHorizontalScroll then
        scroll:SetHorizontalScroll(0)
    end
end

Planning.Refresh = RefreshPlanning

MidnightPlanningData = planningTable

function Planning.SetData(tbl)
    planningTable = tbl
    planningBuilt = true
end

function Planning.Show()
    ptitle:SetText(MidnightL.S("planning_title"))
    RefreshPlanning()
    pframe:Show()
end

function Planning.Hide()
    pframe:Hide()
end

