local thisAddonName, namespace = ...

-- Define the configuration values and how to apply them.

local frame = namespace.frame
local fontstring = namespace.fontstring

local defaultSettings = {
    ["anchor"] = {
        ["frame"] = "UIParent",
        ["point"] = "TOP",
        ["relativeTo"] = "TOP",
        ["xOffset"] = 0,
        ["yOffset"] = 0,
    },

    ["font"] = {
        ["color"] = {0.8, 0, 0.8, 1},

        -- Note that the following are set below dynamically by inspecting the
        -- default font template.

        -- ["type"] = nil,
        -- ["size"] = nil,
        -- ["flags"] = nil,
    },
}
defaultSettings.font.type,
    defaultSettings.font.size,
    defaultSettings.font.flags = GameFontNormal:GetFont()

-- Key into the specified `root` for all of the passed-in keys and return the
-- resulting node's value.  If the specified `allowMistype` is `true`, then
-- return `nil` upon the first invalid key access; otherwise, allow the invalid
-- key access to raise an error.  Note that the last key access may succeed and
-- return `nil` if it's performed on a table, even if the key does not exist in
-- that table (as is standard lua table lookup behavior).
local function getConfigFromRoot(root, allowMistype, ...)
    local node = root
    local numKeys = select("#", ...)
    for i = 1, numKeys do
        local key = select(i, ...)

        if not allowMistype or type(node) == "table" then
            -- Traverse for this key.  Either it's safe to do so, or
            -- `allowMistype` is `false` and we'll hit an exception.

            node = node[key]
        elseif allowMistype then
            return nil
        end
    end

    return node
end

-- Key into the `KeystoneTextConfig` for all of the passed-in keys and return
-- the resulting node's value, if it exists.  Otherwise, return the value for
-- the same key accesses in `defaultSettings`.  Raise an error if the requested
-- keys cannot be looked up in both tables.  Note that this function may
-- succeed and return `nil` even if the last key exists in neither
-- `KeystoneTextConfig` or `defaultSettings` (as is standard lua table lookup
-- behavior).
local function getConfigOrDefault(...)
    local userConfig = getConfigFromRoot(KeystoneTextConfig, true, ...)
    if userConfig ~= nil then
        return userConfig
    end

    return getConfigFromRoot(defaultSettings, false, ...)
end

-- Return a deep copy of the specified `source`.
local function deepCopy(source)
    if type(source) ~= "table" then
        return source
    end

    local result = {}
    for k, v in pairs(source) do
        result[deepCopy(k)] = deepCopy(v)
    end
    return result
end

-- Set the `KeystoneTextConfig`'s specified `group` subkey to that group's
-- defaults.
local function assignDefaultConfigGroup(group)
    KeystoneTextConfig[group] = deepCopy(defaultSettings[group])
end

namespace.settings = {
    -- Overwrite the `KeystoneTextConfig` global variable with a copy of the
    -- defaults.  Note that this does not apply any changes to the UI.
    ["assignDefaultConfig"] = function(self)
        KeystoneTextConfig = deepCopy(defaultSettings)
    end,

    -- Re-anchor the fontstring.
    ["reanchor"] = function()
        local parent = _G[getConfigOrDefault("anchor", "frame")]
        if parent then
            fontstring:ClearAllPoints()
            fontstring:SetPoint(
                getConfigOrDefault("anchor", "point"),
                parent,
                getConfigOrDefault("anchor", "relativeTo"),
                getConfigOrDefault("anchor", "xOffset"),
                getConfigOrDefault("anchor", "yOffset")
            )
            if not frame:IsShown() then
                frame:Show()
            end
        else
            print(
                thisAddonName
                .. ": Failed to anchor keystone text to nonexistent frame: "
                .. getConfigOrDefault("anchor", "frame")
            )
            if frame:IsShown() then
                frame:Hide()
            end
        end
    end,

    -- Apply the font config to the fontstring.
    ["restyle"] = function()
        fontstring:SetTextColor(unpack(getConfigOrDefault("font", "color")))
        fontstring:SetFont(
            getConfigOrDefault("font", "type"),
            getConfigOrDefault("font", "size"),
            getConfigOrDefault("font", "flags")
        )
    end,

    -- Register the settings with the UI.
    ["register"] = function(self)
        local ac = LibStub("AceConfig-3.0")
        local optionsTable = {
            ["name"] = thisAddonName,
            ["type"] = "group",
            ["childGroups"] = "tab",
            ["args"] = {
                ["anchor"] = {
                    ["name"] = "Anchor",
                    ["type"] = "group",
                    ["args"] = {
                        ["anchorFrame"] = {
                            ["order"] = 0,
                            ["name"] = "Anchor To Frame",
                            ["type"] = "input",
                            ["set"] = function(info, value)
                                KeystoneTextConfig.anchor = (
                                    KeystoneTextConfig.anchor or {}
                                )
                                KeystoneTextConfig.anchor.frame = value
                                self:reanchor()
                            end,
                            ["get"] = function(info)
                                return getConfigOrDefault("anchor", "frame")
                            end,
                        },

                        ["anchorPoint"] = {
                            ["order"] = 1,
                            ["name"] = "Anchor Point",
                            ["type"] = "select",
                            ["style"] = "dropdown",
                            ["values"] = {
                                ["TOPLEFT"]     = "TOPLEFT",
                                ["TOP"]         = "TOP",
                                ["TOPRIGHT"]    = "TOPRIGHT",
                                ["LEFT"]        = "LEFT",
                                ["CENTER"]      = "CENTER",
                                ["RIGHT"]       = "RIGHT",
                                ["BOTTOMLEFT"]  = "BOTTOMLEFT",
                                ["BOTTOM"]      = "BOTTOM",
                                ["BOTTOMRIGHT"] = "BOTTOMRIGHT",
                            },
                            ["sorting"] = {
                                "TOPLEFT",
                                "TOP",
                                "TOPRIGHT",
                                "LEFT",
                                "CENTER",
                                "RIGHT",
                                "BOTTOMLEFT",
                                "BOTTOM",
                                "BOTTOMRIGHT",
                            },
                            ["set"] = function(info, value)
                                KeystoneTextConfig.anchor = (
                                    KeystoneTextConfig.anchor or {}
                                )
                                KeystoneTextConfig.anchor.point = value
                                self:reanchor()
                            end,
                            ["get"] = function(info)
                                return getConfigOrDefault("anchor", "point")
                            end,
                        },

                        ["anchorRelativeTo"] = {
                            ["order"] = 2,
                            ["name"] = "Anchor Relative To",
                            ["type"] = "select",
                            ["style"] = "dropdown",
                            ["values"] = {
                                ["TOPLEFT"]     = "TOPLEFT",
                                ["TOP"]         = "TOP",
                                ["TOPRIGHT"]    = "TOPRIGHT",
                                ["LEFT"]        = "LEFT",
                                ["CENTER"]      = "CENTER",
                                ["RIGHT"]       = "RIGHT",
                                ["BOTTOMLEFT"]  = "BOTTOMLEFT",
                                ["BOTTOM"]      = "BOTTOM",
                                ["BOTTOMRIGHT"] = "BOTTOMRIGHT",
                            },
                            ["sorting"] = {
                                "TOPLEFT",
                                "TOP",
                                "TOPRIGHT",
                                "LEFT",
                                "CENTER",
                                "RIGHT",
                                "BOTTOMLEFT",
                                "BOTTOM",
                                "BOTTOMRIGHT",
                            },
                            ["set"] = function(info, value)
                                KeystoneTextConfig.anchor = (
                                    KeystoneTextConfig.anchor or {}
                                )
                                KeystoneTextConfig.anchor.relativeTo = value
                                self:reanchor()
                            end,
                            ["get"] = function(info)
                                return getConfigOrDefault(
                                    "anchor",
                                    "relativeTo"
                                )
                            end,
                        },

                        ["xOffset"] = {
                            ["order"] = 3,
                            ["name"] = "X-Offset",
                            ["type"] = "range",
                            ["softMin"] = -500,
                            ["softMax"] = 500,
                            ["set"] = function(info, value)
                                KeystoneTextConfig.anchor = (
                                    KeystoneTextConfig.anchor or {}
                                )
                                KeystoneTextConfig.anchor.xOffset = value
                                self:reanchor()
                            end,
                            ["get"] = function(info)
                                return getConfigOrDefault("anchor", "xOffset")
                            end,
                        },

                        ["yOffset"] = {
                            ["order"] = 4,
                            ["name"] = "Y-Offset",
                            ["type"] = "range",
                            ["softMin"] = -500,
                            ["softMax"] = 500,
                            ["set"] = function(info, value)
                                KeystoneTextConfig.anchor = (
                                    KeystoneTextConfig.anchor or {}
                                )
                                KeystoneTextConfig.anchor.yOffset = value
                                self:reanchor()
                            end,
                            ["get"] = function(info)
                                return getConfigOrDefault("anchor", "yOffset")
                            end,
                        },

                        ["resetDefault"] = {
                            ["type"] = "execute",
                            ["order"] = 5,
                            ["name"] = "Reset to Default",
                            ["func"] = function()
                                assignDefaultConfigGroup("anchor")
                                self:reanchor()
                            end,
                        }
                    },
                },

                ["font"] = {
                    ["name"] = "Font",
                    ["type"] = "group",
                    ["args"] = {
                        ["color"] = {
                            ["order"] = 0,
                            ["name"] = "Color",
                            ["type"] = "color",
                            ["hasAlpha"] = true,
                            ["set"] = function(info, r, g, b, a)
                                KeystoneTextConfig.font = (
                                    KeystoneTextConfig.font or {}
                                )
                                KeystoneTextConfig.font.color = {r, g, b, a}
                                self:restyle()
                            end,
                            ["get"] = function(info)
                                return unpack(
                                    getConfigOrDefault("font", "color")
                                )
                            end,
                        },

                        ["type"] = {
                            ["order"] = 1,
                            ["name"] = "Type",
                            ["type"] = "input",
                            ["set"] = function(info, value)
                                KeystoneTextConfig.font = (
                                    KeystoneTextConfig.font or {}
                                )
                                KeystoneTextConfig.font.type = value
                                self:restyle()
                            end,
                            ["get"] = function(info)
                                return getConfigOrDefault("font", "type")
                            end,
                        },

                        ["size"] = {
                            ["order"] = 2,
                            ["name"] = "Size",
                            ["type"] = "range",
                            ["min"] = 6,
                            ["max"] = 100,
                            ["set"] = function(info, value)
                                KeystoneTextConfig.font = (
                                    KeystoneTextConfig.font or {}
                                )
                                KeystoneTextConfig.font.size = value
                                self:restyle()
                            end,
                            ["get"] = function(info)
                                return getConfigOrDefault("font", "size")
                            end,
                        },

                        ["flags"] = {
                            ["order"] = 3,
                            ["name"] = "Flags",
                            ["type"] = "select",
                            ["style"] = "dropdown",
                            ["values"] = {
                                [""]             = "None",
                                ["OUTLINE"]      = "Outline",
                                ["THICKOUTLINE"] = "Thick Outline",
                                ["MONOCHROME"]   = "Monochrome",
                            },
                            ["set"] = function(info, value)
                                KeystoneTextConfig.font = (
                                    KeystoneTextConfig.font or {}
                                )
                                KeystoneTextConfig.font.flags = value
                                self:restyle()
                            end,
                            ["get"] = function(info)
                                return getConfigOrDefault("font", "flags")
                            end,
                        },

                        ["resetDefault"] = {
                            ["type"] = "execute",
                            ["order"] = 4,
                            ["name"] = "Reset to Default",
                            ["func"] = function()
                                assignDefaultConfigGroup("font")
                                self:restyle()
                            end,
                        }
                    },
                },
            },
        }
        ac:RegisterOptionsTable(thisAddonName, optionsTable, nil)

        local acd = LibStub("AceConfigDialog-3.0")
        return acd:AddToBlizOptions(thisAddonName)
    end,
}
