local _thisAddonName, namespace = ...

-- Provide control over the fontstring holding the actual text.

-- Cache current the keystone info.
local cachedMapId = nil
local cachedLevel = nil

-- Update the specified `fontstring` if the specified keystone `mapId` and
-- `level` are different from what we have cached.
local updateDisplay = function(fontstring, mapId, level)
    -- Skip updating the text if the value has not changed.

    if (mapId == nil and cachedMapId == nil)
        or (mapId == cachedMapId and level == cachedLevel) then
        return
    end

    -- Update the cache.

    cachedMapId = mapId
    cachedLevel = level

    -- Update the fontstring.

    if mapId == nil then
        fontstring:Hide()
    else
        fontstring:SetFormattedText(
            "%s (%d)",
            C_ChallengeMode.GetMapUIInfo(mapId),
            level
        )

        if not fontstring:IsShown() then
            fontstring:Show()
        end
    end
end

-- Return the map ID and level of the specified keystone `itemLink`.  If
-- `itemLink` is not a keystone item link, return `nil`.
local getKeystoneInfoFromItemLink = function(itemLink)
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
end

-------------------------------------------------------------------------------
-- NAMESPACE

-- Add some public methods to the fontstring.

-- Query the API for what keystone we have, then update the fontstring if
-- needed.
namespace.fontstring.updateFromApi = function(self)
    updateDisplay(
        self,
        C_MythicPlus.GetOwnedKeystoneChallengeMapID(),
        C_MythicPlus.GetOwnedKeystoneLevel()
    )
end

-- Try to extract the keystone info from the specified `itemLink` and update
-- the fontstring with that info.  Do nothing if `itemLink` is not for a
-- keystone.
namespace.fontstring.updateFromItemLink = function(self, itemLink)
    local mapId, level = getKeystoneInfoFromItemLink(itemLink)

    if mapId == nil then
        return
    end

    updateDisplay(self, mapId, level)
end

-- Return `true` if we currently have a keystone.  Otherwise, return `false`.
namespace.fontstring.hasKeystone = function(_self)
    return cachedMapId ~= nil
end
