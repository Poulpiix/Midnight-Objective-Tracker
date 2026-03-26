---@diagnostic disable: deprecated
local function getCrestInfo(currencyID)
    if currencyID and currencyID > 0 and C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo then
        local info = C_CurrencyInfo.GetCurrencyInfo(currencyID)
        if info then
            return info.quantity or 0,
                   info.maxQuantity or 0,
                   info.totalEarned or 0
        end
    end
    return 0, 0, 0
end

local crestPanel = CreateFrame("Frame", "MidnightCrestPanel", MidnightTrackerFrame, "BackdropTemplate")
crestPanel:SetHeight(46)
crestPanel:SetPoint("TOPLEFT", MidnightTrackerFrame, "BOTTOMLEFT", 0, 6)
crestPanel:SetPoint("TOPRIGHT", MidnightTrackerFrame, "BOTTOMRIGHT", 0, 6)
crestPanel:SetBackdrop({
    bgFile = "Interface/Buttons/WHITE8X8",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets = { left = 8, right = 8, top = 8, bottom = 8 },
})
crestPanel:SetBackdropColor(0, 0, 0, 1)
crestPanel:SetBackdropBorderColor(1, 0.82, 0, 1)
if MidnightTracker then
    if MidnightTracker.RegisterBorderedFrame then MidnightTracker.RegisterBorderedFrame(crestPanel) end
    if MidnightTracker.RegisterWindowBgFrame then MidnightTracker.RegisterWindowBgFrame(crestPanel) end
end

local currencyRows = {
    { key = "adventurer", color = "7FB8FF", currID = 3383, icon = "Interface\\Icons\\inv_120_crest_adventurer" },
    { key = "veteran",    color = "C0A0FF", currID = 3341, icon = "Interface\\Icons\\inv_120_crest_veteran" },
    { key = "champion",   color = "ff3b3b", currID = 3343, icon = "Interface\\Icons\\inv_120_crest_champion" },
    { key = "heroic",     color = "FFB86A", currID = 3345, icon = "Interface\\Icons\\inv_120_crest_hero" },
    { key = "mythic",     color = "FFE07A", currID = 3347, icon = "Interface\\Icons\\inv_120_crest_myth" },
    { key = "sparks",     color = "FFD100", itemID = 232875, icon = "Interface\\Icons\\inv_12_profession_questandcrafting_sparkwhole_gold" },
    { key = "dust",       color = "AACCFF", currID = 3212 },
}

local crestLineRows = {}
local crestContent = CreateFrame("Frame", nil, crestPanel)
crestContent:SetPoint("TOPLEFT", 10, 0)
crestContent:SetPoint("BOTTOMRIGHT", -10, 0)

for i, cr in ipairs(currencyRows) do
    local btn = CreateFrame("Button", nil, crestContent)
    btn:SetSize(18, 18)
    btn:EnableMouse(true)
    local tex = btn:CreateTexture(nil, "ARTWORK")
    tex:SetAllPoints()
    if cr.icon then
        tex:SetTexture(cr.icon)
    end

    local fsHeld = crestContent:CreateFontString(nil, "OVERLAY", "GameFontNormalTiny")
    fsHeld:SetJustifyH("CENTER")
    fsHeld:SetWordWrap(false)

    local fsWeekly = crestContent:CreateFontString(nil, "OVERLAY", "GameFontNormalTiny")
    fsWeekly:SetJustifyH("CENTER")
    fsWeekly:SetWordWrap(false)

    crestLineRows[cr.key] = {
        fsHeld   = fsHeld,
        fsWeekly = fsWeekly,
        btn      = btn,
        tex      = tex,
        currID   = cr.currID,
        itemID   = cr.itemID,
        color    = cr.color,
        icon     = cr.icon,
        idx      = i,
    }

    btn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:ClearLines()
        if cr.currID and cr.currID > 0 and GameTooltip.SetCurrencyByID then
            GameTooltip:SetCurrencyByID(cr.currID)
        elseif cr.itemID then
            GameTooltip:SetHyperlink("item:" .. cr.itemID)
        else
            GameTooltip:AddLine(cr.key, 1, 0.82, 0)
        end
        GameTooltip:Show()
    end)
    btn:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

local function UpdateCrestPanel()
    local nItems = #currencyRows
    local totalW = crestContent:GetWidth() or (MidnightTrackerFrame:GetWidth() - 20)
    local iconSize  = 18
    local iconGap   = 2
    local textW     = 44
    local groupW    = iconSize + iconGap + textW
    local spacing   = math.max(2, math.floor((totalW - nItems * groupW) / (nItems + 1)))
    local startX    = spacing

    for i, cr in ipairs(currencyRows) do
        local entry = crestLineRows[cr.key]
        if entry then
            if entry.tex and not entry.icon and cr.currID and cr.currID > 0 then
                local info = C_CurrencyInfo and C_CurrencyInfo.GetCurrencyInfo and C_CurrencyInfo.GetCurrencyInfo(cr.currID)
                if info and info.iconFileID and info.iconFileID > 0 then
                    entry.tex:SetTexture(info.iconFileID)
                    entry.icon = true
                end
            end

            local heldStr, weeklyStr, weekColor

            if entry.itemID then
                local cur = GetItemCount and GetItemCount(entry.itemID, true) or 0
                heldStr   = "|cffffffff" .. tostring(cur) .. "|r"
                weeklyStr = ""
            else
                local cur, weeklyMax, totalEarned = getCrestInfo(entry.currID)
                heldStr = "|cffffffff" .. tostring(cur) .. "|r"
                if weeklyMax and weeklyMax > 0 then
                    if totalEarned >= weeklyMax then
                        weekColor = "ff40ff40"
                    elseif totalEarned > 0 then
                        weekColor = "ffffd34d"
                    else
                        weekColor = "ffff4040"
                    end
                    weeklyStr = "|c" .. weekColor .. totalEarned .. "/" .. weeklyMax .. "|r"
                else
                    weeklyStr = "|cffaaaaaa" .. totalEarned .. "/TBA|r"
                end
            end

            local x = startX + (i - 1) * (groupW + spacing)

            entry.btn:ClearAllPoints()
            entry.btn:SetPoint("LEFT", crestContent, "LEFT", x, 0)
            entry.btn:SetSize(iconSize, iconSize)
            entry.btn:Show()

            local txtX = x + iconSize + iconGap

            entry.fsHeld:ClearAllPoints()
            entry.fsHeld:SetWidth(textW)
            if weeklyStr == "" then
                entry.fsHeld:SetPoint("LEFT", crestContent, "LEFT", txtX, 0)
            else
                entry.fsHeld:SetPoint("BOTTOMLEFT", crestContent, "LEFT", txtX, 1)
            end
            entry.fsHeld:SetText(heldStr)

            entry.fsWeekly:ClearAllPoints()
            entry.fsWeekly:SetWidth(textW)
            entry.fsWeekly:SetPoint("TOPLEFT", crestContent, "LEFT", txtX, -1)
            entry.fsWeekly:SetText(weeklyStr)
        end
    end
end

if MidnightTracker then
    MidnightTracker.UpdateCrestPanel = UpdateCrestPanel
end

MidnightTrackerFrame:HookScript("OnShow", function()
    local wbc = MidnightObjectiveTrackerDB and MidnightObjectiveTrackerDB.windowBgColor
                or { r = 0, g = 0, b = 0 }
    crestPanel:SetBackdropColor(wbc.r, wbc.g, wbc.b, 1)
    if MidnightObjectiveTrackerDB.showCrestPanel ~= false then
        crestPanel:Show()
    else
        crestPanel:Hide()
    end
end)

C_Timer.After(0, function()
    local wbc = MidnightObjectiveTrackerDB and MidnightObjectiveTrackerDB.windowBgColor
                or { r = 0, g = 0, b = 0 }
    crestPanel:SetBackdropColor(wbc.r, wbc.g, wbc.b, 1)
    if MidnightObjectiveTrackerDB.showCrestPanel == false then
        crestPanel:Hide()
    end
end)
