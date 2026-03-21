local function GetThresholdType(key, fallback)
    local enum = Enum and Enum.WeeklyRewardChestThresholdType
    if enum and enum[key] then
        return enum[key]
    end
    return fallback
end

local GV_TYPE_MPLUS = GetThresholdType("Activities", 1)
local GV_TYPE_RAID  = GetThresholdType("Raid", 3)
local GV_TYPE_WORLD = GetThresholdType("World", 6)

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
    vault_ilvl      = "iLvl",
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

local cellInfo      = {}
local rowLabels     = {}
local progCache     = {}
local rewardLevels  = { {}, {}, {} }

local function ClearRewardLevels()
    for r = 1, 3 do
        rewardLevels[r] = rewardLevels[r] or {}
        for c = 1, 3 do
            rewardLevels[r][c] = nil
        end
    end
end

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
            local lvl = rewardLevels[captureR] and rewardLevels[captureR][captureC]
            if lvl then
                GameTooltip:AddLine(VS("vault_ilvl") .. ": " .. lvl, 0.80, 0.80, 1.00)
            end
            GameTooltip:Show()
        end)
        btn:SetScript("OnLeave", function() GameTooltip:Hide() end)

        cellInfo[r][c] = { bg = bg, numFS = numFS }
    end
end

local function NewRowState()
    return { done = 0, progress = 0, total = 0 }
end

local function InitRowStates()
    local states = {}
    for r = 1, 3 do
        states[r] = NewRowState()
    end
    return states
end

local function PopulateFromSorted(rowIndex, state)
    if not (C_WeeklyRewards and C_WeeklyRewards.GetSortedProgressForActivity) then
        return false
    end

    local typeId = GV_ROW_TYPES[rowIndex]
    local sorted = C_WeeklyRewards.GetSortedProgressForActivity(typeId, true)
    if type(sorted) ~= "table" or #sorted == 0 then
        return false
    end

    state.total = #sorted
    for tierIndex, tierInfo in ipairs(sorted) do
        local points = type(tierInfo.numPoints) == "number" and tierInfo.numPoints or 0
        if points > state.progress then
            state.progress = points
        end
        local threshold = GV_THRESHOLDS[rowIndex][tierIndex]
        if threshold and points >= threshold then
            state.done = state.done + 1
        end
    end
    return true
end

local function PopulateFromActivities(rowType, state, activities)
    if type(activities) ~= "table" then
        return false
    end

    local hadData = false
    for _, act in ipairs(activities) do
        if act and act.type == rowType then
            hadData = true
            state.total = state.total + 1
            local prog   = type(act.progress)  == "number" and act.progress  or 0
            local thresh = type(act.threshold) == "number" and act.threshold or 0
            local done   = (act.isComplete == true) or (thresh > 0 and prog >= thresh)
            if done then state.done = state.done + 1 end
            if prog > state.progress then state.progress = prog end
        end
    end
    return hadData
end

local function PopulateRewardLevels(activities)
    if type(activities) ~= "table" then return end

    local typeToRow = {
        [GV_TYPE_RAID]  = 1,
        [GV_TYPE_MPLUS] = 2,
        [GV_TYPE_WORLD] = 3,
    }

    for _, act in ipairs(activities) do
        local rowIndex = act and act.type and typeToRow[act.type]
        local colIndex = act and act.index
        local level    = act and act.level
        if rowIndex and type(colIndex) == "number" and colIndex >= 1 and colIndex <= 3 and type(level) == "number" then
            rewardLevels[rowIndex][colIndex] = level
        end
    end
end

local function RefreshVault()
    local rowStates = InitRowStates()
    local activities = C_WeeklyRewards
                   and C_WeeklyRewards.GetActivities
                   and C_WeeklyRewards.GetActivities()

    ClearRewardLevels()
    PopulateRewardLevels(activities)

    for r = 1, 3 do
        local filled = PopulateFromSorted(r, rowStates[r])
        if not filled then
            PopulateFromActivities(GV_ROW_TYPES[r], rowStates[r], activities)
        end
    end

    for r = 1, 3 do
        local d = rowStates[r]
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

local function EnumKeyForValue(enumTable, value)
    if not enumTable or value == nil then return nil end
    for name, enumValue in pairs(enumTable) do
        if enumValue == value then
            return name
        end
    end
end

local function VaultDebugMessage(msg)
    local prefix = "|cff44ff88MOT Vault|r "
    if DEFAULT_CHAT_FRAME then
        DEFAULT_CHAT_FRAME:AddMessage(prefix .. msg)
    else
        print("[MOT Vault] " .. msg)
    end
end

local function DumpVaultActivities()
    local activities = C_WeeklyRewards
                   and C_WeeklyRewards.GetActivities
                   and C_WeeklyRewards.GetActivities()
    if type(activities) ~= "table" or #activities == 0 then
        VaultDebugMessage("Aucune activité renvoyée.")
        return
    end
    VaultDebugMessage("Dump des activités hebdo :")
    for _, act in ipairs(activities) do
        local typeVal = act.type
        local typeName = EnumKeyForValue(Enum and Enum.WeeklyRewardChestActivityType, typeVal)
                      or EnumKeyForValue(Enum and Enum.WeeklyRewardActivityType, typeVal)
                      or EnumKeyForValue(Enum and Enum.WeeklyRewardChestThresholdType, typeVal)
                      or "?"
        local progress = type(act.progress) == "number" and act.progress or 0
        local threshold = type(act.threshold) == "number" and act.threshold or 0
        local line = string.format("[%d] type=%s (%s) prog=%d/%d id=%d", act.index or 0, tostring(typeVal or "nil"), typeName, progress, threshold, act.id or 0)
        VaultDebugMessage(line)
    end
end

local function DumpSortedProgress()
    if not (C_WeeklyRewards and C_WeeklyRewards.GetSortedProgressForActivity) then
        VaultDebugMessage("API GetSortedProgressForActivity indisponible.")
        return
    end

    VaultDebugMessage("Dump du progress trié :")
    for r = 1, 3 do
        local typeId   = GV_ROW_TYPES[r]
        local typeName = EnumKeyForValue(Enum and Enum.WeeklyRewardChestThresholdType, typeId)
                      or tostring(typeId)
        local tiers    = C_WeeklyRewards.GetSortedProgressForActivity(typeId, true)
        if type(tiers) == "table" and #tiers > 0 then
            for tierIndex, tierInfo in ipairs(tiers) do
                local tierId    = tierInfo.activityTierID or 0
                local diff      = tierInfo.difficulty or 0
                local points    = tierInfo.numPoints or 0
                local threshold = GV_THRESHOLDS[r][tierIndex] or 0
                local line = string.format("[%s #%d] tierId=%d diff=%d points=%d threshold=%d", typeName, tierIndex, tierId, diff, points, threshold)
                VaultDebugMessage(line)
            end
        else
            VaultDebugMessage(string.format("[%s] aucune donnée.", typeName))
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

SLASH_MOTVAULT1 = "/motvault"
SlashCmdList.MOTVAULT = function()
    DumpVaultActivities()
    DumpSortedProgress()
end
