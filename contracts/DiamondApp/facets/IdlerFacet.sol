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
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";

contract IdlerFacet is Modifiers {
    function beginIdleing() external onlyRegistered {
        require(
            s.PlayerState[LibMeta.msgSender()].ACTION_STATE ==
                PlayerAction.FREE,
            "IdlerFacet: already idle"
        );
        s.PlayerState[LibMeta.msgSender()].ACTION_STATE = PlayerAction.IDLE;
        s.PlayerState[LibMeta.msgSender()].ACTION_START = block.timestamp;
    }

    function endIdleing() external {
        require(
            s.PlayerState[LibMeta.msgSender()].ACTION_STATE ==
                PlayerAction.IDLE,
            "IdlerFacet: not idle"
        );
        uint rewards = calculatePieceReward(LibMeta.msgSender());
        IDragonStonePieces(s.pieces).mintPiece(LibMeta.msgSender(), rewards);
        s.PlayerState[LibMeta.msgSender()].ACTION_STATE = PlayerAction.FREE;
    }

    function cancelIdleing() external {
        require(
            s.PlayerState[LibMeta.msgSender()].ACTION_STATE ==
                PlayerAction.IDLE,
            "IdlerFacet: not idle"
        );
        s.PlayerState[LibMeta.msgSender()].ACTION_STATE = PlayerAction.FREE;
    }

    function calculatePieceReward(address player) public view returns (uint) {
        return LibIdle.calculateIdleReward(player);
    }
}
