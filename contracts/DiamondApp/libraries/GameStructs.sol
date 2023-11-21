// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {StoneTypes, BonusType, BonusValueType, Stats} from "./GameEnums.sol";

struct ActiveStone {
    address player;
    uint pageId;
}

struct CoreBonus {
    BonusType BONUS_TYPE;
    BonusValueType BONUS_VALUE_TYPE;
    Stats BONUS_STAT;
    uint BONUS_VALUE_TIER_INCREMENTAL;
    uint VALUE;
    uint[50] __RESERVED__;
}

struct Bonus {
    BonusType BONUS_TYPE;
    Stats BONUS_STAT;
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
