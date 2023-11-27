// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {PaymentSplitter} from "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import {LibDiamond} from "../../shared/libraries/LibDiamond.sol";

contract RegisterFacet is Modifiers {
    function registerAccount() external {
        // add modifier to check stone balance. sender should have at least 1 stone to create player account and start interacting with symbols
        require(
            s.PlayerMaxPages[msg.sender] == 0,
            "RegisterFacet: already registered"
        );
        if (LibDiamond.contractOwner() == msg.sender) {
            if (s.PaymentSplitters[msg.sender] == address(0)) {
                s.PaymentSplitters[msg.sender] = msg.sender;
                s.PlayerMaxPages[msg.sender] = 2;
                s.ActivePages[msg.sender] = 1;
                return;
            }
        }
        if (s.tokenIds.length > 1000) {
            require(
                s.ownerTokenIds[msg.sender].length > 0,
                "RegisterFacet: 0 balance"
            );
        }
        s.PlayerState[msg.sender].LEVEL = 1;
        s.PlayerMaxPages[msg.sender] = 2;
        s.ActivePages[msg.sender] = 1;
        address[] memory payees = new address[](2);
        payees[0] = LibDiamond.contractOwner();
        payees[1] = msg.sender;
        uint[] memory shares = new uint[](2);
        shares[0] = 50;
        shares[1] = 50;
        address deployed = address(new PaymentSplitter(payees, shares));
        s.PaymentSplitters[msg.sender] = deployed;
    }

    function paymentSplitter(address user) external view returns (address) {
        return s.PaymentSplitters[user];
    }
}
