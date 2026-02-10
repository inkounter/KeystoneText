# State Machine

As is natural with WoW's event API, this addon follows a state machine:

```mermaid
flowchart TD
    start((start)) -->|ADDON_LOADED|hasKeystoneCheck{"Has keystone?"}
    hasKeystoneCheck -->|yes|hasKeystone
    hasKeystoneCheck -->|no|hasNoKeystone
    hasKeystone -->|CHALLENGE_MODE_START<br>CHALLENGE_MODE_COMPLETED<br>ITEM_CHANGED|hasKeystone
    hasNoKeystone -->|BAG_UPDATE_DELAYED<br>CHALLENGE_MODE_START<br>CHALLENGE_MODE_COMPLETED<br>ITEM_CHANGED|hasKeystoneCheck
    hasKeystone -->|weekly reset occurred|hasKeystoneCheck
```

Not included in the above state machine is handling of
`CHALLENGE_MODE_MAPS_UPDATE`, which prompts a keystone check and -- regardless
of the result -- unregisters from `CHALLENGE_MODE_MAPS_UPDATE`.

Also note that while the addon does persistently listen for
`CHALLENGE_MODE_START`, `CHALLENGE_MODE_COMPLETED`, and `ITEM_CHANGED` events,
the only event that realistically matters in the `hasNoKeystone` state is
`BAG_UPDATE_DELAYED`.
