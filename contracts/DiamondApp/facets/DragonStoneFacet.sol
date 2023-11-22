// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {MAX_POLISH_LEVEL} from "../libraries/GameConstants.sol";
import {ActiveStone, CoreBonus, DragonStone, Bonus, CoreDragonStone} from "../libraries/GameStructs.sol";
import {StoneTypes} from "../libraries/GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";

contract DragonStoneFacet is Modifiers {
    function getDragonStoneData(
        uint tokenId
    ) external view returns (ActiveStone memory) {
        return LibDragonStones.getDragonStoneData(tokenId);
    }

    function getDragonStone(
        uint tokenId
    ) public view returns (DragonStone memory) {
        return LibDragonStones.getDragonStone(tokenId);
    }

    function getDragonStones(
        uint[] calldata tokenIds
    ) public view returns (DragonStone[] memory) {
        DragonStone[] memory result = new DragonStone[](tokenIds.length);
        for (uint i = 0; i < tokenIds.length; i++) {
            result[i] = LibDragonStones.getDragonStone(tokenIds[i]);
        }
        return result;
    }

    function getRawDragonStone(
        uint tokenId
    ) public view returns (CoreDragonStone memory dragonStone) {
        return s.DragonStones[tokenId];
    }

    function getRawDragonStones(
        uint[] calldata tokenIds
    ) public view returns (CoreDragonStone[] memory) {
        CoreDragonStone[] memory result = new CoreDragonStone[](
            tokenIds.length
        );
        for (uint i = 0; i < tokenIds.length; i++) {
            result[i] = s.DragonStones[tokenIds[i]];
        }
        return result;
    }

    function getBonusPools(
        StoneTypes stoneType
    ) external pure returns (uint[] memory) {
        return LibBonuses.getBonusPool(stoneType);
    }
}
