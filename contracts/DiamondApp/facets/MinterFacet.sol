// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {MAX_POLISH_LEVEL, BASE_BONUS_ADD_CHANCE} from "../libraries/GameConstants.sol";
import {CoreBonus, DragonStone, Bonus, CoreDragonStone, StoneTypes} from "../libraries/GameStructs.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDappNFT} from "../libraries/LibDappNFT.sol";
import {LibRandom} from "../libraries/LibRandom.sol";
import {LibERC721} from "../../shared/libraries/LibERC721.sol";
import "hardhat/console.sol";

contract MinterFacet is Modifiers {
    function createStone() public {
        s.nextMintId++;
        uint tokenId = s.nextMintId;
        s.DragonStones[tokenId].OWNER = msg.sender;
        uint roll = LibRandom.d100(tokenId + block.number);
        bool isCosmic = roll < 2;
        console.log(tokenId, roll, isCosmic);
        if (isCosmic) {
            s.DragonStones[tokenId].STONE_TYPE = StoneTypes.COSMIC;
        } else {
            s.DragonStones[tokenId].STONE_TYPE = StoneTypes(
                LibRandom.dn(tokenId + block.number + block.timestamp, uint(type(StoneTypes).max))
            );
        }

        s.ownerTokenIdIndexes[msg.sender][tokenId] = s
            .ownerTokenIds[msg.sender]
            .length;
        s.ownerTokenIds[msg.sender].push(uint32(tokenId));

        // add users payment splitter contract to 2981 royalty stuff later

        emit LibERC721.Transfer(address(0), msg.sender, tokenId);
    }
}
