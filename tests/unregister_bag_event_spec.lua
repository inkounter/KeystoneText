require("tests.helpers")

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
        "doesn't unregister from `BAG_UPDATE_DELAYED` if we don't have a keystone",
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
