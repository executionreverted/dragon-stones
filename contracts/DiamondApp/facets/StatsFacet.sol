// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {WorldBossInventory, WorldBoss, Player, AdventureMap, ActiveStone, CoreBonus, DragonStone, Bonus, CoreDragonStone} from "../libraries/GameStructs.sol";
import {BoostableStats, StoneTypes, PlayerAction, Stats, PlayerAction} from "../libraries/GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";
import {LibSymbol} from "../libraries/LibSymbol.sol";
import {LibRandom} from "../libraries/LibRandom.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {LibAdventure} from "../libraries/LibAdventure.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";
import {LibRewards} from "../libraries/LibRewards.sol";
import {LibLevel} from "../libraries/LibLevel.sol";

contract StatsFacet is Modifiers {
    // to use multiple, param should me like [STR, INT, INT]
    function useStatPoint(
        BoostableStats[] calldata _statPointsToAdd
    ) external onlyRegistered onlyNonEOA {
        address player = LibMeta.msgSender();
        uint pointsLeft = playerStatPoints(player);
        require(
            _statPointsToAdd.length <= pointsLeft,
            "StatsFacet: not enough points"
        );
        for (uint i = 0; i < _statPointsToAdd.length; i++) {
            s.PlayerState[player].STATS[uint(_statPointsToAdd[i]) + 1]++;
        }
        s.PlayerState[player].USED_STAT_POINTS += _statPointsToAdd.length;
    }

    function playerStatPoints(address player) public view returns (uint) {
        uint statPoints = 5 + s.PlayerState[player].LEVEL * 5;
        uint used = usedPlayerStatPoints(player);
        return statPoints - used;
    }

    function usedPlayerStatPoints(address player) public view returns (uint) {
        return s.PlayerState[player].USED_STAT_POINTS;
    }
}
