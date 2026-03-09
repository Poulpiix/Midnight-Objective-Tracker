local GV_TYPE_MPLUS = (Enum and Enum.WeeklyRewardChestActivityType and Enum.WeeklyRewardChestActivityType.MythicPlus) or 1
local GV_TYPE_WORLD = (Enum and Enum.WeeklyRewardChestActivityType and Enum.WeeklyRewardChestActivityType.World)     or 2
local GV_TYPE_RAID  = (Enum and Enum.WeeklyRewardChestActivityType and Enum.WeeklyRewardChestActivityType.Raid)      or 3

local GV_THRESHOLDS = { { 2, 4, 6 }, { 1, 4, 8 }, { 2, 4, 8 } }
local GV_ROW_TYPES  = { GV_TYPE_RAID, GV_TYPE_MPLUS, GV_TYPE_WORLD }
local GV_ROW_KEYS   = { "vault_raid", "vault_dungeon", "vault_world" }

local PANEL_W      = 110
local PAD_L        = 10
local PAD_R        = 10
local PAD_T        = 16
local PAD_B        = 8
local TITLE_H      = 14
local SEP_OFFSET   = PAD_T + TITLE_H + 3
local GRID_TOP_Y   = -(SEP_OFFSET + 1 + 4)
local LABEL_W      = 32
local LABEL_GAP    = 4
local CELL_W       = 17
local CELL_GAP     = 1
local ROW_H        = 18
local ROW_GAP      = 3
local PANEL_H      = math.abs(GRID_TOP_Y) + 3 * ROW_H + 2 * ROW_GAP + PAD_B

local function getAccent()
    if MidnightTracker and MidnightTracker.GetAccentColor then
        return MidnightTracker.GetAccentColor()
    end
    return 1, 0.82, 0
end

local VAULT_DEFAULTS = {
    vault_title     = "Chambre Forte",
    vault_raid      = "Raid",
    vault_dungeon   = "Donjon",
    vault_world     = "Monde",
    vault_slot      = "Empl.",
    vault_na        = "N/A",
    vault_threshold = "Seuil",
    vault_unlocked  = "Déverrouillé !",
    vault_progress  = "Progression",
}

local function VS(key)
    if MidnightL and MidnightL.S then
        local v = MidnightL.S(key)
        if v and v ~= key then return v end
    end
    return VAULT_DEFAULTS[key] or key
end

local vaultPanel = CreateFrame("Frame", "MidnightVaultPanel", MidnightTrackerFrame, "BackdropTemplate")
vaultPanel:SetSize(PANEL_W, PANEL_H)
vaultPanel:SetPoint("TOPLEFT", MidnightSummaryMenu, "BOTTOMLEFT", 0, 6)
vaultPanel:SetBackdrop({
    bgFile   = "Interface/Buttons/WHITE8X8",
    edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
    edgeSize = 16,
    insets   = { left = 8, right = 8, top = 8, bottom = 8 },
})
vaultPanel:SetBackdropColor(0, 0, 0, 1)
vaultPanel:SetBackdropBorderColor(1, 0.82, 0, 1)

if MidnightTracker then
    if MidnightTracker.RegisterBorderedFrame  then MidnightTracker.RegisterBorderedFrame(vaultPanel)  end
    if MidnightTracker.RegisterWindowBgFrame  then MidnightTracker.RegisterWindowBgFrame(vaultPanel)  end
end

local vaultTitle = vaultPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
vaultTitle:SetPoint("TOP", vaultPanel, "TOP", 0, -PAD_T)
vaultTitle:SetWidth(PANEL_W - 20)
vaultTitle:SetJustifyH("CENTER")
do local ar, ag, ab = getAccent(); vaultTitle:SetTextColor(ar, ag, ab) end

if MidnightTracker and MidnightTracker.RegisterTitleFontString then
    MidnightTracker.RegisterTitleFontString(vaultTitle)
end

local vaultSep = vaultPanel:CreateTexture(nil, "ARTWORK")
do local ar, ag, ab = getAccent(); vaultSep:SetColorTexture(ar, ag, ab, 0.50) end
vaultSep:SetHeight(1)
vaultSep:SetPoint("TOPLEFT",  vaultPanel, "TOPLEFT",  PAD_L,  -SEP_OFFSET)
vaultSep:SetPoint("TOPRIGHT", vaultPanel, "TOPRIGHT", -PAD_R, -SEP_OFFSET)

if MidnightTracker and MidnightTracker.RegisterAccentColorCallback then
    MidnightTracker.RegisterAccentColorCallback(function(r, g, b)
        vaultSep:SetColorTexture(r, g, b, 0.50)
    end)
end

local cellInfo  = {}
local rowLabels = {}
local progCache = {}

for r = 1, 3 do
    local rowY = GRID_TOP_Y - (r - 1) * (ROW_H + ROW_GAP)

    local lbl = vaultPanel:CreateFontString(nil, "OVERLAY", "GameFontNormalTiny")
    lbl:SetSize(LABEL_W, ROW_H)
    lbl:SetPoint("TOPLEFT", vaultPanel, "TOPLEFT", PAD_L, rowY)
    lbl:SetJustifyH("LEFT")
    lbl:SetJustifyV("MIDDLE")
    lbl:SetWordWrap(false)
    lbl:SetTextColor(0.85, 0.85, 0.85)
    rowLabels[r] = lbl

    cellInfo[r]  = {}
    progCache[r] = { done = 0, progress = 0, total = 0 }

    for c = 1, 3 do
        local cellX = PAD_L + LABEL_W + LABEL_GAP + (c - 1) * (CELL_W + CELL_GAP)

        local btn = CreateFrame("Button", nil, vaultPanel)
        btn:SetSize(CELL_W, ROW_H - 2)
        btn:SetPoint("TOPLEFT", vaultPanel, "TOPLEFT", cellX, rowY - 1)
        btn:EnableMouse(true)
        btn:SetFrameLevel(vaultPanel:GetFrameLevel() + 2)

        local bg = btn:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints()
        bg:SetColorTexture(0.10, 0.10, 0.10, 0.90)

        local numFS = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalTiny")
        numFS:SetAllPoints()
        numFS:SetJustifyH("CENTER")
        numFS:SetJustifyV("MIDDLE")
        numFS:SetText(tostring(GV_THRESHOLDS[r][c]))
        numFS:SetTextColor(0.45, 0.45, 0.45)

        local captureR, captureC = r, c
        btn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_TOP")
            GameTooltip:ClearLines()
            local thresh = GV_THRESHOLDS[captureR][captureC]
            local pc     = progCache[captureR]
            local prog   = pc and pc.progress or 0
            local total  = pc and pc.total    or 0
            GameTooltip:AddLine(VS(GV_ROW_KEYS[captureR]) .. " — " .. VS("vault_slot") .. " " .. captureC, 1, 0.82, 0)
            if total == 0 then
                GameTooltip:AddLine(VS("vault_na"), 0.6, 0.6, 0.6)
            else
                GameTooltip:AddLine(VS("vault_threshold") .. ": " .. thresh, 1, 1, 1)
                if prog >= thresh then
                    GameTooltip:AddLine(VS("vault_unlocked"), 0.40, 1.00, 0.40)
                else
                    GameTooltip:AddLine(VS("vault_progress") .. ": " .. prog .. "/" .. thresh, 1.00, 0.75, 0.20)
                end
            end
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

        cellInfo[r][c] = { bg = bg, numFS = numFS }
    end
end

local function RefreshVault()
    local activities = C_WeeklyRewards
                   and C_WeeklyRewards.GetActivities
                   and C_WeeklyRewards.GetActivities()

    local typeCount = {
        [GV_TYPE_RAID]  = { done = 0, progress = 0, total = 0 },
        [GV_TYPE_MPLUS] = { done = 0, progress = 0, total = 0 },
        [GV_TYPE_WORLD] = { done = 0, progress = 0, total = 0 },
    }

    if type(activities) == "table" then
        for _, act in ipairs(activities) do
            local t = act and act.type
            local d = t and typeCount[t]
            if d then
                d.total = d.total + 1
                local prog   = type(act.progress)  == "number" and act.progress  or 0
                local thresh = type(act.threshold) == "number" and act.threshold or 0
                local done   = (act.isComplete == true) or (thresh > 0 and prog >= thresh)
                if done then d.done = d.done + 1 end
                if prog > d.progress then d.progress = prog end
            end
        end
    end

    for r = 1, 3 do
        local d = typeCount[GV_ROW_TYPES[r]]
        progCache[r].done     = d.done
        progCache[r].progress = d.progress
        progCache[r].total    = d.total

        for c = 1, 3 do
            local ci     = cellInfo[r][c]
            local thresh = GV_THRESHOLDS[r][c]

            if d.total == 0 then
                ci.bg:SetColorTexture(0.08, 0.08, 0.08, 0.80)
                ci.numFS:SetText(tostring(thresh))
                ci.numFS:SetTextColor(0.35, 0.35, 0.35)
            elseif d.progress >= thresh then
                ci.bg:SetColorTexture(0.08, 0.30, 0.08, 0.90)
                ci.numFS:SetText(tostring(thresh))
                ci.numFS:SetTextColor(0.40, 1.00, 0.40)
            elseif d.progress > 0 then
                ci.bg:SetColorTexture(0.30, 0.24, 0.04, 0.90)
                ci.numFS:SetText(tostring(thresh))
                ci.numFS:SetTextColor(1.00, 0.78, 0.20)
            else
                ci.bg:SetColorTexture(0.28, 0.06, 0.06, 0.90)
                ci.numFS:SetText(tostring(thresh))
                ci.numFS:SetTextColor(1.00, 0.30, 0.30)
            end
        end
    end
end

local function UpdateVaultTexts()
    vaultTitle:SetText(VS("vault_title"))
    for r = 1, 3 do
        rowLabels[r]:SetText(VS(GV_ROW_KEYS[r]))
    end
end

local vaultTimer = 0
vaultPanel:SetScript("OnUpdate", function(self, elapsed)
    vaultTimer = vaultTimer + (elapsed or 0)
    if vaultTimer < 3 then return end
    vaultTimer = 0
    RefreshVault()
end)

vaultPanel:HookScript("OnShow", function()
    local wbc = MidnightObjectiveTrackerDB and MidnightObjectiveTrackerDB.windowBgColor
                or { r = 0, g = 0, b = 0 }
    vaultPanel:SetBackdropColor(wbc.r, wbc.g, wbc.b, 1)
    UpdateVaultTexts()
    RefreshVault()
end)

C_Timer.After(0, function()
    UpdateVaultTexts()
    local wbc = MidnightObjectiveTrackerDB and MidnightObjectiveTrackerDB.windowBgColor
                or { r = 0, g = 0, b = 0 }
    vaultPanel:SetBackdropColor(wbc.r, wbc.g, wbc.b, 1)
    RefreshVault()
    if MidnightObjectiveTrackerDB.showVaultPanel == false then
        vaultPanel:Hide()
    end
end)

MidnightTrackerFrame:HookScript("OnShow", function()
    if MidnightObjectiveTrackerDB.showVaultPanel ~= false then
        vaultPanel:Show()
    else
        vaultPanel:Hide()
    end
end)
