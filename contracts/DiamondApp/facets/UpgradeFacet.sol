// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {MAX_UPGRADE_LEVEL} from "../libraries/GameConstants.sol";

contract UpgradeFacet is Modifiers {
    function upgrade() external {}

    function upgradeChance(uint nextUpgradeLevel) internal pure returns (uint) {
        require(nextUpgradeLevel < MAX_UPGRADE_LEVEL, "CAN'T UPGRADE ANYMORE");
        uint8[10] memory UPGRADE_CHANCES = [
            75,
            60,
            50,
            40,
            30,
            20,
            15,
            10,
            5,
            1
        ];
        if (nextUpgradeLevel > 10) return 1;
        return UPGRADE_CHANCES[nextUpgradeLevel];
    }
}
