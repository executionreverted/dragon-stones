// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {BASE_DAILY_REWARD} from "../libraries/GameConstants.sol";
import {StoneTypes, PlayerAction, Stats} from "../libraries/GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";
import {LibSymbol} from "../libraries/LibSymbol.sol";
import {LibRandom} from "../libraries/LibRandom.sol";
import {LibPremium} from "../libraries/LibPremium.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";

contract DailyFacet is Modifiers {
    function claimDaily() external notPaused onlyRegistered {
        address player = LibMeta.msgSender();
        require(
            block.timestamp >= s.PlayerState[player].DAILY_CLAIM + 23 hours,
            "DailyFacet: too early"
        );

        uint mult = rewardMult(player);
        (uint premiumTier, , ) = LibPremium.userPremiumStatus(player);
        if (premiumTier > 0) mult *= 2;

        IDragonStonePieces(s.pieces).mintPiece(
            player,
            BASE_DAILY_REWARD * mult
        );
        
        s.PlayerState[player].DAILY_CLAIM = block.timestamp;
    }

    function lastDailyClaim(address player) public view returns (uint) {
        return s.PlayerState[player].DAILY_CLAIM;
    }

    function rewardMult(address player) internal view returns (uint) {
        int[] memory stats = LibSymbol.getPlayerStats(player);
        uint premult = 1;
        int chanceToDouble = stats[uint(Stats.CHANCE_TO_DOUBLE_CLAIM)];
        if (chanceToDouble == 100) return premult + 1;
        if (chanceToDouble == 0) return premult;
        if (chanceToDouble > 100) {
            premult = premult + uint(chanceToDouble) / 100;
            chanceToDouble %= 100;
            uint roll = LibRandom.d100(block.number + block.timestamp);
            if (roll < uint(chanceToDouble)) {
                premult++;
            }
        } else {
            uint roll = LibRandom.d100(block.number + block.timestamp);
            if (roll < uint(chanceToDouble)) {
                premult++;
            }
        }

        return premult;
    }
}
