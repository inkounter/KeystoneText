local thisAddonName, namespace = ...

-- Create the addon frame and fontstring.

local frame = CreateFrame("Frame", nil, UIParent)
local fontstring = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fontstring:SetPoint("CENTER")
fontstring:SetText("placeholder for keystone text")

namespace.frame = frame
namespace.fontstring = fontstring
