local thisAddonName, namespace = ...

-- Create the addon frame and fontstring.

local frame = CreateFrame("Frame", nil, UIParent)
local fontstring = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
fontstring:SetPoint("CENTER")

-- Until we get the keystone info, hide the fontstring.

fontstring:Hide()

namespace.frame = frame
namespace.fontstring = fontstring
