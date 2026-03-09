local L = {}
_G.MidnightL = L

local currentLocale = "en"

function L.GetLocale()
    return currentLocale
end

function L.Init()
    local gameLocale = GetLocale and GetLocale() or "enUS"
    if gameLocale == "frFR" or gameLocale == "frCA" then
        currentLocale = "fr"
    elseif gameLocale == "deDE" then
        currentLocale = "de"
    elseif gameLocale == "esES" or gameLocale == "esMX" then
        currentLocale = "es"
    else
        currentLocale = "en"
    end
end

function L.S(key)
    local loc = currentLocale
    if L[loc] and L[loc][key] ~= nil then
        return L[loc][key]
    end
    if L.en and L.en[key] ~= nil then
        return L.en[key]
    end
    if L.fr and L.fr[key] ~= nil then
        return L.fr[key]
    end
    return key
end

L.ColorblindModes = {
    "none",
    "deuteranomaly", "protanomaly", "tritanomaly",
    "deuteranopia", "protanopia", "tritanopia",
    "achromatopsia", "monochromacy",
}

L.ColorPalettes = {
    none = {
        adventurer = "7CFFB8",
        veteran    = "7FB8FF",
        champion   = "C0A0FF",
        heroic     = "FFB86A",
        mythic     = "FFE07A",
        spark      = "FFD100",
        prefix     = "ff3b3b",
    },
    protanopia = {
        adventurer = "009E73",
        veteran    = "56B4E9",
        champion   = "CC79A7",
        heroic     = "E69F00",
        mythic     = "FFFFFF",
        spark      = "D4AA00",
        prefix     = "F0E442",
    },
    protanomaly = {
        adventurer = "60D8B0",
        veteran    = "7FB8FF",
        champion   = "CC90D0",
        heroic     = "FFCC44",
        mythic     = "FFF2A0",
        spark      = "FFD100",
        prefix     = "FF7733",
    },
    deuteranopia = {
        adventurer = "0072B2",
        veteran    = "56B4E9",
        champion   = "CC79A7",
        heroic     = "F0E442",
        mythic     = "FFFFFF",
        spark      = "D4AA00",
        prefix     = "D55E00",
    },
    deuteranomaly = {
        adventurer = "40C0B0",
        veteran    = "7FB8FF",
        champion   = "CC90D0",
        heroic     = "FFD060",
        mythic     = "FFF5B0",
        spark      = "FFD100",
        prefix     = "FF5522",
    },
    tritanopia = {
        adventurer = "33BB77",
        veteran    = "FF80A0",
        champion   = "D0A0D0",
        heroic     = "FF8844",
        mythic     = "E8E8E8",
        spark      = "FF9966",
        prefix     = "ff3b3b",
    },
    tritanomaly = {
        adventurer = "60D8A0",
        veteran    = "A098FF",
        champion   = "C8A0E0",
        heroic     = "FFB86A",
        mythic     = "FFD8A0",
        spark      = "FFC060",
        prefix     = "ff3b3b",
    },

    achromatopsia = {
        adventurer = "D8D8D8",
        veteran    = "B4B4B4",
        champion   = "909090",
        heroic     = "ECECEC",
        mythic     = "F8F8F8",
        spark      = "E4E4E4",
        prefix     = "A8A8A8",
    },

    monochromacy = {
        adventurer = "55AAEE",
        veteran    = "88CCFF",
        champion   = "2255BB",
        heroic     = "AAE0FF",
        mythic     = "D8EEFF",
        spark      = "EEF5FF",
        prefix     = "7799DD",
    },
}

L._colorblindMode = "none"

function L.SetColorblindMode(mode)
    L._colorblindMode = mode or "none"
end

function L.GetColorblindMode()
    return L._colorblindMode or "none"
end

function L.C(key)
    local mode = L._colorblindMode or "none"
    local palette = L.ColorPalettes[mode] or L.ColorPalettes.none
    return palette[key] or L.ColorPalettes.none[key] or "FFFFFF"
end

L.weekTimestamps = {
    1772150400,
    1772604000,
    1773208800,
    1773813600,
    1774418400,
    1775019600,
    1775624400,
    1776229200,
    1776834000,
    1777438800,
}

local function _getDateParts(ts)
    local t = date("*t", ts)
    return t.day, t.month
end

function L.FormatMenuLabel(weekIndex)
    local ts = L.weekTimestamps
    if not ts or not ts[weekIndex] then return nil end
    local loc = L.GetLocale()
    local locTable = L[loc]
    if not locTable then return nil end

    local startTs = ts[weekIndex]
    local nextTs  = ts[weekIndex + 1]
    local sd, sm  = _getDateParts(startTs)

    if not nextTs then
        if locTable.formatLastMenuLabel then
            return locTable.formatLastMenuLabel(sd, sm)
        end
        return nil
    end

    local ed, em = _getDateParts(nextTs - 86400)
    if locTable.formatMenuLabel then
        return locTable.formatMenuLabel(sd, sm, ed, em)
    end
    return nil
end

function L.FormatWeekTitle(weekIndex)
    local ts = L.weekTimestamps
    if not ts or not ts[weekIndex] then return nil end
    local loc = L.GetLocale()
    local locTable = L[loc]
    if not locTable or not locTable.formatWeekTitle then return nil end

    local startTs = ts[weekIndex]
    local nextTs  = ts[weekIndex + 1]
    local sd, sm  = _getDateParts(startTs)

    if not nextTs then
        return locTable.formatWeekTitle(weekIndex, sd, sm, nil, nil)
    end

    local ed, em = _getDateParts(nextTs - 86400)
    return locTable.formatWeekTitle(weekIndex, sd, sm, ed, em)
end

function L.FormatMplusSubtitle()
    local ts = L.weekTimestamps
    if not ts or not ts[4] then return nil end
    local loc = L.GetLocale()
    local locTable = L[loc]
    if not locTable or not locTable.formatSubtitle then return nil end
    local d, m = _getDateParts(ts[4])
    return locTable.formatSubtitle(d, m)
end