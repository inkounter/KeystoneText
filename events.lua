local thisAddonName, namespace = ...

-- Define event handlers to attach to the addon frame.

local fontstring = namespace.fontstring
local settings = namespace.settings
local frame = namespace.frame

local EventHandler = {
    ["ADDON_LOADED"] = function(addonName)
        if addonName == thisAddonName then
            -- Initialize the Saved Variable if it doesn't exist.

            if KeystoneTextConfig == nil then
                KeystoneTextConfig = {}
            end

            settings:register()
            settings:reanchor()
            settings:restyle()
            fontstring:updateFromApi()

            frame:UnregisterEvent("ADDON_LOADED")

            -- After the weekly reset, force an update of the fontstring and,
            -- if we don't have a keystone, re-register for
            -- `BAG_UPDATE_DELAYED`.

            C_Timer.After(
                C_DateAndTime.GetSecondsUntilWeeklyReset() + 1,
                function()
                    fontstring:updateFromApi()

                    if not fontstring:hasKeystone() then
                        frame:RegisterEvent("BAG_UPDATE_DELAYED")
                    end
                end
            )

            -- If we already have the keystone information upon loading the
            -- addon, then we don't need to listen for the events below.

            if fontstring:hasKeystone() then
                frame:UnregisterEvent("CHALLENGE_MODE_MAPS_UPDATE")
                frame:UnregisterEvent("BAG_UPDATE_DELAYED")
            end
        end
    end,

    ["CHALLENGE_MODE_MAPS_UPDATE"] = function()
        -- We rely on only the first of these updates per `/reload` to know
        -- when to query the `C_MythicPlus` API.

        fontstring:updateFromApi()

        -- Further occurrences of this event are fired periodically at
        -- arbitrary intervals, and it is not fired when our keystone changes.

        frame:UnregisterEvent("CHALLENGE_MODE_MAPS_UPDATE")

        -- If we have a keystone, then we no longer have to listen for
        -- `BAG_UPDATE_DELAYED` events.

        if fontstring:hasKeystone() then
            frame:UnregisterEvent("BAG_UPDATE_DELAYED")
        end
    end,

    ["BAG_UPDATE_DELAYED"] = function()
        -- Listen to this event to see when we loot a keystone.

        fontstring:updateFromApi()

        if fontstring:hasKeystone() then
            frame:UnregisterEvent("BAG_UPDATE_DELAYED")
        end
    end,

    ["CHALLENGE_MODE_START"] = function()
        -- The dungeon has started.  Check if we need to update the fontstring
        -- for our keystone.

        fontstring:updateFromApi()
    end,

    ["CHALLENGE_MODE_COMPLETED"] = function()
        -- The keystone changes after this event is fired. Schedule an update.

        C_Timer.After(1, function() fontstring:updateFromApi() end)
    end,

    ["ITEM_CHANGED"] = function(_oldItemLink, newItemLink)
        -- Listen to this event to observe when we reroll our keystone or when
        -- we drop the keystone by talking to the NPC.

        fontstring:updateFromItemLink(newItemLink)
    end,
}

for event, _ in pairs(EventHandler) do
    frame:RegisterEvent(event)
end

frame:SetScript(
    "OnEvent",
    function(_frame, event, ...) EventHandler[event](...) end
)
