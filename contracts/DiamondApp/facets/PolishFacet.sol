// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {REQUIRED_PIECE_TO_POLISH_PER_LEVEL, MAX_POLISH_LEVEL} from "../libraries/GameConstants.sol";
import {CoreDragonStone} from "../libraries/GameStructs.sol";
import {LibDappNFT} from "../libraries/LibDappNFT.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {LibRandom} from "../libraries/LibRandom.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";

contract PolishFacet is Modifiers {
    function polish(
        uint tokenId,
        uint useTokenId
    )
        external
        onlyNonEOA
        onlyTokenOwner(tokenId)
        onlyTokenOwner(useTokenId)
        onlyRegistered
    {
        CoreDragonStone memory _mainToken = s.DragonStones[tokenId];
        require(
            _mainToken.POLISH_LEVEL < MAX_POLISH_LEVEL,
            "PolishFacet: already max."
        );
        CoreDragonStone memory _burnToken = s.DragonStones[useTokenId];

        require(
            _mainToken.TIER == _burnToken.TIER,
            // && _mainToken.POLISH_LEVEL == _burnToken.POLISH_LEVEL,
            "PolishFacet: doesn't match tier"
        );

        IDragonStonePieces(s.pieces).burnPiece(
            LibMeta.msgSender(),
            REQUIRED_PIECE_TO_POLISH_PER_LEVEL * (_mainToken.POLISH_LEVEL + 1)
        );
        uint $upgradeChance = polishChance(_mainToken.POLISH_LEVEL + 1);
        uint roll = LibRandom.d100(
            block.number + block.timestamp + tokenId + 807154
        );
        if (roll < $upgradeChance) {
            s.DragonStones[tokenId].POLISH_LEVEL++;
            s.PlayerState[LibMeta.msgSender()].SUCCESSFUL_POLISH++;
        }

        LibDappNFT.transfer(LibMeta.msgSender(), address(0), useTokenId);
    }

    function polishChance(uint nextPolishLevel) internal pure returns (uint) {
        require(nextPolishLevel < MAX_POLISH_LEVEL, "PolishFacet: max reached");
        uint8[10] memory POLISH_CHANCES = [
            65,
            55,
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
