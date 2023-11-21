// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";

contract SettingsFacet is Modifiers {
    function setActivePage(uint pageId) external {
        require(
            pageId > 0 &&
                s.PlayerMaxPages[msg.sender] > 0 &&
                pageId <= s.PlayerMaxPages[msg.sender]
        );

        s.ActivePages[msg.sender] = pageId;
    }
}
