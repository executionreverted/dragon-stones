// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {Player} from "./GameStructs.sol";
import {PlayerAction} from "./GameEnums.sol";
import {BASE_EXP} from "./GameConstants.sol";

// import {LibMeta} from "../../shared/libraries/LibMeta.sol";
library LibLevel {
    function levelUp(address player) internal {
        AppStorage storage s = LibAppStorage.diamondStorage();
        s.PlayerState[player].LEVEL++;
    }

    function giveExp(address player, uint exp) internal {
        AppStorage storage s = LibAppStorage.diamondStorage();
        s.PlayerState[player].EXP += exp;
        // check if lvl up

        uint $requiredXP = requiredXP(s.PlayerState[player].LEVEL);
        if (s.PlayerState[player].EXP >= $requiredXP) {
            levelUp(player);
            s.PlayerState[player].EXP = s.PlayerState[player].EXP % $requiredXP;
        }
    }

    function requiredXP(uint level) internal pure returns (uint _xp) {
        return level * BASE_EXP;
    }
}
