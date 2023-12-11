// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {WorldBossInventory, WorldBoss, Player, AdventureMap, ActiveStone, CoreBonus, DragonStone, Bonus, CoreDragonStone} from "../libraries/GameStructs.sol";
import {StoneTypes, PlayerAction, Stats, PlayerAction} from "../libraries/GameEnums.sol";
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
        Stats[] memory _statPointsToAdd
    ) external onlyRegistered onlyNonEOA {}
}
