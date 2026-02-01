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
            namespace.Text:update()

            namespace.frame:UnregisterEvent("ADDON_LOADED")
        end
    end,

    ["CHALLENGE_MODE_MAPS_UPDATE"] = function()
        namespace.Text:update()
    end,

    ["BAG_UPDATE_DELAYED"] = function()
        namespace.Text:update()
    end,

    ["ITEM_CHANGED"] = function()
        namespace.Text:update()
    end,
}

for event, _ in pairs(EventHandler) do
    namespace.frame:RegisterEvent(event)
end

namespace.frame:SetScript(
    "OnEvent",
    function(frame, event, ...) EventHandler[event](...) end
)
