// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {MAX_POLISH_LEVEL} from "../libraries/GameConstants.sol";
import {ActiveStone, CoreBonus, DragonStone, Bonus, CoreDragonStone} from "../libraries/GameStructs.sol";
import {StoneTypes, PlayerAction} from "../libraries/GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";
import {LibPrayer} from "../libraries/LibPrayer.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IDragonStoneBlessing} from "../erc20/IDragonStoneBlessing.sol";

contract PrayerFacet is Modifiers {
    function beginPraying() external onlyRegistered {
        require(
            s.PlayerState[LibMeta.msgSender()].ACTION_STATE ==
                PlayerAction.FREE,
            "PrayerFacet: already praying"
        );
        s.PlayerState[LibMeta.msgSender()].ACTION_STATE = PlayerAction.PRAYER;
        s.PlayerState[LibMeta.msgSender()].ACTION_START = block.timestamp;
    }

    function endPraying() external {
        require(
            s.PlayerState[LibMeta.msgSender()].ACTION_STATE ==
                PlayerAction.PRAYER,
            "PrayerFacet: not praying"
        );
        // require(
        //     block.timestamp >=
        //         s.PlayerState[LibMeta.msgSender()].ACTION_DEADLINE,
        //     "PrayrFacet: too early"
        // );
        uint rewards = calculatePrayerReward(LibMeta.msgSender());
        IDragonStoneBlessing(s.blessings).mintBlessing(
            LibMeta.msgSender(),
            rewards
        );
        s.PlayerState[LibMeta.msgSender()].ACTION_STATE = PlayerAction.FREE;
    }

    function cancelPraying() external {
        require(
            s.PlayerState[LibMeta.msgSender()].ACTION_STATE ==
                PlayerAction.PRAYER,
            "PrayerFacet: not praying"
        );
        s.PlayerState[LibMeta.msgSender()].ACTION_STATE = PlayerAction.FREE;
    }

    function calculatePrayerReward(address player) public view returns (uint) {
        return LibPrayer.calculatePrayerReward(player);
    }
}
