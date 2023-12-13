// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {MAX_POLISH_LEVEL} from "../libraries/GameConstants.sol";
import {ActiveStone, CoreBonus, DragonStone, Bonus, CoreDragonStone} from "../libraries/GameStructs.sol";
import {StoneTypes, PlayerAction} from "../libraries/GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";
import {LibIdle} from "../libraries/LibIdle.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {LibPremium} from "../libraries/LibPremium.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";

contract IdlerFacet is Modifiers {
    function beginIdleing() external notPaused onlyRegistered {
        address player = LibMeta.msgSender();
        require(
            s.PlayerState[player].ACTION_STATE == PlayerAction.FREE,
            "IdlerFacet: already idle"
        );
        s.PlayerState[player].ACTION_STATE = PlayerAction.IDLE;
        s.PlayerState[player].ACTION_START = block.timestamp;
    }

    function endIdleing() external notPaused {
        address player = LibMeta.msgSender();
        require(
            s.PlayerState[player].ACTION_STATE == PlayerAction.IDLE,
            "IdlerFacet: not idle"
        );
        uint rewards = calculatePieceReward(player);
        IDragonStonePieces(s.pieces).mintPiece(player, rewards);
        s.PlayerState[player].ACTION_STATE = PlayerAction.FREE;
    }

    // terminate for emergency. no rewards will be given
    function cancelIdleing() external notPaused {
        address player = LibMeta.msgSender();
        require(
            s.PlayerState[player].ACTION_STATE == PlayerAction.IDLE,
            "IdlerFacet: not idle"
        );
        s.PlayerState[player].ACTION_STATE = PlayerAction.FREE;
    }

    function calculatePieceReward(address player) public view returns (uint) {
        (uint premiumTier, , ) = LibPremium.userPremiumStatus(player);
        uint rewards = LibIdle.calculateIdleReward(player);
        if (premiumTier > 0) rewards += rewards / 5;
        return rewards;
    }
}
