// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {Player} from "./GameStructs.sol";
import {PlayerAction, Stats} from "./GameEnums.sol";
import {BASE_EXP} from "./GameConstants.sol";

// import {LibMeta} from "../../shared/libraries/LibMeta.sol";
library LibStats {
    function setStatVal(address player, Stats stat, int val) internal {
        AppStorage storage s = LibAppStorage.diamondStorage();
        if (s.PlayerState[player].STATS.length != uint(type(Stats).max)) {
            s.PlayerState[player].STATS = new int[](uint(type(Stats).max));
        }
        s.PlayerState[player].STATS[uint(stat)] = val;
    }
}
