// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {MAX_POLISH_LEVEL, MAX_STONE_BONUS_COUNT} from "../libraries/GameConstants.sol";
import {Player, CoreBonus, DragonStone, Bonus, CoreDragonStone} from "../libraries/GameStructs.sol";
import {Stats} from "../libraries/GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";
import {LibRandom} from "../libraries/LibRandom.sol";
import {LibIdle} from "../libraries/LibIdle.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";

contract TestFacetV3 is Modifiers {
    function test3(uint abc) external pure returns (string memory) {
        return "Hello world";
    }
}
