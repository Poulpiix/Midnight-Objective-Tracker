local PlanningContenu = {}
_G["MidnightPlanningContenu"] = PlanningContenu

local function getPlanningCSV()
    return MidnightL[MidnightL.GetLocale()].planning_csv
end

local function parseCSV(s)
    local rows = {}
    local i = 1
    local len = #s

    while i <= len do
        while i <= len and (s:sub(i,i) == '\r' or s:sub(i,i) == '\n') do
            i = i + 1
        end
        if i > len then break end

        local row = {}
        local lineEnd = false

        while not lineEnd and i <= len do
            local ch = s:sub(i, i)
            if ch == '"' then
                i = i + 1
                local buf = {}
                while i <= len do
                    local c = s:sub(i, i)
                    if c == '"' then
                        if s:sub(i+1, i+1) == '"' then
                            table.insert(buf, '"'); i = i + 2
                        else
                            i = i + 1; break
                        end
                    else
                        table.insert(buf, c); i = i + 1
                    end
                end
                local field = table.concat(buf):match("^%s*(.-)%s*$") or ""
                table.insert(row, field)
                if s:sub(i, i) == ',' then
                    i = i + 1
                else
                    if s:sub(i, i) == '\r' then i = i + 1 end
                    if s:sub(i, i) == '\n' then i = i + 1 end
                    lineEnd = true
                end
            else
                local buf = {}
                while i <= len do
                    local c = s:sub(i, i)
                    if c == ',' then
                        i = i + 1; break
                    elseif c == '\r' then
                        i = i + 1
                        if s:sub(i, i) == '\n' then i = i + 1 end
                        lineEnd = true; break
                    elseif c == '\n' then
                        i = i + 1; lineEnd = true; break
                    else
                        table.insert(buf, c); i = i + 1
                    end
                end
                if i > len then lineEnd = true end
                local field = table.concat(buf):match("^%s*(.-)%s*$") or ""
                table.insert(row, field)
            end
        end

        if #row > 0 then
            local hasContent = false
            for _, v in ipairs(row) do
                if type(v) == 'string' and v:match('%S') then hasContent = true; break end
            end
            if hasContent then table.insert(rows, row) end
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

local function colorizePlanningCell(text)
    if not text or text == "" then return text end
    text = text:gsub(" +\n", "\n")
    local loc = MidnightL.GetLocale()
    local cSpark = MidnightL.C("spark")
    local cChamp = MidnightL.C("champion")
    local cVet   = MidnightL.C("veteran")
    local cHero  = MidnightL.C("heroic")
    local cMyth  = MidnightL.C("mythic")
    local cAdv   = MidnightL.C("adventurer")

    text = text:gsub("(%d+)", function(numStr)
        local n = tonumber(numStr)
        if not n or n < 207 then return numStr end
        if n >= 272 then return "|cff" .. MidnightL.C("mythic")     .. numStr .. "|r"
        elseif n >= 259 then return "|cff" .. MidnightL.C("heroic")   .. numStr .. "|r"
        elseif n >= 246 then return "|cff" .. MidnightL.C("champion") .. numStr .. "|r"
        elseif n >= 233 then return "|cff" .. MidnightL.C("veteran")  .. numStr .. "|r"
        else return "|cff" .. MidnightL.C("adventurer") .. numStr .. "|r"
        end
    end)

    local cInst = cMyth
    if loc == "en" then
        text = text:gsub("(Dream Rift)",          "|cff" .. cInst .. "%1|r")
        text = text:gsub("(Void Arrow)",           "|cff" .. cInst .. "%1|r")
        text = text:gsub("(March of Quel'Danas)",  "|cff" .. cInst .. "%1|r")
        text = text:gsub("(M%+%d*)",               "|cff" .. cInst .. "%1|r")
        text = text:gsub("(Expeditions?)",          "|cff" .. cInst .. "%1|r")
        text = text:gsub("(World Boss)",            "|cff" .. cInst .. "%1|r")
        text = text:gsub("(Hunts?)",                "|cff" .. cInst .. "%1|r")
        text = text:gsub("(PvP)",                   "|cff" .. cInst .. "%1|r")
        text = text:gsub("(Delves?)",               "|cff" .. cInst .. "%1|r")
        text = text:gsub("(Dungeons?)",             "|cff" .. cInst .. "%1|r")
        text = text:gsub("(Raids?)",                "|cff" .. cInst .. "%1|r")
        text = text:gsub("(%u%l%l %d%d?)",          "|cff" .. cInst .. "%1|r")
    else
        text = text:gsub("(Faille du rêve)",         "|cff" .. cInst .. "%1|r")
        text = text:gsub("(Flèche du vide)",         "|cff" .. cInst .. "%1|r")
        text = text:gsub("(Marche de Quel'Danas)",   "|cff" .. cInst .. "%1|r")
        text = text:gsub("(M%+%d*)",                 "|cff" .. cInst .. "%1|r")
        text = text:gsub("(Expéditions?)",            "|cff" .. cInst .. "%1|r")
        text = text:gsub("(Traques?)",                "|cff" .. cInst .. "%1|r")
        text = text:gsub("(Boss monde)",              "|cff" .. cInst .. "%1|r")
        text = text:gsub("(JcJ)",                     "|cff" .. cInst .. "%1|r")
        text = text:gsub("(Gouffres?)",               "|cff" .. cInst .. "%1|r")
        text = text:gsub("(Donjons?)",                "|cff" .. cInst .. "%1|r")
        text = text:gsub("(Raids?)",                  "|cff" .. cInst .. "%1|r")
        text = text:gsub("(%d%d? janvier)",           "|cff" .. cInst .. "%1|r")
        text = text:gsub("(%d%d? f\195\169vrier)",    "|cff" .. cInst .. "%1|r")
        text = text:gsub("(%d%d? mars)",               "|cff" .. cInst .. "%1|r")
        text = text:gsub("(%d%d? avril)",              "|cff" .. cInst .. "%1|r")
        text = text:gsub("(%d%d? mai)",                "|cff" .. cInst .. "%1|r")
        text = text:gsub("(%d%d? juin)",               "|cff" .. cInst .. "%1|r")
        text = text:gsub("(%d%d? juillet)",            "|cff" .. cInst .. "%1|r")
        text = text:gsub("(%d%d? ao\195\187t)",        "|cff" .. cInst .. "%1|r")
        text = text:gsub("(%d%d? septembre)",          "|cff" .. cInst .. "%1|r")
        text = text:gsub("(%d%d? octobre)",            "|cff" .. cInst .. "%1|r")
        text = text:gsub("(%d%d? novembre)",           "|cff" .. cInst .. "%1|r")
        text = text:gsub("(%d%d? d\195\169cembre)",    "|cff" .. cInst .. "%1|r")
    end

    return text
end

local PAD_L  = 15
local PAD_R  = 15
local PAD_T  = 36
local PAD_B  = 15

local pframe = CreateFrame("Frame", "MidnightPlanningContenuFrame", UIParent, "BackdropTemplate")
pframe:SetSize(300, 100)
pframe:SetPoint("CENTER")
pframe:SetBackdrop({
    bgFile   = "Interface/DialogFrame/UI-DialogBox-Background",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets   = { left = 8, right = 8, top = 8, bottom = 8 },
})
pframe:SetBackdropColor(0, 0, 0, 0.95)
pframe:SetBackdropBorderColor(1, 0.82, 0, 1)
pframe:SetMovable(true)
pframe:EnableMouse(true)
pframe:RegisterForDrag("LeftButton")
pframe:SetScript("OnDragStart", pframe.StartMoving)
pframe:SetScript("OnDragStop",  pframe.StopMovingOrSizing)
pframe:Hide()
table.insert(UISpecialFrames, "MidnightPlanningContenuFrame")

local ptitle = pframe:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
ptitle:SetPoint("TOP", pframe, "TOP", 0, -15)
ptitle:SetText(MidnightL.S("planning_title"))

local pclose = CreateFrame("Button", nil, pframe, "UIPanelButtonTemplate")
pclose:SetSize(20, 20)
pclose:SetPoint("TOPRIGHT", pframe, "TOPRIGHT", -10, -10)
pclose:SetText("X")
pclose:SetNormalFontObject("GameFontNormalSmall")
pclose:SetHighlightFontObject("GameFontNormalSmall")
local pcloseBtnFs = pclose:GetFontString()
if pcloseBtnFs then
    pcloseBtnFs:ClearAllPoints()
    pcloseBtnFs:SetPoint("CENTER", 0, 0)
    pcloseBtnFs:SetJustifyH("CENTER")
    pcloseBtnFs:SetJustifyV("MIDDLE")
end
pclose:SetScript("OnClick", function()
    pframe:Hide()
end)
pclose:SetFrameLevel(pframe:GetFrameLevel() + 5)

local content = CreateFrame("Frame", nil, pframe)
content:SetPoint("TOPLEFT", pframe, "TOPLEFT", PAD_L, -PAD_T)
content:SetSize(100, 100)

local rows = {}

local function RefreshPlanningContenu()
    for _, r in ipairs(rows) do r:Hide() end
    rows = {}

    planningBuilt = false
    ensurePlanningBuilt()
    local headers  = planningTable.headers or {}
    local dataRows = planningTable.rows    or {}

    if #dataRows == 0 then
        local placeholder = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        placeholder:SetPoint("TOPLEFT", content, "TOPLEFT", 0, 0)
        placeholder:SetText(MidnightL.S("no_csv_data"))
        placeholder:SetTextColor(1, 0.7, 0)
        table.insert(rows, placeholder)
        pframe:SetSize(300, 80)
        return
    end

    local nCols = #headers
    local colSpacing = 5

    local function measureTxt(txt)
        local maxLen = 0
        for line in ((txt or "") .. "\n"):gmatch("([^\n]*)\n") do
            if #line > maxLen then maxLen = #line end
        end
        return maxLen * 7 + 12
    end

    local widths = {}
    for ci = 1, nCols do
        local w = math.max(ci == 1 and 80 or 70, measureTxt(headers[ci] or ""))
        for _, r in ipairs(dataRows) do
            local cw = measureTxt(r[ci] or "")
            if cw > w then w = cw end
        end
        widths[ci] = math.min(w, ci == 1 and 120 or 200)
    end

    local totalTableW = 0
    for _, w in ipairs(widths) do totalTableW = totalTableW + w end
    totalTableW = totalTableW + (nCols - 1) * colSpacing

    local y = 0

    local headerH = 20

    local headerBg = content:CreateTexture(nil, "BACKGROUND")
    headerBg:SetColorTexture(1, 0.78, 0, 0.18)
    headerBg:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
    headerBg:SetSize(totalTableW, headerH)
    table.insert(rows, headerBg)

    local hx = 0
    for ci = 1, nCols do
        local h = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        h:SetPoint("TOPLEFT", content, "TOPLEFT", hx, y)
        h:SetWidth(widths[ci])
        h:SetHeight(headerH)
        h:SetJustifyH(ci == 1 and "LEFT" or "CENTER")
        h:SetJustifyV("MIDDLE")
        h:SetText(headers[ci] or "")
        h:SetTextColor(1, 0.92, 0.3)
        table.insert(rows, h)
        hx = hx + widths[ci] + colSpacing
    end
    y = y - headerH

    local defaultRowH = 16
    for ri, row in ipairs(dataRows) do
        local rx = 0
        local maxH = 0
        local cellObjs = {}

        for ci = 1, nCols do
            local cell = row[ci] or ""
            local displayText = (ci == 1) and cell or colorizePlanningCell(cell)

            local f = content:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            f:SetWidth(widths[ci])
            f:SetJustifyH(ci == 1 and "LEFT" or "CENTER")
            f:SetWordWrap(true)
            f:SetText(displayText)
            if ci == 1 then
                f:SetTextColor(1, 0.92, 0.3)
            else
                f:SetTextColor(1, 1, 1)
            end
            table.insert(rows, f)
            table.insert(cellObjs, { obj = f, x = rx })

            local fh = f:GetStringHeight() or 0
            if fh > maxH then maxH = fh end
            rx = rx + widths[ci] + colSpacing
        end

        local usedH = math.max(defaultRowH, math.ceil(maxH) + 6)

        for _, co in ipairs(cellObjs) do
            co.obj:SetPoint("TOPLEFT", content, "TOPLEFT", co.x, y)
            co.obj:SetHeight(usedH)
            co.obj:SetJustifyV("MIDDLE")
        end

        if (ri % 2) == 1 then
            local bg = content:CreateTexture(nil, "BACKGROUND")
            bg:SetColorTexture(0, 0, 0, 0.3)
            bg:SetPoint("TOPLEFT", content, "TOPLEFT", 0, y)
            bg:SetSize(totalTableW, usedH)
            table.insert(rows, bg)
        end

        y = y - usedH
    end

    local contentH = -y
    content:SetSize(totalTableW, contentH)

    local frameW = totalTableW + PAD_L + PAD_R
    local frameH = PAD_T + contentH + PAD_B
    pframe:SetSize(math.max(200, frameW), math.max(80, frameH))

    content:ClearAllPoints()
    content:SetPoint("TOP", pframe, "TOP", 0, -PAD_T)

    content:Hide(); content:Show()
end

function PlanningContenu.Show()
    ptitle:SetText(MidnightL.S("planning_title"))
    RefreshPlanningContenu()
    pframe:Show()
    C_Timer.After(0, RefreshPlanningContenu)
end

function PlanningContenu.Hide()
    pframe:Hide()
end
