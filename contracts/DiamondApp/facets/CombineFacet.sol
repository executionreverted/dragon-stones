// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {REQUIRED_PIECE_TO_COMBINE_PER_LEVEL, MAX_TIER} from "../libraries/GameConstants.sol";
import {CoreDragonStone} from "../libraries/GameStructs.sol";
import {LibDappNFT} from "../libraries/LibDappNFT.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";
import {LibRandom} from "../libraries/LibRandom.sol";

contract CombineFacet is Modifiers {
    function combine(
        uint tokenId,
        uint useTokenId
    )
        external
        notPaused
        onlyNonEOA
        onlyRegistered
        onlyTokenOwner(tokenId)
        onlyTokenOwner(useTokenId)
    {
        CoreDragonStone memory _mainToken = s.DragonStones[tokenId];
        require(_mainToken.TIER < MAX_TIER, "CombineFacet: already max.");
        CoreDragonStone memory _burnToken = s.DragonStones[useTokenId];

        require(
            _mainToken.TIER == _burnToken.TIER &&
                // _mainToken.POLISH_LEVEL == _burnToken.POLISH_LEVEL &&
                _mainToken.STONE_TYPE == _burnToken.STONE_TYPE,
            "CombineFacet: doesn't match type or tier"
        );
        uint nextTier = _mainToken.TIER + 1;
        IDragonStonePieces(s.pieces).burnPiece(
            LibMeta.msgSender(),
            REQUIRED_PIECE_TO_COMBINE_PER_LEVEL * (nextTier)
        );

        uint $upgradeChance = combineChance(nextTier);
        uint roll = LibRandom.d100(
            block.number + block.timestamp + tokenId + nextTier + 7073173
        );
        if (roll < $upgradeChance) {
            s.DragonStones[tokenId].TIER++;
            s.PlayerState[LibMeta.msgSender()].SUCCESSFUL_COMBINE++;
        }

        LibDappNFT.transfer(LibMeta.msgSender(), address(0), useTokenId);
        delete s.ActiveStones[useTokenId];
    }

    function combineChance(uint nextPolishLevel) internal pure returns (uint) {
        require(nextPolishLevel < MAX_TIER, "CombineFacet: max reached");
        uint8[10] memory POLISH_CHANCES = [50, 40, 30, 20, 15, 10, 10, 5, 5, 2];
        return POLISH_CHANCES[nextPolishLevel];
    }
}
