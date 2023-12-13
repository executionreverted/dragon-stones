// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {EnumerableSet} from "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import {LibDiamond} from "../../shared/libraries/LibDiamond.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {ERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol";
import {ILayerZeroEndpointUpgradeable} from "../../contracts-upgradable/interfaces/ILayerZeroEndpointUpgradeable.sol";
import {Token, StoredCredit} from "./AppStructs.sol";
import {Airdrop, WorldBossInventory, Player, WorldBoss, ActiveStone, DragonStone, CoreDragonStone} from "../libraries/GameStructs.sol";

struct RoyaltyInfo {
    address receiver;
    uint96 royaltyFraction;
}

struct AppStorage {
    // core
    bytes32 domainSeparator;
    address pieces;
    address blessings;
    address golds;
    RoyaltyInfo _defaultRoyaltyInfo;
    mapping(uint256 => RoyaltyInfo) _tokenRoyaltyInfo;
    ILayerZeroEndpointUpgradeable lzEndpoint;
    string URI;
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
    uint enchantSeed;
    uint nextMintId;
    uint maxMintId;
    uint16 FUNCTION_TYPE_SEND;
    uint256 minGasToTransferAndStore; // min amount of gas required to transfer, and also store the payload
    mapping(uint16 => uint256) dstChainIdToBatchLimit;
    mapping(uint16 => uint256) dstChainIdToTransferGas; // per transfer amount of gas required to mint/transfer on the dst
    mapping(bytes32 => StoredCredit) storedCredits;
    mapping(uint => CoreDragonStone) DragonStones;
    // address -> page id -> slot id
    mapping(uint => ActiveStone) ActiveStones;
    mapping(address => uint) PlayerMaxPages;
    mapping(address => mapping(uint => mapping(uint => uint))) Pages;
    mapping(address => uint) ActivePages;
    mapping(address => address) Delegates;
    mapping(address => address) PaymentSplitters;
    mapping(address => Player) PlayerState;
    mapping(address => WorldBossInventory) WorldBossInventories;
    WorldBoss boss;
    uint premiumPrice;
    bool canBuyPremium;
    bool paused;
    uint airdropCount;
    mapping(uint => Airdrop) airdrops;
    mapping(uint => mapping(address => bool)) airdropsHasClaimed;
    mapping(address => bool) airdropAdmins;
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
        require(
            s.Managers[LibMeta.msgSender()],
            "Only manager can call this function"
        );
        _;
    }

    modifier onlyTokenOwner(uint tokenId) {
        require(
            LibMeta.msgSender() == s.DragonStones[tokenId].OWNER,
            "Only token owner can call this function"
        );
        _;
    }

    modifier onlyRegistered() {
        require(
            s.PlayerMaxPages[msg.sender] > 0,
            "Only registered addresses can call this function"
        );
        _;
    }

    modifier notPaused() {
        require(!s.paused, "Game is currently paused");
        _;
    }
}
