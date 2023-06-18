// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.18;

import {LzAppUpgradeable} from "../../contracts-upgradable/lzApp/LzAppUpgradeable.sol";
import {LibAppStorage, Modifiers, StoredCredit} from "../libraries/LibAppStorage.sol";
import {LibDappNFT} from "../libraries/LibDappNFT.sol";
import {LibStrings} from "../../shared/libraries/LibStrings.sol";
import {LibDiamond} from "../../shared/libraries/LibDiamond.sol";
import {LibERC721} from "../../shared/libraries/LibERC721.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";

/// @title An NFT contract based on LayerZero UniversalONFT
/// @notice You can use this to mint ONFT and send nftIds across chain.
///  Each contract deployed to a chain should carefully set a `_startMintIndex` and a `_maxMint`
///  value to set a range of allowed mintable nftIds (so that no two chains can mint the same id!)
contract NFTFacet is Modifiers {

}
