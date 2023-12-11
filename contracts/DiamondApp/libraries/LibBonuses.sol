// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "../../shared/interfaces/IERC20.sol";
import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {LibERC20} from "../../shared/libraries/LibERC20.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IERC721} from "../../shared/interfaces/IERC721.sol";
import {LibERC721} from "../../shared/libraries/LibERC721.sol";
import {Bonus, CoreBonus} from "../libraries/GameStructs.sol";
import {BonusValueType, Stats, StoneTypes} from "../libraries/GameEnums.sol";

library LibBonuses {

    function getBonusPool(
        StoneTypes stoneType
    ) internal pure returns (uint[] memory) {
        // ruby pool: 1,2 7 8 11 12 21 22

        if (stoneType == StoneTypes.RUBY) {
            uint[] memory rubyBonuses = new uint[](8);
            rubyBonuses[0] = 1;
            rubyBonuses[1] = 2;
            rubyBonuses[2] = 7;
            rubyBonuses[3] = 8;
            rubyBonuses[4] = 11;
            rubyBonuses[5] = 12;
            rubyBonuses[6] = 21;
            rubyBonuses[7] = 22;
            return rubyBonuses;
        }
        // emerald pool: 3 4 26 27 35 37

        if (stoneType == StoneTypes.EMERALD) {
            uint[] memory emeraldBonuses = new uint[](6);
            emeraldBonuses[0] = 3;
            emeraldBonuses[1] = 4;
            emeraldBonuses[2] = 26;
            emeraldBonuses[3] = 27;
            emeraldBonuses[4] = 35;
            emeraldBonuses[5] = 37;
            return emeraldBonuses;
        }
        // sapphire pool: 5 6 13 14 18 22 23

        if (stoneType == StoneTypes.SAPPHIRE) {
            uint[] memory sapphireBonuses = new uint[](7);
            sapphireBonuses[0] = 5;
            sapphireBonuses[1] = 6;
            sapphireBonuses[2] = 13;
            sapphireBonuses[3] = 14;
            sapphireBonuses[4] = 18;
            sapphireBonuses[5] = 22;
            sapphireBonuses[6] = 23;
            return sapphireBonuses;
        }

        // amber pool: 7 8 24 25 34 36

        if (stoneType == StoneTypes.AMBER) {
            uint[] memory amberBonuses = new uint[](6);
            amberBonuses[0] = 7;
            amberBonuses[1] = 8;
            amberBonuses[2] = 24;
            amberBonuses[3] = 25;
            amberBonuses[4] = 34;
            amberBonuses[5] = 36;
            return amberBonuses;
        }

        // amethyst pool: 13 15 16 17 30 31

        if (stoneType == StoneTypes.AMETHYST) {
            uint[] memory amethystBonuses = new uint[](6);
            amethystBonuses[0] = 13;
            amethystBonuses[1] = 15;
            amethystBonuses[2] = 16;
            amethystBonuses[3] = 17;
            amethystBonuses[4] = 30;
            amethystBonuses[5] = 31;
            return amethystBonuses;
        }

        // diamond pool: 9 10 18 19 28 29 32 33 36
        if (stoneType == StoneTypes.DIAMOND) {
            uint[] memory diamondBonuses = new uint[](9);
            diamondBonuses[0] = 9;
            diamondBonuses[1] = 10;
            diamondBonuses[2] = 18;
            diamondBonuses[3] = 19;
            diamondBonuses[4] = 28;
            diamondBonuses[5] = 29;
            diamondBonuses[6] = 32;
            diamondBonuses[7] = 33;
            diamondBonuses[8] = 36;
            return diamondBonuses;
        }

        if (stoneType == StoneTypes.COSMIC) {
            uint[] memory cosmicBonuses = new uint[](uint(type(Stats).max));
            for (uint i = 1; i <= cosmicBonuses.length; i++) {
                cosmicBonuses[i - 1] = i;
            }
            return cosmicBonuses;
        }

        revert("invalid stone type");
    }

    function getCoreBonus(
        uint bonusId
    ) internal pure returns (CoreBonus memory _bonus) {
        /*
            BonusType BONUS_TYPE;
            BonusValueType BONUS_VALUE_TYPE;
            Stats BONUS_STAT;
            uint BONUS_VALUE_TIER_INCREMENTAL;
            uint VALUE;
        */
        // diamond pool: 9 10 18 19 28 29 32 33 36
        if (bonusId == 1) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.STR;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 2) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.STR;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 5;
        } else if (bonusId == 3) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.DEX;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 4) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.DEX;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 5;
        } else if (bonusId == 5) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.WIS;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 6) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.WIS;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 5;
        } else if (bonusId == 7) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.VIT;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 8) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.VIT;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 5;
        } else if (bonusId == 9) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.LUK;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 10) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.LUK;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 5;
        } else if (bonusId == 11) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 20;
            _bonus.BONUS_STAT = Stats.HP;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 100;
        } else if (bonusId == 12) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.HP;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 5;
        } else if (bonusId == 13) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 10;
            _bonus.BONUS_STAT = Stats.SP;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 50;
        } else if (bonusId == 14) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.SP;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 5;
        } else if (bonusId == 15) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.ALL_STATS;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 5;
        } else if (bonusId == 16) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.DAMAGE;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 50;
        } else if (bonusId == 17) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 2;
            _bonus.BONUS_STAT = Stats.DAMAGE;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 18) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.DEF;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 50;
        } else if (bonusId == 19) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.DEF;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 20) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.FIRE_RES;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 50;
        } else if (bonusId == 21) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.FIRE_RES;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 22) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.COLD_RES;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 50;
        } else if (bonusId == 23) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.COLD_RES;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 24) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.LIGHTNING_RES;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 50;
        } else if (bonusId == 25) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.LIGHTNING_RES;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 26) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.NATURE_RES;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 50;
        } else if (bonusId == 27) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.NATURE_RES;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 28) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.HOLY_RES;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 50;
        } else if (bonusId == 29) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.HOLY_RES;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 30) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.DARK_RES;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 50;
        } else if (bonusId == 31) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.DARK_RES;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 32) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.ALL_RES;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 50;
        } else if (bonusId == 33) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.ALL_RES;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 34) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.CHANCE_TO_DOUBLE_CLAIM;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 20;
        } else if (bonusId == 35) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.MULTIKILL;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 36) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.LOOT_BONUS;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 37) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.FASTER_CYCLES;
            _bonus.BONUS_MIN_EFF = 50;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 5;
        } else {
            revert("INVALID_BONUS_ID");
        }
    }

    function getBonus(
        uint bonusId,
        uint tier,
        uint polish,
        uint upgradeLevel,
        uint efficiency
    ) internal pure returns (Bonus memory bonus) {
        /*
            BonusType BONUS_TYPE;
            BonusValueType BONUS_VALUE_TYPE;
            Stats BONUS_STAT;
            uint BONUS_VALUE_TIER_INCREMENTAL;
            uint VALUE;
        */
        if (bonusId == 0) return bonus;
        CoreBonus memory coreBonus = getCoreBonus(bonusId);
        bonus.BONUS_VALUE_TYPE = coreBonus.BONUS_VALUE_TYPE;
        bonus.BONUS_STAT = coreBonus.BONUS_STAT;
        uint tierBonus = (coreBonus.BONUS_VALUE_TIER_INCREMENTAL *
            tier *
            efficiency) / 100;
        uint polishBonus = (coreBonus.BONUS_VALUE_TIER_INCREMENTAL *
            polish *
            efficiency) / 100;
        uint upgradeBonus = ((coreBonus.BONUS_VALUE_TIER_INCREMENTAL *
            upgradeLevel *
            efficiency) / 100) / 2;

        bonus.VALUE += (coreBonus.VALUE * efficiency) / 100;
        if (polishBonus > 0) {
            bonus.VALUE += tierBonus * (polishBonus / 2);
        } else {
            bonus.VALUE += tierBonus;
        }

        bonus.VALUE += upgradeBonus;
        bonus.BONUS_EFF = efficiency;
    }
}
