local thisAddonName, namespace = ...

-- Create the text frame.

local frame = CreateFrame("Frame", "KeystoneTextFrame", UIParent)
frame:SetSize(100, 20)
local fontstring = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fontstring:SetPoint("CENTER")
fontstring:SetText("placeholder for keystone text")
frame:Hide() -- Hide initially until vars are loaded

namespace.frame = frame

-- Define a type to wrap the logic around modifying the `FontString` object.
namespace.Text = {
    -- Cache current the keystone info.
    ["cache"] = {
        ["mapId"] = nil,
        ["level"] = nil,
    },

    -- Update the `FontString` if the keystone information has changed from
    -- what we have cached.
    ["update"] = function(self)
        local mapId = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
        local level = C_MythicPlus.GetOwnedKeystoneLevel()

        -- Skip updating the text if the value has not changed.

        if (mapId == nil and self.cache.mapId == nil)
            or (mapId == self.cache.mapId and level == self.cache.level) then
            return
        end

        if mapId == nil then
            fontstring:Hide()
        else
            fontstring:SetFormattedText(
                "%s (%d)",
                C_ChallengeMode.GetMapUIInfo(mapId),
                level
            )

            -- Show the frame if we didn't previously have a keystone.

            if self.cache.mapId == nil then
                fontstring:Show()
            end

            -- Update the cache.

            self.cache.mapId = mapId
            self.cache.level = level
        end
    end,
}
