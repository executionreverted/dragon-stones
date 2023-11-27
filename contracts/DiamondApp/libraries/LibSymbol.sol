// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {Bonus, DragonStone} from "./GameStructs.sol";
import {BonusValueType, Stats, StoneTypes} from "./GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";

// import {LibMeta} from "../../shared/libraries/LibMeta.sol";
library LibSymbol {
    function getPage(
        address player,
        uint pageId
    ) internal view returns (DragonStone[] memory) {
        AppStorage storage s = LibAppStorage.diamondStorage();
        uint implementedSlots = uint(type(StoneTypes).max);
        DragonStone[] memory result = new DragonStone[](implementedSlots);
        for (uint i = 0; i < implementedSlots; i++) {
            result[i] = LibDragonStones.getDragonStone(
                s.Pages[player][pageId][i]
            );
        }
        return result;
    }

    function getPlayerStats(
        address player
    ) internal view returns (int[] memory) {
        AppStorage storage s = LibAppStorage.diamondStorage();

        int[] memory percBoosts = new int[](uint(type(Stats).max));
        int[] memory userStats = new int[](uint(type(Stats).max));

        DragonStone[] memory stones = getPage(player, s.ActivePages[player]);

        for (uint x = 0; x < stones.length; x++) {
            for (uint y = 0; y < stones[x].BONUS.length; y++) {
                Bonus memory bonus = stones[x].BONUS[y];
                BonusValueType bonusValueType = bonus.BONUS_VALUE_TYPE;
                // stat type : userStats[stones[x].BONUS.BonusStat];
                if (bonusValueType == BonusValueType.FLAT) {
                    userStats[uint(bonus.BONUS_STAT)] += int(bonus.VALUE);
                } else {
                    percBoosts[uint(bonus.BONUS_STAT)] += int(bonus.VALUE);
                }
            }
        }

        for (uint i = 0; i < percBoosts.length; i++) {
            userStats[i] =
                userStats[i] +
                ((userStats[i] * (percBoosts[i])) / 100);
        }

        return userStats;
    }
}
