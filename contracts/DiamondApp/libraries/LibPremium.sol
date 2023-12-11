// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {Player} from "./GameStructs.sol";
import {PlayerAction, Stats} from "./GameEnums.sol";
import {BASE_EXP} from "./GameConstants.sol";

// import {LibMeta} from "../../shared/libraries/LibMeta.sol";
library LibPremium {
    function userPremiumStatus(
        address player
    )
        internal
        view
        returns (uint _premiumTier, uint _expirationDate, uint _minutesLeft)
    {
        AppStorage storage s = LibAppStorage.diamondStorage();
        _expirationDate = s.PlayerState[player].PREMIUM_EXPIRES;
        if (_expirationDate > block.timestamp) {
            _premiumTier = s.PlayerState[player].PREMIUM_TIER;
            _minutesLeft = (_expirationDate - block.timestamp) / 1 minutes;
        }
    }
}
