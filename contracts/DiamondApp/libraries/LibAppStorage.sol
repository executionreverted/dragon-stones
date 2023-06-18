// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {LibDiamond} from "../../shared/libraries/LibDiamond.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {ERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import {ILayerZeroEndpointUpgradeable} from "../../contracts-upgradable/interfaces/ILayerZeroEndpointUpgradeable.sol";

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

struct AppStorage {
    // core
    bytes32 domainSeparator;
    ILayerZeroEndpointUpgradeable lzEndpoint;
    mapping(address => bool) Managers;
    // NFT Params
    mapping(address => mapping(uint256 => uint256)) ownerItemIndexes;
    mapping(uint256 => uint256) tokenIdToRandomNumber;
    mapping(address => uint32[]) ownerTokenIds;
    mapping(address => mapping(uint256 => uint256)) ownerTokenIdIndexes;
    uint32[] tokenIds;
    mapping(uint256 => uint256) tokenIdIndexes;
    mapping(address => mapping(address => bool)) operators;
    mapping(uint256 => address) approved;
    mapping(address => uint) balances;
    mapping(uint => Token) Tokens;
    uint nextMintId;
    uint maxMintId;
    uint16 FUNCTION_TYPE_SEND;
    uint256 minGasToTransferAndStore; // min amount of gas required to transfer, and also store the payload
    mapping(uint16 => uint256) dstChainIdToBatchLimit;
    mapping(uint16 => uint256) dstChainIdToTransferGas; // per transfer amount of gas required to mint/transfer on the dst
    mapping(bytes32 => StoredCredit) storedCredits;
}

library LibAppStorage {
    function diamondStorage() internal pure returns (AppStorage storage ds) {
        assembly {
            ds.slot := 0
        }
    }

    function abs(int256 x) internal pure returns (uint256) {
        return uint256(x >= 0 ? x : -x);
    }
}

contract Modifiers {
    AppStorage internal s;

    modifier onlyDiamondOwner() {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        address sender = LibMeta.msgSender();
        require(
            sender == ds.contractOwner,
            "Only manager can call this function"
        );
        _;
    }

    modifier onlyManager() {
        address sender = LibMeta.msgSender();
        require(s.Managers[sender], "Only manager can call this function");
        _;
    }
}
