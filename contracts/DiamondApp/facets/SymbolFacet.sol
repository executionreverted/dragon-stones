// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {MAX_POLISH_LEVEL, MAX_STONE_SLOT_ID} from "../libraries/GameConstants.sol";
import {CoreBonus, DragonStone, Bonus, CoreDragonStone} from "../libraries/GameStructs.sol";
import {BonusValueType, StoneTypes, Stats} from "../libraries/GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";
import {LibSymbol} from "../libraries/LibSymbol.sol";

contract SymbolFacet is Modifiers {
    function equipDragonStone(
        uint pageId,
        uint stoneId
    ) external onlyRegistered onlyTokenOwner(stoneId) {
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

    function unequipDragonStone(
        uint pageId,
        StoneTypes slot
    ) external onlyRegistered {
        if (pageId == 0) {
            pageId = s.ActivePages[msg.sender];
        }
        require(
            s.Pages[msg.sender][pageId][uint(slot)] > 0,
            "SymbolFacet: empty slot"
        );
        uint stoneId = s.Pages[msg.sender][pageId][uint(slot)];
        delete s.Pages[msg.sender][pageId][uint(slot)];
        delete s.ActiveStones[stoneId];
    }

    function activePageId(address player) external view returns (uint) {
        return s.ActivePages[player];
    }

    function getPage(
        address player,
        uint pageId
    ) public view returns (DragonStone[] memory) {
        return LibSymbol.getPage(player, pageId);
    }

    function getPlayerStats(
        address player
    ) external view returns (int[] memory) {
        return LibSymbol.getPlayerStats(player);
    }
}
