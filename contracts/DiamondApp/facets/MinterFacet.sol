// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {REQUIRED_PIECE_TO_MINT, MAX_POLISH_LEVEL} from "../libraries/GameConstants.sol";
import {CoreBonus, DragonStone, Bonus, CoreDragonStone, StoneTypes} from "../libraries/GameStructs.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDappNFT} from "../libraries/LibDappNFT.sol";
import {LibRandom} from "../libraries/LibRandom.sol";
import {LibERC721} from "../../shared/libraries/LibERC721.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";
import {IDragonStoneBlessing} from "../erc20/IDragonStoneBlessing.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";

contract MinterFacet is Modifiers {
    function mintPiece() external notPaused /*onlyDiamondOwner*/ {
        IDragonStonePieces(s.pieces).mintPiece(
            msg.sender,
            REQUIRED_PIECE_TO_MINT * 10
        );
    }

    function mintBlessing() external notPaused /*onlyDiamondOwner*/ {
        IDragonStoneBlessing(s.blessings).mintBlessing(
            msg.sender,
            REQUIRED_PIECE_TO_MINT * 10
        );
    }

    function createStone() public notPaused onlyNonEOA onlyRegistered {
        IDragonStonePieces(s.pieces).burnPiece(
            msg.sender,
            REQUIRED_PIECE_TO_MINT
        );
        LibDragonStones.mintStone(msg.sender);
    }

    function redeemStoneTicket() public notPaused onlyNonEOA onlyRegistered {
        address player = LibMeta.msgSender();
        require(
            s.WorldBossInventories[player].STONE_TICKET > 0,
            "MinterFacet: no tickets left"
        );
        s.WorldBossInventories[player].STONE_TICKET--;
        LibDragonStones.mintStone(player);
    }
}
