// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {Achievement} from "./GameStructs.sol";
import {Currencies} from "./GameEnums.sol";

library LibAdventure {
    function achivements() external view returns (Achievement[] memory) {}

    function achievement(uint id) public view returns (Achievement memory ach) {
        if (id == 1) {
            // Hello World!
            ach.REWARD_1 = Currencies.GOLD;
            ach.REWARD_AMOUNT_1 = 100e18;
        }
    }
}
