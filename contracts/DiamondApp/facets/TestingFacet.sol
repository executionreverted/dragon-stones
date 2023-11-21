// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {MAX_POLISH_LEVEL} from "../libraries/GameConstants.sol";
import {CoreBonus, DragonStone, Bonus, CoreDragonStone, StoneTypes} from "../libraries/GameStructs.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";

contract TestingFacet is Modifiers {
    function createStone(uint tokenId) public {
        s.DragonStones[tokenId].OWNER = msg.sender;
        s.DragonStones[tokenId].STONE_TYPE = StoneTypes.RUBY;
        s.DragonStones[tokenId].TIER = 1;
        s.DragonStones[tokenId].POLISH_LEVEL = 0;
        s.DragonStones[tokenId].UPGRADE_LEVEL = 0;

        uint[] memory _bonusesToAdd = new uint[](20);
        _bonusesToAdd[0] = 1;
        s.DragonStones[tokenId].BONUS_IDS = _bonusesToAdd;
    }
}
