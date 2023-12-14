// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {DragonStone, Bonus, CoreDragonStone} from "../libraries/GameStructs.sol";
import {PlayerAction, StoneTypes, Stats} from "../libraries/GameEnums.sol";
import {LibSymbol} from "../libraries/LibSymbol.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";

contract SymbolFacet is Modifiers {
    function equipDragonStone(
        uint pageId,
        uint stoneId
    ) external notPaused onlyRegistered onlyTokenOwner(stoneId) {
        if (pageId == 0) {
            pageId = s.ActivePages[LibMeta.msgSender()];
        }
        require(
            s.PlayerState[LibMeta.msgSender()].ACTION_STATE ==
                PlayerAction.FREE,
            "SymbolFacet: player is busy"
        );
        CoreDragonStone memory _stone = s.DragonStones[stoneId];

        uint dragonStoneSlot = uint(_stone.STONE_TYPE);

        uint oldStoneId = s.Pages[LibMeta.msgSender()][pageId][dragonStoneSlot];
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
        s.ActiveStones[stoneId].player = LibMeta.msgSender();
        s.ActiveStones[stoneId].pageId = pageId;
        s.Pages[LibMeta.msgSender()][pageId][dragonStoneSlot] = stoneId;
    }

    function unequipDragonStone(
        uint pageId,
        StoneTypes slot
    ) external notPaused onlyRegistered {
        if (pageId == 0) {
            pageId = s.ActivePages[LibMeta.msgSender()];
        }
        require(
            s.Pages[LibMeta.msgSender()][pageId][uint(slot)] > 0,
            "SymbolFacet: empty slot"
        );
        require(
            s.PlayerState[LibMeta.msgSender()].ACTION_STATE ==
                PlayerAction.FREE,
            "SymbolFacet: busy"
        );
        uint stoneId = s.Pages[LibMeta.msgSender()][pageId][uint(slot)];
        delete s.Pages[LibMeta.msgSender()][pageId][uint(slot)];
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
