// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";

contract RegisterFacet is Modifiers {
    function registerAccount() external {
        // add modifier to check stone balance. sender should have at least 1 stone to create player account and start interacting with symbols

        require(s.PlayerMaxPages[msg.sender] == 0);
        s.PlayerMaxPages[msg.sender] = 2;
        s.ActivePages[msg.sender] = 1;
         
        // @todo
        // deploy new payment splitter for this wallet to receive future royalties
    }
}
