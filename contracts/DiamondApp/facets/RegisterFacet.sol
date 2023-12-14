// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {PaymentSplitter} from "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import {LibDiamond} from "../../shared/libraries/LibDiamond.sol";
import {Stats, Zodiac} from "../libraries/GameEnums.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";

contract RegisterFacet is Modifiers {
    function registerAccount(uint pictureId, Zodiac zodiac) external notPaused {
        address sender = LibMeta.msgSender();
        require(
            pictureId <= s.maxProfilePictureId,
            "RegisterFacet: invalid picture id"
        );

        require(
            s.PlayerMaxPages[sender] == 0,
            "RegisterFacet: already registered"
        );

        // add modifier to check stone balance. sender should have at least 1 stone to create player account and start interacting with symbols
        if (s.tokenIds.length > 250) {
            require(
                s.ownerTokenIds[sender].length > 0,
                "RegisterFacet: 0 balance"
            );
        }
        // init player
        s.PlayerState[sender].PROFILE_PICTURE = pictureId;
        s.PlayerState[sender].ZODIAC = zodiac;
        s.PlayerState[sender].STATS = new int[](uint(type(Stats).max) + 1);
        s.PlayerState[sender].LEVEL = 1;
        s.PlayerMaxPages[sender] = 2;
        s.ActivePages[sender] = 1;
        // royalty splitter
        address[] memory payees = new address[](2);
        payees[0] = LibDiamond.contractOwner();
        payees[1] = sender;
        uint[] memory shares = new uint[](2);
        shares[0] = 50;
        shares[1] = 50;
        address deployed = address(new PaymentSplitter(payees, shares));
        s.PaymentSplitters[sender] = deployed;
    }

    function paymentSplitter(address user) external view returns (address) {
        return s.PaymentSplitters[user];
    }
}
