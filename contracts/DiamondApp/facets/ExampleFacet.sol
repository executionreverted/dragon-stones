// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.18;

import {Modifiers} from "../libraries/LibAppStorage.sol";

contract ExampleFacet is Modifiers {
    function hello() external pure returns (string memory) {
        return "world";
    }

    function getLzEndpoint() external view returns (address _lz) {
        _lz = address(s.lzEndpoint);
    }

    function minGasToTransferAndStore() external view returns (uint _mg) {
        _mg = s.minGasToTransferAndStore;
    }
}
