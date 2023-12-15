// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {Player, AdventureMap} from "../libraries/GameStructs.sol";
import {PlayerAction, Stats, PlayerAction} from "../libraries/GameEnums.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";
import {LibRandom} from "../libraries/LibRandom.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {LibAdventure} from "../libraries/LibAdventure.sol";
import {LibRewards} from "../libraries/LibRewards.sol";
import {LibLevel} from "../libraries/LibLevel.sol";

contract AdventureFacet is Modifiers {
    function enterAdventure(
        uint adventureId
    ) external notPaused onlyNonEOA onlyRegistered {
        address player = LibMeta.msgSender();
        Player memory state = s.PlayerState[player];
        AdventureMap memory map = LibAdventure.getMap(adventureId);
        // level
        require(state.LEVEL >= map.MIN_LEVEL, "AdventureFacet: low level");
        require(
            state.ACTION_STATE == PlayerAction.FREE,
            "AdventureFacet: not free"
        );

        // enter adventure state
        _enterAdventure(player, adventureId);
    }

    function reenterAdventure() external notPaused onlyNonEOA onlyRegistered {
        address player = LibMeta.msgSender();
        require(
            s.PlayerState[player].ACTION_STATE == PlayerAction.ADVENTURE,
            "AdventureFacet: not in adventure"
        );
        uint id = s.PlayerState[player].ACTION_DATA1;
        require(id != 0, "AdventureFacet: invalid map");
        AdventureMap memory map = LibAdventure.getMap(id);
        finalizeAdventure(player, map);
        _enterAdventure(player, id);
    }

    function leaveAdventure() external notPaused onlyNonEOA onlyRegistered {
        address player = LibMeta.msgSender();
        require(
            s.PlayerState[player].ACTION_STATE == PlayerAction.ADVENTURE,
            "AdventureFacet: not in adventure"
        );
        uint id = s.PlayerState[player].ACTION_DATA1;
        require(id != 0, "AdventureFacet: invalid map");
        AdventureMap memory map = LibAdventure.getMap(id);
        finalizeAdventure(player, map);
    }

    function finalizeAdventure(
        address player,
        AdventureMap memory map
    ) internal {
        /* 
        struct AdventureMap {
            uint MIN_LEVEL;
            uint BASE_CYCLE;
            uint MAX_CYCLE;
            uint BASE_DROP_AMOUNT;
            uint BASE_GOLD_REWARD;
            uint STONE_DROP_CHANCE;
            uint STONE_DROP_MIN_TIME;
            uint EXP_PER_CYCLE;
            int[] MIN_STATS;
        }
        */
        uint cycles = (block.timestamp - s.PlayerState[player].ACTION_START) /
            map.BASE_CYCLE;
        if (cycles > map.MAX_CYCLE) cycles = map.MAX_CYCLE;
        if (
            block.timestamp - s.PlayerState[player].ACTION_START >
            map.STONE_DROP_MIN_TIME
        ) {
            checkStoneDrop(player, map.STONE_DROP_CHANCE);
        }
        LibRewards.mintPiece(player, cycles * map.BASE_DROP_AMOUNT);
        LibRewards.mintGold(player, cycles * map.BASE_GOLD_REWARD);
        LibLevel.giveExp(player, cycles * map.EXP_PER_CYCLE);
        s.PlayerState[player].ADVENTURE_HOURS +=
            block.timestamp -
            s.PlayerState[player].ACTION_START;
        exitAdventure(player);
    }

    function checkStoneDrop(address player, uint chance) internal {
        uint roll = LibRandom.d100(chance + block.timestamp + 1881);
        if (roll <= chance) {
            LibDragonStones.mintStone(player);
        }
    }

    function calculateRewards(
        address player
    ) external view returns (uint _piece, uint _gold, uint _exp) {
        uint id = s.PlayerState[player].ACTION_DATA1;
        require(id != 0, "AdventureFacet: invalid map");
        AdventureMap memory map = LibAdventure.getMap(id);
        uint cycles = (block.timestamp - s.PlayerState[player].ACTION_START) /
            map.BASE_CYCLE;
        if (cycles > map.MAX_CYCLE) cycles = map.MAX_CYCLE;
        _piece = cycles * map.BASE_DROP_AMOUNT;
        _gold = cycles * map.BASE_GOLD_REWARD;
        _exp = cycles * map.EXP_PER_CYCLE;
    }

    function _enterAdventure(address player, uint adventureId) internal {
        s.PlayerState[player].ACTION_STATE = PlayerAction.ADVENTURE;
        s.PlayerState[player].ACTION_START = block.timestamp;
        s.PlayerState[player].ACTION_DATA1 = adventureId;
    }

    function exitAdventure(address player) internal {
        s.PlayerState[player].ACTION_STATE = PlayerAction.FREE;
        s.PlayerState[player].ACTION_DATA1 = 0;
    }

    // BE CAREFUL IT WILL RESET YOUR ADVENTURE PROGRESS
    function forceExit() external notPaused onlyNonEOA onlyRegistered {
        exitAdventure(LibMeta.msgSender());
    }

    function getAllMaps() external pure returns (AdventureMap[] memory) {
        return LibAdventure.getAllMaps();
    }
}
