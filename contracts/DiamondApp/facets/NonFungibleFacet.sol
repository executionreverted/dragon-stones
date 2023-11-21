// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {MAX_POLISH_LEVEL} from "../libraries/GameConstants.sol";
import {ActiveStone, CoreBonus, DragonStone, Bonus, CoreDragonStone} from "../libraries/GameStructs.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";

contract NonFungibleFacet is Modifiers {
    function ownerOf(uint tokenId) external view returns (address) {
        return s.DragonStones[tokenId].OWNER;
    }

    function tokenURI() external view returns (string memory) {
        return s.URI;
    }
}
