local thisAddonName, namespace = ...

-- Create the text frame.

local frame = CreateFrame("Frame", "KeystoneTextFrame", UIParent)
frame:SetSize(100, 20)
local fontstring = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fontstring:SetPoint("CENTER")
fontstring:SetText("placeholder for keystone text")
frame:Hide() -- Hide initially until vars are loaded

namespace.frame = frame

-- Define a type to wrap the logic around modifying the fontstring object.
namespace.Text = {
    -- Cache current the keystone info.
    ["_cache"] = {
        ["mapId"] = nil,
        ["level"] = nil,
    },

    -- Update the fontstring if the specified keystone `mapId` and `level` are
    -- different from what we have cached.
    ["_update"] = function(self, mapId, level)
        -- Skip updating the text if the value has not changed.

        if (mapId == nil and self._cache.mapId == nil)
            or (mapId == self._cache.mapId and level == self._cache.level) then
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

            -- Show the fontstring if we didn't previously have a keystone.

            if self._cache.mapId == nil then
                fontstring:Show()
            end

            -- Update the cache.

            self._cache.mapId = mapId
            self._cache.level = level
        end
    end,

    -- Return the map ID and level of the specified keystone `itemLink`.  If
    -- `itemLink` is not a keystone item link, return `nil`.
    ["_getKeystoneInfoFromItemLink"] = function(itemLink)
        if itemLink == nil then
            return
        end

        local mapId
        local level

        -- Check for the item IDs for both live and tournament realms.  Be sure
        -- to check live first.

        for _, itemId in ipairs({
            180653, -- live servers
            151086, -- tournament realm
        }) do
            -- Check for the special `keystone` link type.

            mapId, level = select(
                3,
                itemLink:find("|Hkeystone:" .. itemId .. ":(%d+):(%d+):")
            )

            if mapId ~= nil then
                break
            end

            -- Check for the generic `item` link type.

            local bonusIds = select(
                3,
                itemLink:find("|Hitem:" .. itemId .. ":(.+)")
            )
            if bonusIds ~= nil then
                local _
                mapId, _, level = select(15, strsplit(":", bonusIds))

                if mapId ~= nil then
                    break
                end
            end
        end

        if mapId == nil then
            return
        end

        return tonumber(mapId), tonumber(level)
    end,

    -- Query the API for what keystone we have, then update the fontstring if
    -- needed.
    ["updateFromApi"] = function(self)
        local mapId = C_MythicPlus.GetOwnedKeystoneChallengeMapID()
        local level = C_MythicPlus.GetOwnedKeystoneLevel()

        self:_update(
            C_MythicPlus.GetOwnedKeystoneChallengeMapID(),
            C_MythicPlus.GetOwnedKeystoneLevel()
        )
    end,

    -- Try to extract the keystone info from the specified `itemLink` and
    -- update the fontstring with that info.  Do nothing if `itemLink` is not
    -- for a keystone.
    ["updateFromItemLink"] = function(self, itemLink)
        local mapId, level = self._getKeystoneInfoFromItemLink(itemLink)

        if mapId == nil then
            return
        end

        self:_update(mapId, level)
    end,
}
