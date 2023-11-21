// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "../../shared/interfaces/IERC20.sol";
import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {LibERC20} from "../../shared/libraries/LibERC20.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IERC721} from "../../shared/interfaces/IERC721.sol";
import {LibERC721} from "../../shared/libraries/LibERC721.sol";
import {Bonus, CoreBonus} from "../libraries/GameStructs.sol";
import {BonusValueType, Stats} from "../libraries/GameEnums.sol";

library LibBonuses {
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
        if (bonusId == 1) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 5;
            _bonus.BONUS_STAT = Stats.STR;
            _bonus.BONUS_MIN_EFF = 30;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 10;
        } else if (bonusId == 2) {
            _bonus.BONUS_VALUE_TYPE = BonusValueType.PERCENTAGE;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 50;
            _bonus.BONUS_STAT = Stats.STR;
            _bonus.BONUS_MIN_EFF = 30;
            _bonus.BONUS_MAX_EFF = 150;
            _bonus.VALUE = 50;
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
    }
}
