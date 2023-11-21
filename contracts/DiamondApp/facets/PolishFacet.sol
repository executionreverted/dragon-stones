// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {MAX_POLISH_LEVEL} from "../libraries/GameConstants.sol";

contract PolishFacet is Modifiers {
    function polish(uint tokenId) external {}

    function polishChance(uint nextPolishLevel) internal pure returns (uint) {
        require(nextPolishLevel < MAX_POLISH_LEVEL, "CAN'T POLISH ANYMORE");
        uint8[10] memory POLISH_CHANCES = [
            55,
            50,
            45,
            40,
            35,
            30,
            25,
            20,
            15,
            10
        ];
        return POLISH_CHANCES[nextPolishLevel];
    }
}
