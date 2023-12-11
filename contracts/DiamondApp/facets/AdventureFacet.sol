// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {BASE_DAILY_REWARD} from "../libraries/GameConstants.sol";
import {Player, AdventureMap, ActiveStone, CoreBonus, DragonStone, Bonus, CoreDragonStone} from "../libraries/GameStructs.sol";
import {StoneTypes, PlayerAction, Stats, PlayerAction} from "../libraries/GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";
import {LibSymbol} from "../libraries/LibSymbol.sol";
import {LibRandom} from "../libraries/LibRandom.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {LibAdventure} from "../libraries/LibAdventure.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";

contract AdventureFacet is Modifiers {
    function enterAdventure(uint adventureId) external onlyRegistered {
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
        s.PlayerState[player].ACTION_STATE = PlayerAction.ADVENTURE;
        s.PlayerState[player].ACTION_START = block.timestamp;
        s.PlayerState[player].ACTION_DATA1 = adventureId;
    }

    function finalizeAdventure(
        address player,
        AdventureMap memory map
    ) internal {
        
    }

    function getAllMaps() external pure returns (AdventureMap[] memory) {
        return LibAdventure.getAllMaps();
    }
}
