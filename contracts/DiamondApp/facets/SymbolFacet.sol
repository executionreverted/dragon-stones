// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {MAX_POLISH_LEVEL, MAX_STONE_SLOT_ID} from "../libraries/GameConstants.sol";
import {CoreBonus, DragonStone, Bonus, CoreDragonStone} from "../libraries/GameStructs.sol";
import {StoneTypes} from "../libraries/GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";

contract SymbolFacet is Modifiers {
    function activePageId(address player) external view returns (uint) {
        return s.ActivePages[player];
    }

    function getPage(
        address player,
        uint pageId
    ) external view returns (DragonStone[] memory) {
        uint implementedSlots = uint(type(StoneTypes).max);
        DragonStone[] memory result = new DragonStone[](implementedSlots);
        for (uint i = 0; i < implementedSlots; i++) {
            result[i] = LibDragonStones.getDragonStone(
                s.Pages[player][pageId][i]
            );
        }
        return result;
    }

    function equipDragonStone(
        uint pageId,
        uint stoneId
    ) external onlyTokenOwner(stoneId) {
        if (pageId == 0) {
            pageId = s.ActivePages[msg.sender];
        }

        CoreDragonStone memory _stone = s.DragonStones[stoneId];

        uint dragonStoneSlot = uint(_stone.STONE_TYPE);

        uint oldStoneId = s.Pages[msg.sender][pageId][dragonStoneSlot];
        if (oldStoneId > 0) {
            // nft facet should remove token from active pages if its traded
            // refund old stone , in future it will have a chance to disappear old stone
            delete s.ActiveStones[oldStoneId];
        }

        /*
        struct ActiveStone {
            address player;
            uint pageId;
            uint slotId;
        }
        */
        s.ActiveStones[stoneId].player = msg.sender;
        s.ActiveStones[stoneId].pageId = pageId;
        s.Pages[msg.sender][pageId][dragonStoneSlot] = stoneId;
    }
}
