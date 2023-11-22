// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {REQUIRED_PIECE_TO_COMBINE_PER_LEVEL, MAX_TIER} from "../libraries/GameConstants.sol";
import {CoreDragonStone} from "../libraries/GameStructs.sol";
import {LibDappNFT} from "../libraries/LibDappNFT.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";

contract CombineFacet is Modifiers {
    function combine(
        uint tokenId,
        uint useTokenId
    ) external onlyNonEOA onlyTokenOwner(tokenId) onlyTokenOwner(useTokenId) {
        CoreDragonStone memory _mainToken = s.DragonStones[tokenId];
        require(_mainToken.TIER < MAX_TIER, "already max.");
        CoreDragonStone memory _burnToken = s.DragonStones[useTokenId];

        require(
            _mainToken.TIER == _burnToken.TIER &&
                _mainToken.POLISH_LEVEL == _burnToken.POLISH_LEVEL,
            "doesn't match"
        );

        IDragonStonePieces(s.pieces).burnPiece(
            LibMeta.msgSender(),
            REQUIRED_PIECE_TO_COMBINE_PER_LEVEL * (_mainToken.TIER + 1)
        );

        s.DragonStones[tokenId].TIER++;

        LibDappNFT.transfer(LibMeta.msgSender(), address(0), useTokenId);
    }

    function combineChance(uint nextPolishLevel) internal pure returns (uint) {
        require(nextPolishLevel < MAX_TIER, "CAN'T POLISH ANYMORE");
        uint8[10] memory POLISH_CHANCES = [
            55,
            50,
            45,
            40,
            35,
            30,
            25,
            20,
            15,
            10
        ];
        return POLISH_CHANCES[nextPolishLevel];
    }
}
