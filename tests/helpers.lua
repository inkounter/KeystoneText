require("tests.wow_mock")

-- Load the addon files in the same order as specified in the `.toc`.  Return
-- the namespace passed to the files.
function loadAddon()
    local namespace = {}

    -- Mock the '...' var passed to lua files
    local function loadAddonFile(file)
        local func = loadfile(file)
        func("KeystoneText", namespace)
    end

    loadAddonFile("init.lua")
    loadAddonFile("fontstring.lua")
    loadAddonFile("settings.lua")
    loadAddonFile("events.lua")

    return namespace
end
