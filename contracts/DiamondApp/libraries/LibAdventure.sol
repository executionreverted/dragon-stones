// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {Player, AdventureMap} from "./GameStructs.sol";
import {PlayerAction, Stats} from "./GameEnums.sol";
import {BASE_CYCLE} from "./GameConstants.sol";
import {LibBonuses} from "./LibBonuses.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";

library LibAdventure {
    uint constant MAX_MAP_ID = 5;

    function getAllMaps() internal pure returns (AdventureMap[] memory) {
        AdventureMap[] memory result = new AdventureMap[](MAX_MAP_ID);
        for (uint i = 0; i < MAX_MAP_ID; i++) {
            result[i] = getMap(i + 1);
        }

        return result;
    }

    function getMap(uint id) internal pure returns (AdventureMap memory) {
        if (id == 0) revert("LibAdventure: invalid map");
        AdventureMap memory base = AdventureMap({
            MIN_LEVEL: id,
            BASE_CYCLE: 0,
            MAX_CYCLE: 0,
            BASE_DROP_AMOUNT: 0,
            STONE_DROP_CHANCE: 0,
            BASE_GOLD_REWARD: 0,
            STONE_DROP_MIN_TIME: 0,
            EXP_PER_CYCLE: 0,
            MIN_STATS: new int[](uint(type(Stats).max))
        });
        if (id == 1) {
            base.MIN_LEVEL = 1;
            base.BASE_CYCLE = 1 hours;
            base.MAX_CYCLE = 24; // 24 hours max
            base.BASE_DROP_AMOUNT = 5e16;
            base.BASE_GOLD_REWARD = 1e18;
            base.EXP_PER_CYCLE = 2;
            base.STONE_DROP_CHANCE = 1;
            base.STONE_DROP_MIN_TIME = 24 hours;
        }

        if (id == 2) {
            base.MIN_LEVEL = 4;
            base.BASE_CYCLE = 1 hours;
            base.MAX_CYCLE = 48; // 24 hours max
            base.BASE_DROP_AMOUNT = 1e17;
            base.BASE_GOLD_REWARD = 2e18;
            base.EXP_PER_CYCLE = 3;
            base.STONE_DROP_CHANCE = 2;
            base.STONE_DROP_MIN_TIME = 24 hours;
        }

        if (id == 3) {
            base.MIN_LEVEL = 8;
            base.BASE_CYCLE = 1 hours;
            base.MAX_CYCLE = 72; // 72 hours max
            base.BASE_DROP_AMOUNT = 3e17;
            base.EXP_PER_CYCLE = 5;
            base.STONE_DROP_CHANCE = 4;
            base.STONE_DROP_MIN_TIME = 36 hours;
        }

        if (id == 4) {
            base.MIN_LEVEL = 15;
            base.BASE_CYCLE = 1 hours;
            base.MAX_CYCLE = 96; // 6*12hours = 72 hours max
            base.BASE_DROP_AMOUNT = 5e17;
            base.EXP_PER_CYCLE = 8;
            base.STONE_DROP_CHANCE = 5;
            base.STONE_DROP_MIN_TIME = 36 hours;
        }

        if (id == 5) {
            base.MIN_LEVEL = 20;
            base.BASE_CYCLE = 1 hours;
            base.MAX_CYCLE = 128;
            base.BASE_DROP_AMOUNT = 8e17;
            base.EXP_PER_CYCLE = 12;
            base.STONE_DROP_CHANCE = 10;
            base.STONE_DROP_MIN_TIME = 96 hours;
        }

        return base;
    }
}
