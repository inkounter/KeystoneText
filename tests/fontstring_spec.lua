require("tests.helpers")

describe("fontstring:updateFromApi", function()
    local namespace
    local fontstring

    before_each(function()
        namespace = loadAddon()
        fontstring = namespace.fontstring
    end)

    it("updates the display when a keystone is available", function()
        --[[
        GIVEN:
            - the fontstring has no keystone info

        WHEN:
            - `fontstring::updateFromApi` is called
            - we have a keystone

        THEN:
            - the fontstring has its text set and shown
        ]]

        local getMapID = stub(
            C_MythicPlus,
            "GetOwnedKeystoneChallengeMapID",
            function() return 100 end
        )
        local getLevel = stub(
            C_MythicPlus,
            "GetOwnedKeystoneLevel",
            function() return 15 end
        )
        local getMapInfo = stub(
            C_ChallengeMode,
            "GetMapUIInfo",
            function() return "The Dungeon" end
        )

        -- Mock the fontstring methods on the instance we have
        local setFormattedText = stub(fontstring, "SetFormattedText")

        finally(function()
            getMapID:revert()
            getLevel:revert()
            getMapInfo:revert()
            setFormattedText:revert()
        end)

        -- Ensure `IsShown` returns `false` initially so `Show` is called.
        fontstring:Hide()

        fontstring:updateFromApi()

        assert.stub(setFormattedText).was_called_with(
            match.is_ref(fontstring),
            "%s (%d)",
            "The Dungeon",
            15
        )
        assert.True(fontstring:IsShown())
    end)

    it("hides the display when no keystone is available", function()
        --[[
        GIVEN:
            - the fontstring has keystone info cached

        WHEN:
            - `fontstring::updateFromApi` is called
            - we no longer have a keystone

        THEN:
            - the fontstring is hidden
        ]]

        local mapId = 100
        local level = 15

        local getMapID = stub(
            C_MythicPlus,
            "GetOwnedKeystoneChallengeMapID",
            function() return mapId end
        )
        local getLevel = stub(
            C_MythicPlus,
            "GetOwnedKeystoneLevel",
            function() return level end
        )

        finally(function()
            getMapID:revert()
            getLevel:revert()
        end)

        fontstring:updateFromApi()

        mapId = nil
        level = nil
        fontstring:updateFromApi()

        assert.False(fontstring:IsShown())
    end)

    it("does not update display if info has not changed", function()
        --[[
        GIVEN:
            - the fontstring has keystone info cached

        WHEN:
            - `fontstring::updateFromApi` is called
            - the keystone info has not changed

        THEN:
            - the fontstring text is not updated again
            - the fontstring is still shown
        ]]

        local getMapID = stub(
            C_MythicPlus,
            "GetOwnedKeystoneChallengeMapID",
            function() return 200 end
        )
        local getLevel = stub(
            C_MythicPlus,
            "GetOwnedKeystoneLevel",
            function() return 10 end
        )

        local setFormattedText = stub(fontstring, "SetFormattedText")

        finally(function()
            getMapID:revert()
            getLevel:revert()
            setFormattedText:revert()
        end)

        fontstring:updateFromApi()
        assert.True(fontstring:IsShown())
        assert.stub(setFormattedText).was_called(1)

        setFormattedText:clear()    -- Clear the spy's history

        fontstring:updateFromApi()

        assert.stub(setFormattedText).was_not_called()
        assert.True(fontstring:IsShown())
    end)

    it("updates the display if the keystone level changes", function()
        --[[
        GIVEN:
            - the fontstring has keystone info cached

        WHEN:
            - `fontstring::updateFromApi` is called
            - the keystone level has changed

        THEN:
            - the fontstring text is updated
            - the fontstring is still shown
        ]]

        local level = 10

        local getMapID = stub(
            C_MythicPlus,
            "GetOwnedKeystoneChallengeMapID",
            function() return 200 end
        )
        local getLevel = stub(
            C_MythicPlus,
            "GetOwnedKeystoneLevel",
            function() return level end
        )

        local setFormattedText = stub(fontstring, "SetFormattedText")

        finally(function()
            getMapID:revert()
            getLevel:revert()
            setFormattedText:revert()
        end)

        fontstring:updateFromApi()
        assert.True(fontstring:IsShown())
        assert.stub(setFormattedText).was_called(1)

        setFormattedText:clear()    -- Clear the spy's history

        level = 9
        fontstring:updateFromApi()

        assert.stub(setFormattedText).was_called(1)
        assert.True(fontstring:IsShown())
    end)
end)
