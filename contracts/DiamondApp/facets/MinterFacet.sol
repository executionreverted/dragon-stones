// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {REQUIRED_PIECE_TO_MINT, MAX_POLISH_LEVEL, BASE_BONUS_ADD_CHANCE} from "../libraries/GameConstants.sol";
import {CoreBonus, DragonStone, Bonus, CoreDragonStone, StoneTypes} from "../libraries/GameStructs.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDappNFT} from "../libraries/LibDappNFT.sol";
import {LibRandom} from "../libraries/LibRandom.sol";
import {LibERC721} from "../../shared/libraries/LibERC721.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";
import {IDragonStoneBlessing} from "../erc20/IDragonStoneBlessing.sol";

contract MinterFacet is Modifiers {
    function mintPiece() external onlyDiamondOwner {
        IDragonStonePieces(s.pieces).mintPiece(
            msg.sender,
            REQUIRED_PIECE_TO_MINT
        );
    }

    function mintBlessing() external onlyDiamondOwner {
        IDragonStoneBlessing(s.blessings).mintBlessing(
            msg.sender,
            REQUIRED_PIECE_TO_MINT
        );
    }

    function createStone() public onlyNonEOA {
        IDragonStonePieces(s.pieces).burnPiece(
            msg.sender,
            REQUIRED_PIECE_TO_MINT
        );
        s.nextMintId++;
        uint tokenId = s.nextMintId;
        s.DragonStones[tokenId].OWNER = msg.sender;
        uint roll = LibRandom.d100(tokenId + block.number);
        bool isCosmic = roll < 2;
        if (isCosmic) {
            s.DragonStones[tokenId].STONE_TYPE = StoneTypes.COSMIC;
        } else {
            s.DragonStones[tokenId].STONE_TYPE = StoneTypes(
                LibRandom.dn(
                    tokenId + block.number + block.timestamp,
                    uint(type(StoneTypes).max)
                )
            );
        }

        uint[] memory _bonusesToAdd = new uint[](1);
        _bonusesToAdd[0] = 1;
        s.DragonStones[tokenId].BONUS_IDS = _bonusesToAdd;

        uint[] memory _bonusEffsToAdd = new uint[](1);
        _bonusEffsToAdd[0] = 100;
        s.DragonStones[tokenId].BONUS_EFFS = _bonusEffsToAdd;

        s.ownerTokenIdIndexes[msg.sender][tokenId] = s
            .ownerTokenIds[msg.sender]
            .length;
        s.ownerTokenIds[msg.sender].push(uint32(tokenId));

        // add users payment splitter contract to 2981 royalty stuff later

        emit LibERC721.Transfer(address(0), msg.sender, tokenId);
    }
}
