require("tests.helpers")

describe("ADDON_LOADED", function()
    local namespace
    local frame
    local fontstring

    before_each(function()
        namespace = loadAddon()
        frame = namespace.frame
        fontstring = namespace.fontstring
    end)

    it("Updates from the API", function()
        --[[
        GIVEN:
            - the `ADDON_LOADED` event is fired

        WHEN:
            - the `C_MythicPlus` API returns non-`nil` keystone info

        THEN:
            - we schedule a registration for `BAG_UPDATE_DELAYED` events
            - the `fontstring` is shown
            - the `fontstring` has its text set
            - we unregister from further `ADDON_LOADED` events
            - we unregister from `CHALLENGE_MODE_MAPS_UPDATE` events
            - we unregister from `BAG_UPDATE_DELAYED` events
        ]]

        local getKeystoneMap = stub(
            C_MythicPlus,
            "GetOwnedKeystoneChallengeMapID",
            function() return 123 end
        )
        local getKeystoneLevel = stub(
            C_MythicPlus,
            "GetOwnedKeystoneLevel",
            function() return 456 end
        )
        local getKeystoneMapName = stub(
            C_ChallengeMode,
            "GetMapUIInfo",
            function() return "some-key" end
        )
        local setKeystoneText = stub(fontstring, "SetFormattedText")
        local getTimeToReset = stub(
            C_DateAndTime,
            "GetSecondsUntilWeeklyReset",
            function() return 789 end
        )
        local scheduleCallback = stub(C_Timer, "After")

        finally(function()
            getKeystoneMap:revert()
            getKeystoneLevel:revert()
            getKeystoneMapName:revert()
            setKeystoneText:revert()
            getTimeToReset:revert()
            scheduleCallback:revert()
        end)

        frame.script(frame, "ADDON_LOADED", "KeystoneText")

        assert.stub(scheduleCallback).was_called_with(
            789 + 1,    -- The implementation adds a small delay.
            match.is_function()
        )
        assert.stub(getKeystoneMap).was_called_with()
        assert.stub(getKeystoneLevel).was_called_with()
        assert.stub(getKeystoneMapName).was_called_with(123)
        assert.stub(setKeystoneText).was_called_with(
            match.is_ref(fontstring),
            "%s (%d)",
            "some-key",
            456
        )
        assert.True(fontstring:IsShown())
        assert.falsy(frame.registeredEvents["ADDON_LOADED"])
        assert.falsy(frame.registeredEvents["CHALLENGE_MODE_MAPS_UPDATE"])
        assert.falsy(frame.registeredEvents["BAG_UPDATE_DELAYED"])
    end)

    it("Hides fontstring if keystone info is not available", function()
        --[[
        GIVEN:
            - the `ADDON_LOADED` event is fired

        WHEN:
            - the `C_MythicPlus` API returns `nil` keystone info

        THEN:
            - the `fontstring` is hidden
            - we unregister from further `ADDON_LOADED` events
            - we remain registered for `CHALLENGE_MODE_MAPS_UPDATE` events
            - we remain registered for `BAG_UPDATE_DELAYED` events
        ]]

        local getKeystoneMap = stub(
            C_MythicPlus,
            "GetOwnedKeystoneChallengeMapID",
            function() return nil end
        )
        local getKeystoneLevel = stub(
            C_MythicPlus,
            "GetOwnedKeystoneLevel",
            function() return nil end
        )

        finally(function()
            getKeystoneMap:revert()
            getKeystoneLevel:revert()
        end)

        frame.script(frame, "ADDON_LOADED", "KeystoneText")

        assert.False(fontstring:IsShown())
        assert.falsy(frame.registeredEvents["ADDON_LOADED"])
        assert.truthy(frame.registeredEvents["CHALLENGE_MODE_MAPS_UPDATE"])
        assert.truthy(frame.registeredEvents["BAG_UPDATE_DELAYED"])
    end)
end)

describe("BAG_UPDATE_DELAYED", function()
    local namespace
    local frame
    local fontstring

    before_each(function()
        namespace = loadAddon()
        frame = namespace.frame
        fontstring = namespace.fontstring
    end)

    it(
        "unregisters from `BAG_UPDATE_DELAYED` once we have a keystone",
        function()
            --[[
            GIVEN:
                - `ADDON_LOADED` has been handled
                - we do not have a keystone

            WHEN:
                - `BAG_UPDATE_DELAYED` fires
                - we receive a keystone

            THEN:
                - the fontstring is shown
                - we unregister from `BAG_UPDATE_DELAYED`
            ]]

            local mapId = nil
            local level = nil

            local getKeystoneMap = stub(
                C_MythicPlus,
                "GetOwnedKeystoneChallengeMapID",
                function() return mapId end
            )
            local getKeystoneLevel = stub(
                C_MythicPlus,
                "GetOwnedKeystoneLevel",
                function() return level end
            )

            finally(function()
                getKeystoneMap:revert()
                getKeystoneLevel:revert()
            end)

            frame.script(frame, "ADDON_LOADED", "KeystoneText")

            mapId = 123
            level = 456
            frame.script(frame, "BAG_UPDATE_DELAYED")

            assert.True(fontstring:IsShown())
            assert.falsy(frame.registeredEvents["BAG_UPDATE_DELAYED"])
        end
    )

    it(
        "doesn't unregister BAG_UPDATE_DELAYED if we don't have a keystone",
        function()
            --[[
            GIVEN:
                - `ADDON_LOADED` has been handled
                - we do not have a keystone

            WHEN:
                - `BAG_UPDATE_DELAYED` fires
                - we still don't have a keystone

            THEN:
                - the fontstring is hidden
                - we are still registered `BAG_UPDATE_DELAYED`
            ]]

            local getKeystoneMap = stub(
                C_MythicPlus,
                "GetOwnedKeystoneChallengeMapID",
                function() return nil end
            )
            local getKeystoneLevel = stub(
                C_MythicPlus,
                "GetOwnedKeystoneLevel",
                function() return nil end
            )

            finally(function()
                getKeystoneMap:revert()
                getKeystoneLevel:revert()
            end)

            frame.script(frame, "ADDON_LOADED", "KeystoneText")

            frame.script(frame, "BAG_UPDATE_DELAYED")

            assert.False(fontstring:IsShown())
            assert.truthy(frame.registeredEvents["BAG_UPDATE_DELAYED"])
        end
    )
end)
