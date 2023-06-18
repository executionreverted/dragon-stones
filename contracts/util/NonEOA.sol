// SPDX-License-Identifier: GPL3.0
pragma solidity ^0.8.18;

contract NonEOA {
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    modifier onlyNonEOA() {
        require(!isContract(msg.sender), "only non eoa");
        _;
    }
}
