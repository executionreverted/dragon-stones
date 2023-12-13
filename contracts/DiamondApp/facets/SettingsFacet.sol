// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {Player} from "../libraries/GameStructs.sol";
import {PlayerAction} from "../libraries/GameEnums.sol";

contract SettingsFacet is Modifiers {
    function setActivePage(
        uint pageId
    ) external notPaused onlyNonEOA onlyRegistered {
        require(
            pageId > 0 &&
                s.PlayerMaxPages[msg.sender] > 0 &&
                pageId <= s.PlayerMaxPages[msg.sender] &&
                s.PlayerState[msg.sender].ACTION_STATE == PlayerAction.FREE,
            "SettingsFacet: invalid facet or player is busy"
        );

        s.ActivePages[msg.sender] = pageId;
    }
}
