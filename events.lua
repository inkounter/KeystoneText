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
        end
    end,

    ["CHALLENGE_MODE_MAPS_UPDATE"] = function()
        fontstring:updateFromApi()
    end,

    ["BAG_UPDATE_DELAYED"] = function()
        fontstring:updateFromApi()
    end,

    ["ITEM_CHANGED"] = function(oldItemLink, newItemLink)
        fontstring:updateFromItemLink(newItemLink)
    end,
}

for event, _ in pairs(EventHandler) do
    frame:RegisterEvent(event)
end

frame:SetScript(
    "OnEvent",
    function(frame, event, ...) EventHandler[event](...) end
)
