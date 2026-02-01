local thisAddonName, namespace = ...

-- Define the configuration values and how to apply them.

namespace.Settings = {
    ["defaultConfig"] = {
        ["anchorFrame"] = "UIParent",
        ["anchorPoint"] = "TOP",
        ["anchorRelativeTo"] = "TOP",
        ["xOffset"] = 0,
        ["yOffset"] = 0,
    },

    -- Overwrite the `KeystoneTextConfig` global variable with a (shallow) copy
    -- of the defaults.  Note that this does not apply any changes to the UI.
    ["assignDefaultConfig"] = function(self)
        KeystoneTextConfig = {}
        local config = KeystoneTextConfig
        for k, v in pairs(self.defaultConfig) do
            config[k] = v
        end
    end,

    -- Re-anchor the fontstring.
    ["reanchor"] = function()
        local config = KeystoneTextConfig
        local frame = namespace.frame
        local fontstring = namespace.fontstring
        local parent = _G[config.anchorFrame]
        if parent then
            fontstring:ClearAllPoints()
            fontstring:SetPoint(
                config.anchorPoint,
                parent,
                config.anchorRelativeTo,
                config.xOffset,
                config.yOffset
            )
            if not frame:IsShown() then
                frame:Show()
            end
        else
            print(
                thisAddonName
                .. ": Failed to anchor keystone text to nonexistent frame: "
                .. config.anchorFrame
            )
            if frame:IsShown() then
                frame:Hide()
            end
        end
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
                                KeystoneTextConfig.anchorFrame = value
                                self:reanchor()
                            end,
                            ["get"] = function(info)
                                return KeystoneTextConfig.anchorFrame
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
                                KeystoneTextConfig.anchorPoint = value
                                self:reanchor()
                            end,
                            ["get"] = function(info)
                                return KeystoneTextConfig.anchorPoint
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
                                KeystoneTextConfig.anchorRelativeTo = value
                                self:reanchor()
                            end,
                            ["get"] = function(info)
                                return KeystoneTextConfig.anchorRelativeTo
                            end,
                        },

                        ["xOffset"] = {
                            ["order"] = 3,
                            ["name"] = "X-Offset",
                            ["type"] = "range",
                            ["softMin"] = -500,
                            ["softMax"] = 500,
                            ["set"] = function(info, value)
                                KeystoneTextConfig.xOffset = value
                                self:reanchor()
                            end,
                            ["get"] = function(info)
                                return KeystoneTextConfig.xOffset
                            end,
                        },

                        ["yOffset"] = {
                            ["order"] = 4,
                            ["name"] = "Y-Offset",
                            ["type"] = "range",
                            ["softMin"] = -500,
                            ["softMax"] = 500,
                            ["set"] = function(info, value)
                                KeystoneTextConfig.yOffset = value
                                self:reanchor()
                            end,
                            ["get"] = function(info)
                                return KeystoneTextConfig.yOffset
                            end,
                        },

                        ["resetDefault"] = {
                            ["type"] = "execute",
                            ["order"] = 5,
                            ["name"] = "Reset to Default",
                            ["func"] = function()
                                self:assignDefaultConfig()
                                self:reanchor()
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
