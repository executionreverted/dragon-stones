// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {IERC20} from "../../shared/interfaces/IERC20.sol";
import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {LibERC20} from "../../shared/libraries/LibERC20.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IERC721} from "../../shared/interfaces/IERC721.sol";
import {LibERC721} from "../../shared/libraries/LibERC721.sol";
import {Bonus, CoreBonus} from "../libraries/GameStructs.sol";
import {BonusType, BonusValueType, Stats} from "../libraries/GameEnums.sol";

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
        if (bonusId == 0) {
            // EMPTY!
        } else if (bonusId == 1) {
            _bonus.BONUS_TYPE = BonusType.INCREASE;
            _bonus.BONUS_VALUE_TYPE = BonusValueType.FLAT;
            _bonus.BONUS_VALUE_TIER_INCREMENTAL = 1;
            _bonus.BONUS_STAT = Stats.STR;
            _bonus.VALUE = 5;
        } else {
            revert("INVALID_BONUS_ID");
        }
    }

    function getBonus(
        uint bonusId,
        uint tier
    ) internal pure returns (Bonus memory bonus) {
        /*
            BonusType BONUS_TYPE;
            BonusValueType BONUS_VALUE_TYPE;
            Stats BONUS_STAT;
            uint BONUS_VALUE_TIER_INCREMENTAL;
            uint VALUE;
        */
        CoreBonus memory coreBonus = getCoreBonus(bonusId);
        bonus.BONUS_TYPE = coreBonus.BONUS_TYPE;
        bonus.BONUS_STAT = coreBonus.BONUS_STAT;
        bonus.VALUE =
            coreBonus.VALUE +
            (coreBonus.BONUS_VALUE_TIER_INCREMENTAL * tier);
    }
}
