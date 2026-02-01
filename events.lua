local thisAddonName, namespace = ...

-- Define event handlers to attach to the addon frame.

local frame = namespace.frame

local EventHandler = {
    ["ADDON_LOADED"] = function(addonName)
        if addonName == thisAddonName then
            -- Initialize the Saved Variable if it doesn't exist.

            if KeystoneTextConfig == nil then
                namespace.Settings:assignDefaultConfig()
            end

            namespace.Settings:register()
            namespace.Settings:reanchor()

            frame:UnregisterEvent("ADDON_LOADED")
        end
    end,
}

for event, _ in pairs(EventHandler) do
    frame:RegisterEvent(event)
end

frame:SetScript(
    "OnEvent",
    function(frame, event, ...) EventHandler[event](...) end
)
