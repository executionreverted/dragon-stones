// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity >0.8.0;

struct Token {
    uint id;
    address owner;
}

struct StoredCredit {
    uint16 srcChainId;
    address toAddress;
    uint256 index; // which index of the tokenIds remain
    bool creditsRemain;
}
