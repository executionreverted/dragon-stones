// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {PlayerAction} from "../libraries/GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";
import {LibPrayer} from "../libraries/LibPrayer.sol";
import {LibPremium} from "../libraries/LibPremium.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IDragonStoneBlessing} from "../erc20/IDragonStoneBlessing.sol";

contract PrayerFacet is Modifiers {
    function beginPraying() external notPaused onlyRegistered {
        address player = LibMeta.msgSender();
        require(
            s.PlayerState[player].ACTION_STATE == PlayerAction.FREE,
            "PrayerFacet: already praying"
        );
        s.PlayerState[player].ACTION_STATE = PlayerAction.PRAYER;
        s.PlayerState[player].ACTION_START = block.timestamp;
    }

    function endPraying() external notPaused {
        address player = LibMeta.msgSender();
        require(
            s.PlayerState[player].ACTION_STATE == PlayerAction.PRAYER,
            "PrayerFacet: not praying"
        );
        // require(
        //     block.timestamp >=
        //         s.PlayerState[LibMeta.msgSender()].ACTION_DEADLINE,
        //     "PrayerFacet: too early"
        // );
        uint rewards = calculatePrayerReward(player);
        IDragonStoneBlessing(s.blessings).mintBlessing(player, rewards);
        s.PlayerState[player].PRAYER_HOURS +=
            block.timestamp -
            s.PlayerState[player].ACTION_START;
        s.PlayerState[player].ACTION_STATE = PlayerAction.FREE;
    }

    function cancelPraying() external notPaused {
        address player = LibMeta.msgSender();
        require(
            s.PlayerState[player].ACTION_STATE == PlayerAction.PRAYER,
            "PrayerFacet: not praying"
        );
        s.PlayerState[player].ACTION_STATE = PlayerAction.FREE;
    }

    function calculatePrayerReward(address player) public view returns (uint) {
        (uint premiumTier, , ) = LibPremium.userPremiumStatus(player);
        uint rewards = LibPrayer.calculatePrayerReward(player);
        if (premiumTier > 0) rewards += rewards / 5;
        return rewards;
    }
}
