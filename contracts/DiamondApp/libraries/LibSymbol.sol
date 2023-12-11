// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {Bonus, DragonStone} from "./GameStructs.sol";
import {BonusValueType, Stats, StoneTypes} from "./GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";
import "hardhat/console.sol";

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
        int[] memory percBoosts = new int[](uint(type(Stats).max) + 1);
        int[] memory userStats = s.PlayerState[player].STATS;
        int[] memory base = playerBaseStats();
        for (uint i = 0; i < userStats.length; i++) {
            userStats[i] += base[i];
        }

        if (userStats.length != uint(type(Stats).max) + 1)
            userStats = new int[](uint(type(Stats).max) + 1);
        uint tierSetBonus;
        DragonStone[] memory stones = getPage(player, s.ActivePages[player]);

        for (uint x = 0; x < stones.length; x++) {
            for (uint y = 0; y < stones[x].BONUS.length; y++) {
                tierSetBonus = stones[x].TIER;
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

        for (uint i = 1; i < userStats.length; i++) {
            userStats[i] += ((userStats[i] * (percBoosts[i])) / 100);
        }

        return applySetBonus(tierSetBonus, userStats);
    }

    function applySetBonus(
        uint minTier,
        int[] memory stats
    ) internal pure returns (int[] memory) {
        int tier = int(minTier);
        int allResBonus = stats[uint(Stats.ALL_RES)];
        int allStatsBonus = stats[uint(Stats.ALL_STATS)];
        int dmgBonus;

        if (tier > 0) {
            allStatsBonus += (tier * 2);
            allResBonus += (tier * 2);
            dmgBonus = tier * 5;
        }

        if (allStatsBonus > 0) {
            for (uint i = 0; i < stats.length; i++) {
                if (i == uint(Stats.ALL_STATS) || i == uint(Stats.ALL_RES)) {
                    continue;
                }
                stats[i] += ((stats[i] * allStatsBonus) / 100);
            }
        }
        if (allResBonus > 0) {
            // between 10 and 16 is defenses
            for (uint i = 10; i <= 15; i++) {
                stats[i] += ((stats[i] * allResBonus) / 100);
            }
        }

        stats = applyBasicStats(stats);

        if (dmgBonus > 0) {
            stats[uint(Stats.DAMAGE)] +=
                (stats[uint(Stats.DAMAGE)] * dmgBonus) /
                100;
        }

        return stats;
    }

    function applyBasicStats(
        int[] memory stats
    ) internal pure returns (int[] memory) {
        stats[uint(Stats.DAMAGE)] += stats[uint(Stats.STR)];
        stats[uint(Stats.HP)] += stats[uint(Stats.VIT)] * 2;
        stats[uint(Stats.SP)] += stats[uint(Stats.WIS)] * 2;
        stats[uint(Stats.MULTIKILL)] += stats[uint(Stats.DEX)] / 3;
        stats[uint(Stats.LOOT_BONUS)] += stats[uint(Stats.LUK)] / 4;
        return stats;
    }

    function playerBaseStats() internal pure returns (int[] memory) {
        int[] memory base = new int[](uint(type(Stats).max) + 1);
        base[uint(Stats.DAMAGE)] = 5;
        base[uint(Stats.HP)] = 10;
        base[uint(Stats.SP)] = 20;
        base[uint(Stats.DEF)] = 10;
        return base;
    }
}
