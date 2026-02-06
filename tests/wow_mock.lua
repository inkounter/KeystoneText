-- Provide mocks for World of Warcraft API

_G.UIParent = {}
_G.GameFontNormal = {
    GetFont = function() return "font_path", 12, "" end
}

_G.C_Timer = {
    After = function(_duration, _callback) end
}

_G.C_DateAndTime = {
    GetSecondsUntilWeeklyReset = function() return 3600 end
}

_G.C_MythicPlus = {
    GetOwnedKeystoneChallengeMapID = function() return nil end,
    GetOwnedKeystoneLevel = function() return nil end,
}

_G.C_ChallengeMode = {
    GetMapUIInfo = function(id) return "Dungeon " .. tostring(id) end
}

_G.CreateFrame = function()
    local frame = {
        registeredEvents = {},
        script = nil,
        shown = true,

        RegisterEvent = function(self, event)
            self.registeredEvents[event] = true
        end,
        UnregisterEvent = function(self, event)
            self.registeredEvents[event] = nil
        end,
        SetScript = function(self, _, script) self.script = script end,
        CreateFontString = function(self)
            return {
                parentFrame = self,
                shown = true,

                SetPoint = function() end,
                ClearAllPoints = function() end,
                Hide = function(self) self.shown = false end,
                Show = function(self) self.shown = true end,
                SetTextColor = function() end,
                SetFont = function() end,
                SetFormattedText = function() end,
                IsShown = function(self)
                    return self.parentFrame:IsShown() and self.shown
                end,
            }
        end,
        IsShown = function(self) return self.shown end,
        Show = function(self) self.shown = true end,
        Hide = function(self) self.shown = false end,
    }
    return frame
end

_G.LibStub = function(lib)
    if lib == "AceConfig-3.0" then
        return {
            RegisterOptionsTable = function() end
        }
    elseif lib == "AceConfigDialog-3.0" then
        return {
            AddToBlizOptions = function() end
        }
    end
end
