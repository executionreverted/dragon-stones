// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {Player, Offer} from "./GameStructs.sol";
import {PlayerAction, Currencies} from "./GameEnums.sol";
import {BASE_EXP} from "./GameConstants.sol";

// import {LibMeta} from "../../shared/libraries/LibMeta.sol";
library LibMerchant {
    function offer(uint id) internal pure returns (Offer memory) {
        if (id == 1) {
            // Pıece -> Blessing swap
            return
                Offer({
                    SELL_CURRENCY: Currencies.PIECE,
                    GET_CURRENCY: Currencies.BLESSING,
                    GET_RATE: 1e18,
                    SELL_RATE: 25e18
                });
        } else if (id == 2) {
            // Gold -> Piece swap
            return
                Offer({
                    SELL_CURRENCY: Currencies.GOLD,
                    GET_CURRENCY: Currencies.PIECE,
                    GET_RATE: 1e18,
                    SELL_RATE: 3e18
                });
        } else if (id == 3) {
            // Blessing -> Piece swap
            return
                Offer({
                    SELL_CURRENCY: Currencies.BLESSING,
                    GET_CURRENCY: Currencies.PIECE,
                    GET_RATE: 15e18,
                    SELL_RATE: 1e18
                });
        } else if (id == 4) {
            // Gold -> Blessing swap
            return
                Offer({
                    SELL_CURRENCY: Currencies.GOLD,
                    GET_CURRENCY: Currencies.BLESSING,
                    GET_RATE: 1e18,
                    SELL_RATE: 50e18
                });
        } else if (id == 5) {
            // Blessing -> Gold swap
            return
                Offer({
                    SELL_CURRENCY: Currencies.BLESSING,
                    GET_CURRENCY: Currencies.GOLD,
                    GET_RATE: 25e18,
                    SELL_RATE: 1e18
                });
        }

        revert("LibLevel: invalid offer id");
    }
}
