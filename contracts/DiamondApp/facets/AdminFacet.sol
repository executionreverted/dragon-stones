// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";

contract AdminFacet is Modifiers {
    function setMaxProfilePictureId(uint id) external onlyDiamondOwner {
        s.maxProfilePictureId = id;
    }
}
