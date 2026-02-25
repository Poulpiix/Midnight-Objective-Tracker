local Planning = {}
_G["MidnightPlanning"] = Planning

local csv_data = [[
,Quêtes,Expédition,"Boss Monde",Artisanat,"Traque", Traque Vault,Arène & BG,Gouffre Abondant,Gouffre Prime,Gouffre Vault,Donjon,Donjon Vault,Raid & Vault
207,(3 mars),,,,,,,,,,,,
210,,,,,,,,,,,,,
214,,,,,,,,,,,"Normal
(3 mars)",,
217,,,,,,,"Honneur (276)
(18 mars)",,,,,,
220,,(3 mars),,"Écu d'aventure 
(Qualité 1)","Normal
(3 mars)",,,"Palier 1
(18 mars)",,,,,
224,,,,"Écu d'aventure 
(Qualité 2)",,,,Palier 2,,,"Héroique (hors saison)
(3 mars)",,
227,,,,"Écu d'aventure 
(Qualité 3)",,,,Palier 3,,,,,
230,,,,"Écu d'aventure 
(Qualité 4)",,,,Palier 4,,,"Héroique (Pre Saison)
(18 mars)",,
233,,,,"Écu d'aventure 
(Qualité 5)",,,,,,,,,
237,,,,,,,,,,,,,
233,,,,"Écu vétéran 
(Qualité 1)","Difficile
(18 mars)","Normal
(3 mars)",,Palier 5,,,,,"LFR
Aile 1 (18 mars)
Aile 2 (25 mars)
Aile 3 (01 avril)"
237,,,,"Écu vétéran 
(Qualité 2)",,,,Palier 6,"Palier 4
(18 mars)",,,,
240,,,,"Écu vétéran 
(Qualité 3)",,,,,,,"Mythique 0 (Pre Saison)
(18 mars)",,
243,,,,"Écu vétéran 
(Qualité 4)",,,,,Palier 5,,,"Héroique (hors saison)
(3 mars)",
246,,,,"Écu vétéran 
(Qualité 5)",,,"Mode guerre (276)
(18 mars)",,,,,,
250,,,,,,,,,,,,,
246,,,,"Étincelle
(Qualité 1)","Cauchemar
(18 mars)","Difficile
(18 mars)","Conquête (289)
(18 mars)",Palier 7,Palier 6, Palier 5,"Mythique (saison 1)
(25 mars)",,"Normal
(18 mars)"
249,,,,"Étincelle
(Qualité 2)",,,,,,,,,,
250,,,(18 mars),,,,,Palier 8 - 11,Palier 7,,Mythique + (+2-3),,
252,,,,"Étincelle
(Qualité 3)",,,,,,,,,,
253,,,,,,,,,,Palier  6,Mythique + (+4),,
255,,,,"Étincelle
(Qualité 4)",,,,,,,,,,
256,,,,,,,,,,Palier 7,Mythique + (+5),"Mythique 0 (Pre Saison)
(18 mars)",
259,,,,"Étincelle
(Qualité 5",,,,,,,,,,
263,,,,,,,,,,,,
259,,,,"Étincelle + Écu Héroique
(Qualité 1)",,"Cauchemar
(18 mars)",,,Palier 8 - 11,Palier 8 - 11,Mythique + (+6-7),"Mythique + (+2-3)
(25 mars)","Héroique
(18 mars)"
262,,,,"Étincelle + Écu Héroique
(Qualité 2)",,,,,,,,,,
263,,,,,,,,,,,Mythique + (+8-9),Mythique + (+4-5),
265,,,,"Étincelle + Écu Héroique
(Qualité 3)",,,,,,,,,,
266,,,,,,,,,,,Mythique + (+10 et +),Mythique + (+6),
268,,,,"Étincelle + Écu Héroique
(Qualité 4)",,,,,,,,,,
269,,,,,,,,,,,,Mythique + (+7-9),
272,,,,"Étincelle + Écu Héroique
(Qualité 5)",,,,,,,,,,
276,,,,,,,,,,,,,
272,,,,"Étincelle + Écu Mythique
(Qualité 1)",,,,,,,,Mythique + (+10 et +),"Mythique
Raid 1 & 2 (25 mars)
Raid 3 (01 avril)"
275,,,,"Étincelle + Écu Mythique
(Qualité 2)",,,,,,,,,,
276,,,,,,,,,,,,,
278,,,,"Étincelle + Écu Mythique
(Qualité 3)",,,,,,,,,,
279,,,,,,,,,,,,,
282,,,,"Étincelle + Écu Mythique
(Qualité 4)",,,,,,,,,,
282,,,,,,,,,,,,,
285,,,,"Étincelle + Écu Mythique
(Qualité 5)",,,,,,,,,,
289,,,,,,,,,,,,,
]]

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

-- highlightPrefix removed: was referencing undefined colorizeText in this scope

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
    if h:match("^[Qq]u[eè]t") or h:match("^Quêtes") then return true end
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
    local ok, res = pcall(buildPlanningTableFromCSV, csv_data)
    if not ok then
        print("[Midnight] Erreur lors du parsing du CSV Planning : " .. tostring(res))
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
ptitle:SetText("Planning")

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

local function RefreshPlanning()
    for _, r in ipairs(rows) do r:Hide() end
    rows = {}
    local y = -6
    ensurePlanningBuilt()
    local headers = planningTable.headers or {}
    local dataRows = planningTable.rows or {}

    if #dataRows == 0 then
        local placeholder = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        placeholder:SetPoint("TOPLEFT", 10, y)
        placeholder:SetJustifyH("LEFT")
        placeholder:SetText("Aucune donnée importée depuis le CSV.")
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
            if rawh:match("[Qq]u[eè]te") then
                htext = "Expédition"
            else
                htext = rawh
            end
        end
        headerTexts[vi] = htext
    end

    local fixedByIdx = {}
    local flexCandidates = {}
    for vi, txt in ipairs(headerTexts) do
        if txt:match("Chambre forte") then
            fixedByIdx[vi] = 80
        elseif txt:match("Gouffre Abondant") then
            fixedByIdx[vi] = 70
        elseif txt:match("Gouffre Primes") or txt:match("Gouffre Prime") then
            fixedByIdx[vi] = 72
        elseif txt:match("Traque") then
            fixedByIdx[vi] = 90
        elseif txt:match("[Qq]u[eè]te") or txt:match("Expédition") then
            fixedByIdx[vi] = 110
        elseif txt:match("[Bb]oss") or txt:match("Boss Monde") then
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

    -- Distribute leftover space equally to first and last columns
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
    RefreshPlanning()
    pframe:Show()
end

function Planning.Hide()
    pframe:Hide()
end

