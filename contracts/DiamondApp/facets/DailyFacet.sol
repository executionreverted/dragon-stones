// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {BASE_DAILY_REWARD} from "../libraries/GameConstants.sol";
import {ActiveStone, CoreBonus, DragonStone, Bonus, CoreDragonStone} from "../libraries/GameStructs.sol";
import {StoneTypes, PlayerAction} from "../libraries/GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";

contract DailyFacet is Modifiers {
    function claimIdleRewards() external onlyRegistered {
        require(
            block.timestamp >=
                s.PlayerState[LibMeta.msgSender()].DAILY_CLAIM + 23 hours,
            "DailyFacet: too early"
        );
        IDragonStonePieces(s.pieces).mintPiece(
            LibMeta.msgSender(),
            BASE_DAILY_REWARD
        );
        s.PlayerState[LibMeta.msgSender()].DAILY_CLAIM = block.timestamp;
    }

    function lastDailyClaim(address player) public view returns (uint) {
        return s.PlayerState[player].DAILY_CLAIM;
    }
}
