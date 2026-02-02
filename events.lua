local thisAddonName, namespace = ...

-- Define event handlers to attach to the addon frame.

local EventHandler = {
    ["ADDON_LOADED"] = function(addonName)
        if addonName == thisAddonName then
            -- Initialize the Saved Variable if it doesn't exist.

            if KeystoneTextConfig == nil then
                namespace.Settings:assignDefaultConfig()
            end

            namespace.Settings:register()
            namespace.Settings:reanchor()
            namespace.fontstring:updateFromApi()

            namespace.frame:UnregisterEvent("ADDON_LOADED")
        end
    end,

    ["CHALLENGE_MODE_MAPS_UPDATE"] = function()
        namespace.fontstring:updateFromApi()
    end,

    ["BAG_UPDATE_DELAYED"] = function()
        namespace.fontstring:updateFromApi()
    end,

    ["ITEM_CHANGED"] = function(oldItemLink, newItemLink)
        namespace.fontstring:updateFromItemLink(newItemLink)
    end,
}

for event, _ in pairs(EventHandler) do
    namespace.frame:RegisterEvent(event)
end

namespace.frame:SetScript(
    "OnEvent",
    function(frame, event, ...) EventHandler[event](...) end
)
