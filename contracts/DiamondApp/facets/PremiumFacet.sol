// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";
import {LibPremium} from "../libraries/LibPremium.sol";

contract PremiumFacet is Modifiers {
    function buyPremium(
        uint _days
    ) external payable notPaused onlyNonEOA onlyRegistered {
        require(_days >= 1, "PremiumFacet : at least 3 days");
        address player = LibMeta.msgSender();
        uint price = _days * premiumPricePerDay();

        if (_days >= 30) {
            price -= (price * 10) / 100;
        } else if (_days >= 14) {
            price -= (price * 5) / 100;
        }

        require(msg.value >= price, "PremiumFacet: payment required");
        uint remainingPremiumTime;
        if (s.PlayerState[player].PREMIUM_EXPIRES > block.timestamp) {
            remainingPremiumTime =
                s.PlayerState[player].PREMIUM_EXPIRES -
                block.timestamp;
        }
        s.PlayerState[player].PREMIUM_TIER = 1;
        s.PlayerState[player].PREMIUM_EXPIRES =
            block.timestamp +
            (_days * 1 days) +
            remainingPremiumTime;
    }

    function premiumPriceByDays(uint _days) external view returns (uint) {
        uint price = _days * premiumPricePerDay();

        if (_days >= 30) {
            price -= (price * 10) / 100;
        } else if (_days >= 14) {
            price -= (price * 5) / 100;
        }

        return price;
    }

    function premiumPricePerDay() public view returns (uint) {
        return s.premiumPrice;
    }

    function canBuyPremium() external view returns (bool) {
        return s.canBuyPremium;
    }

    function setPremiumPrice(uint _price) external onlyDiamondOwner {
        s.premiumPrice = _price;
    }

    function userPremiumStatus(
        address player
    )
        external
        view
        returns (uint _premiumTier, uint _expirationDate, uint _minutesLeft)
    {
        (_premiumTier, _expirationDate, _minutesLeft) = LibPremium
            .userPremiumStatus(player);
    }
}
