// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {Player} from "./GameStructs.sol";
import {PlayerAction} from "./GameEnums.sol";
import {BASE_CYCLE} from "./GameConstants.sol";

// import {LibMeta} from "../../shared/libraries/LibMeta.sol";
library LibPrayer {
    function calculatePrayerRewardCycle(
        address player
    ) internal view returns (uint) {
        AppStorage storage s = LibAppStorage.diamondStorage();
        if (s.PlayerState[player].ACTION_STATE != PlayerAction.PRAYER) return 0;
        require(
            s.PlayerState[player].ACTION_STATE == PlayerAction.PRAYER,
            "LibPrayer: not praying"
        );

        uint timePassed = block.timestamp - s.PlayerState[player].ACTION_START;
        // implement cycle time reductions and stuff later.
        uint rewardCycles = (timePassed / (BASE_CYCLE * 20));

        return rewardCycles;
    }

    function calculatePrayerReward(
        address player
    ) internal view returns (uint) {
        return calculatePrayerRewardCycle(player) * 1e18;
    }
}
