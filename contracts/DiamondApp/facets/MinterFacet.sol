// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {MAX_POLISH_LEVEL} from "../libraries/GameConstants.sol";
import {CoreBonus, DragonStone, Bonus, CoreDragonStone, StoneTypes} from "../libraries/GameStructs.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDappNFT} from "../libraries/LibDappNFT.sol";
import {LibERC721} from "../../shared/libraries/LibERC721.sol";

contract MinterFacet is Modifiers {
    function createStone() public {
        s.nextMintId++;
        uint tokenId = s.nextMintId;
        s.DragonStones[tokenId].OWNER = msg.sender;
        s.DragonStones[tokenId].STONE_TYPE = StoneTypes.RUBY;
        s.DragonStones[tokenId].TIER = 1;
        s.DragonStones[tokenId].POLISH_LEVEL = 0;
        s.DragonStones[tokenId].UPGRADE_LEVEL = 0;

        uint[] memory _bonusesToAdd = new uint[](20);
        _bonusesToAdd[0] = 1;
        s.DragonStones[tokenId].BONUS_IDS = _bonusesToAdd;

        s.ownerTokenIdIndexes[msg.sender][tokenId] = s
            .ownerTokenIds[msg.sender]
            .length;
        s.ownerTokenIds[msg.sender].push(uint32(tokenId));

        // add users payment splitter contract to 2981 royalty stuff later

        emit LibERC721.Transfer(address(0), msg.sender, tokenId);
    }
}
