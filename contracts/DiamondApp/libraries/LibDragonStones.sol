// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.23;
import {ActiveStone, CoreBonus, DragonStone, Bonus, CoreDragonStone} from "./GameStructs.sol";
import {LibBonuses} from "./LibBonuses.sol";
import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {StoneTypes} from "./GameEnums.sol";

library LibDragonStones {
    function getDragonStoneData(
        uint tokenId
    ) internal view returns (ActiveStone memory) {
        AppStorage storage s = LibAppStorage.diamondStorage();
        return s.ActiveStones[tokenId];
    }

    function getStoneType(uint tokenId) internal view returns (StoneTypes) {
        AppStorage storage s = LibAppStorage.diamondStorage();
        return s.DragonStones[tokenId].STONE_TYPE;
    }

    function getDragonStone(
        uint tokenId
    ) internal view returns (DragonStone memory) {
        AppStorage storage s = LibAppStorage.diamondStorage();

        CoreDragonStone memory core = s.DragonStones[tokenId];

        /*  BonusType BONUS_TYPE;
            BonusValueType BONUS_VALUE_TYPE;
            Stats BONUS_STAT;
            uint VALUE;
            uint[50] __RESERVED__; 
        */
        Bonus[] memory bonuses = new Bonus[](20);
        for (uint i = 0; i < core.BONUS_IDS.length; i++) {
            if (core.BONUS_IDS[i] == 0) continue;
            bonuses[i] = LibBonuses.getBonus(core.BONUS_IDS[i], core.TIER);
        }

        /*  address OWNER;
            StoneTypes STONE_TYPE;
            uint TIER;
            uint POLISH_LEVEL;
            uint UPGRADE_LEVEL;
            Bonus[20] BONUS;
            uint[50] __RESERVED; */
        DragonStone memory dragonStone;
        dragonStone.OWNER = core.OWNER;
        dragonStone.STONE_TYPE = core.STONE_TYPE;
        dragonStone.TIER = core.TIER;
        dragonStone.POLISH_LEVEL = core.POLISH_LEVEL;
        dragonStone.BONUS = bonuses;

        return dragonStone;
    }

    function getRawDragonStone(
        uint tokenId
    ) internal view returns (CoreDragonStone memory dragonStone) {
        AppStorage storage s = LibAppStorage.diamondStorage();
        return s.DragonStones[tokenId];
    }
}
