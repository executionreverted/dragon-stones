// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {StoneTypes, BonusValueType, Stats, PlayerAction} from "./GameEnums.sol";

struct ActiveStone {
    address player;
    uint pageId;
}

struct CoreBonus {
    BonusValueType BONUS_VALUE_TYPE;
    Stats BONUS_STAT;
    uint BONUS_MIN_EFF;
    uint BONUS_MAX_EFF;
    uint BONUS_VALUE_TIER_INCREMENTAL;
    uint VALUE;
    uint[50] __RESERVED__;
}

struct Bonus {
    BonusValueType BONUS_VALUE_TYPE;
    Stats BONUS_STAT;
    uint BONUS_EFF;
    uint VALUE;
    uint[50] __RESERVED__;
}

struct CoreDragonStone {
    address OWNER;
    StoneTypes STONE_TYPE;
    uint TIER;
    uint POLISH_LEVEL;
    uint UPGRADE_LEVEL;
    uint[] BONUS_IDS;
    uint[] BONUS_EFFS;
    uint[50] __RESERVED;
}

struct DragonStone {
    address OWNER;
    StoneTypes STONE_TYPE;
    uint TIER;
    uint POLISH_LEVEL;
    uint UPGRADE_LEVEL;
    Bonus[] BONUS;
    uint[50] __RESERVED;
}

struct Player {
    Stats STATS;
    PlayerAction ACTION_STATE;
    uint ACTION_START;
    uint ACTION_DEADLINE;
    uint DAILY_CLAIM;
    uint PROFILE_PICTURE;
    uint LEVEL;
    uint EXP;
    uint EXPEDITION_COUNT;
    uint SUCCESSFUL_COMBINE;
    uint SUCCESSFUL_POLISH;
    uint SUCCESSFUL_UPGRADE;
    uint SUCCESSFUL_ENCHANT;
    uint COMPLETED_QUESTS;
}

struct Quest {
    uint id;
}
