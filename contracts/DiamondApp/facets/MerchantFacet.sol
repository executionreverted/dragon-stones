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
import {LibRewards} from "../libraries/LibRewards.sol";

contract MerchantFacet is Modifiers {
    // rate means how much sell resource you want to spend
    function deal(uint offerId, uint rate) external onlyNonEOA onlyRegistered {
        require(rate > 0, "MerchantFacet: 0 rate");
        // fetch offer deal
        Offer memory offer = LibMerchant.offer(offerId);
        address player = LibMeta.msgSender();
        // check cost type and burn
        if (offer.SELL_CURRENCY == Currencies.PIECE) {
            LibRewards.burnPiece(player, offer.SELL_RATE * rate);
        } else if (offer.SELL_CURRENCY == Currencies.BLESSING) {
            LibRewards.burnBlessing(player, offer.SELL_RATE * rate);
        } else if (offer.SELL_CURRENCY == Currencies.GOLD) {
            LibRewards.burnGold(player, offer.SELL_RATE * rate);
        } else {
            revert("MerchantFacet: critical error, whats wrong?");
        }

        if (offer.GET_CURRENCY == Currencies.PIECE) {
            LibRewards.mintPiece(player, offer.GET_RATE * rate);
        } else if (offer.GET_CURRENCY == Currencies.BLESSING) {
            LibRewards.mintBlessing(player, offer.GET_RATE * rate);
        } else if (offer.GET_CURRENCY == Currencies.GOLD) {
            LibRewards.mintGold(player, offer.GET_RATE * rate);
        } else {
            revert("MerchantFacet: critical error 2, whats wrong?");
        }
    }

    function offers(
        uint[] calldata offerIds
    ) external pure returns (Offer[] memory) {
        Offer[] memory _result = new Offer[](offerIds.length);

        for (uint i = 0; i < offerIds.length; i++) {
            _result[i] = LibMerchant.offer(offerIds[i]);
        }
        return _result;
    }
}
