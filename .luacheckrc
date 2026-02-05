-- standard: "min" (Lua 5.1)
std = "lua51"

-- Don't report unused variables if they are named "_" or prefixed with "_"
ignore = {
    "211/_.*", -- Unused local variable
    "212/_.*", -- Unused argument
    "213/_.*", -- Unused loop variable
}

-- Enable all warnings by default
-- codes = true

-- Definitions of globals that are allowed to be defined by this addon
globals = {
    "KeystoneTextConfig", -- SavedVariable
}

-- Definitions of globals that this addon is allowed to access (read-only)
read_globals = {
    -- Standard WoW API
    "C_ChallengeMode",
    "C_DateAndTime",
    "C_MythicPlus",
    "C_Timer",
    "CreateFrame",
    "GameFontNormal",
    "UIParent",
    "strsplit",
    "GetTime",

    -- Libraries
    "LibStub",

    -- Addon Namespace (if accessed globally, though currently local)
    "KeystoneText",
}

-- Exclude third-party libraries from linting (they are not your code)
exclude_files = {
    "Libs/**",
}

-- Strictness settings
max_line_length = 79
color = true
