// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {Player} from "../libraries/GameStructs.sol";
import {PlayerAction} from "../libraries/GameEnums.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";

contract SettingsFacet is Modifiers {
    function setActivePage(
        uint pageId
    ) external notPaused onlyNonEOA onlyRegistered {
        address player = LibMeta.msgSender();
        require(
            pageId > 0 &&
                s.PlayerMaxPages[player] > 0 &&
                pageId <= s.PlayerMaxPages[player] &&
                s.PlayerState[player].ACTION_STATE == PlayerAction.FREE,
            "SettingsFacet: invalid facet or player is busy"
        );

        s.ActivePages[msg.sender] = pageId;
    }

    function setProfilePicture(
        uint pictureId
    ) external notPaused onlyNonEOA onlyRegistered {
        require(pictureId <= s.maxProfilePictureId, "SettingsFacet: invalid picture id");
        address player = LibMeta.msgSender();
        s.PlayerState[player].PROFILE_PICTURE = pictureId;
    }
}
