// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {WorldBossInventory, WorldBoss, Player, AdventureMap, ActiveStone, CoreBonus, DragonStone, Bonus, CoreDragonStone} from "../libraries/GameStructs.sol";
import {StoneTypes, PlayerAction, Stats, PlayerAction} from "../libraries/GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";
import {LibSymbol} from "../libraries/LibSymbol.sol";
import {LibRandom} from "../libraries/LibRandom.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {LibAdventure} from "../libraries/LibAdventure.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";
import {LibRewards} from "../libraries/LibRewards.sol";
import {LibLevel} from "../libraries/LibLevel.sol";
import {LibPremium} from "../libraries/LibPremium.sol";

contract PremiumFacet is Modifiers {
    function buyPremium(uint _days) external payable notPaused onlyNonEOA onlyRegistered {
        require(
            msg.value >= _days * premiumPricePerDay(),
            "PremiumFacet: payment required"
        );
        uint remainingPremiumTime;
        if (
            s.PlayerState[LibMeta.msgSender()].PREMIUM_EXPIRES > block.timestamp
        ) {
            remainingPremiumTime =
                s.PlayerState[LibMeta.msgSender()].PREMIUM_EXPIRES -
                block.timestamp;
        }
        s.PlayerState[LibMeta.msgSender()].PREMIUM_TIER = 1;
        s.PlayerState[LibMeta.msgSender()].PREMIUM_EXPIRES =
            block.timestamp +
            (_days * 1 days) +
            remainingPremiumTime;
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
