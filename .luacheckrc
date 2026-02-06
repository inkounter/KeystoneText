-- standard: "min" (Lua 5.1)
std = "lua51"

ignore = {
    -- Don't report unused variables if they are named "_" or prefixed with "_"
    "211/_.*", -- Unused local variable
    "212/_.*", -- Unused argument
    "213/_.*", -- Unused loop variable

    "432/self", -- Shadowing upvalue argument 'self'
}

-- Enable all warnings by default
codes = true

-- Definitions of globals that are allowed to be defined by this addon
globals = {
    "KeystoneTextConfig", -- SavedVariable
    "loadAddon", -- Test helper
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

    -- Busted / Tests
    "after_each",
    "assert",
    "before_each",
    "describe",
    "finally",
    "it",
    "match",
    "mock",
    "setup",
    "spy",
    "stub",
    "teardown",
}

-- Exclude third-party libraries from linting (they are not your code)
exclude_files = {
    "Libs/**",
}

-- Strictness settings
max_line_length = 79
color = true
