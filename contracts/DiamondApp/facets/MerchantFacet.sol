// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {MAX_POLISH_LEVEL} from "../libraries/GameConstants.sol";
import {ActiveStone, CoreBonus, DragonStone, Bonus, CoreDragonStone, Offer} from "../libraries/GameStructs.sol";
import {StoneTypes, PlayerAction, Currencies} from "../libraries/GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";
import {LibIdle} from "../libraries/LibIdle.sol";
import {LibMerchant} from "../libraries/LibMerchant.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";
import {IDragonStoneBlessing} from "../erc20/IDragonStoneBlessing.sol";

contract MerchantFacet is Modifiers {
    function deal(
        uint offerId,
        uint sellAmount
    ) external onlyNonEOA onlyRegistered {
        // fetch offer deal
        Offer memory offer = LibMerchant.offer(offerId);

        // check cost type and burn
        if (offer.SELL_CURRENCY == Currencies.PIECE) {
            burnPiece(LibMeta.msgSender(), offer.SELL_RATE * sellAmount);
        } else if (offer.SELL_CURRENCY == Currencies.BLESSING) {
            burnBlessing(LibMeta.msgSender(), offer.SELL_RATE * sellAmount);
        } else if (offer.SELL_CURRENCY == Currencies.GOLD) {
            burnBlessing(LibMeta.msgSender(), offer.SELL_RATE * sellAmount);
        }
    }

    function burnPiece(address player, uint amount) internal {
        IDragonStonePieces(s.pieces).burnPiece(player, amount);
    }

    function burnBlessing(address player, uint amount) internal {
        IDragonStoneBlessing(s.blessings).burnBlessing(player, amount);
    }
}
