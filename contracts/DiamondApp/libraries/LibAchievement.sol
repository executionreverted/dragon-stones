// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {Achievement} from "./GameStructs.sol";
import {Currencies} from "./GameEnums.sol";

library LibAchievement {
    function achivements() external view returns (Achievement[] memory) {}

    function achievement(uint id) public pure returns (Achievement memory ach) {
        if (id == 1) {
            // Hello World! Reach level 2
            ach.REQUIRED_LEVEL = 2;
            ach.REWARD_1 = Currencies.GOLD;
            ach.REWARD_AMOUNT_1 = 100e18;
            ach.REWARD_2 = Currencies.PIECE;
            ach.REWARD_AMOUNT_2 = 100e18;
        }
    }
}
