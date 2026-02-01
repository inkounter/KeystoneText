local thisAddonName, namespace = ...

-- Create the text frame.

local frame = CreateFrame("Frame", "KeystoneTextFrame", UIParent)
frame:SetSize(100, 20)
local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("CENTER")
text:SetText("placeholder for keystone text")
frame:Hide() -- Hide initially until vars are loaded

namespace.frame = frame

frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == thisAddonName then
        -- Initialize the Saved Variable if it doesn't exist.

        if KeystoneTextConfig == nil then
            namespace.Settings:assignDefaultConfig()
        end
        
        namespace.Settings:register()
        namespace.Settings:reanchor()
        
        self:UnregisterEvent("ADDON_LOADED") 
    end
end)
