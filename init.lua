local thisAddonName, namespace = ...

-- Create the text frame.

local frame = CreateFrame("Frame", "KeystoneTextFrame", UIParent)
frame:SetSize(100, 20)
local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
text:SetPoint("CENTER")
text:SetText("placeholder for keystone text")
frame:Hide() -- Hide initially until vars are loaded

namespace.frame = frame
