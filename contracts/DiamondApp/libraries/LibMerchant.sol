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
            return
                Offer({
                    SELL_CURRENCY: Currencies.PIECE,
                    GET_CURRENCY: Currencies.BLESSING,
                    GET_RATE: 1,
                    SELL_RATE: 5
                });
        } else if (id == 2) {
            return
                Offer({
                    SELL_CURRENCY: Currencies.GOLD,
                    GET_CURRENCY: Currencies.PIECE,
                    GET_RATE: 2,
                    SELL_RATE: 1
                });
        } else if (id == 3) {
            return
                Offer({
                    SELL_CURRENCY: Currencies.BLESSING,
                    GET_CURRENCY: Currencies.PIECE,
                    GET_RATE: 1,
                    SELL_RATE: 1
                });
        } else if (id == 1) {
            return
                Offer({
                    SELL_CURRENCY: Currencies.GOLD,
                    GET_CURRENCY: Currencies.BLESSING,
                    GET_RATE: 1,
                    SELL_RATE: 5
                });
        }

        revert("LibLevel: invalid offer id");
    }
}
