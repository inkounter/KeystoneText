local thisAddonName, namespace = ...

-- Create the text frame.

local frame = CreateFrame("Frame", "KeystoneTextFrame", UIParent)
frame:SetSize(100, 20)
local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("CENTER")
text:SetText("placeholder for keystone text")
frame:Hide() -- Hide initially until vars are loaded

-- Re-anchor the text frame.
local function reanchor()
    local config = KeystoneTextConfig
    local parent = _G[config.anchorFrame]
    if parent then
        frame:ClearAllPoints()
        frame:SetPoint(
            config.anchorPoint,
            parent,
            config.anchorRelativeTo,
            config.xOffset,
            config.yOffset
        )
        frame:Show()
    else
        print(
            "Failed to anchor keystone text to nonexistent frame: "
            .. config.anchorFrame
        )
        frame:Hide()
    end
end

local Settings = {
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

    -- Register the settings with the UI.
    ["register"] = function(self)
        local ac = LibStub("AceConfig-3.0")
        local optionsTable = {
            ["name"] = thisAddonName,
            ["type"] = "group",
            ["args"] = {
                ["anchorFrame"] = {
                    ["order"] = 0,
                    ["name"] = "Anchor To Frame",
                    ["type"] = "input",
                    ["set"] = function(info, value)
                        KeystoneTextConfig.anchorFrame = value
                        reanchor()
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
                        reanchor()
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
                        reanchor()
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
                        reanchor()
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
                        reanchor()
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
                        reanchor()
                    end,
                }
            },
        }
        ac:RegisterOptionsTable(thisAddonName, optionsTable, nil)

        local acd = LibStub("AceConfigDialog-3.0")
        return acd:AddToBlizOptions(thisAddonName)
    end,
}

frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == thisAddonName then
        -- Initialize the Saved Variable if it doesn't exist.

        if KeystoneTextConfig == nil then
            Settings:assignDefaultConfig()
        end
        
        Settings:register()

        reanchor()
        
        self:UnregisterEvent("ADDON_LOADED") 
    end
end)
