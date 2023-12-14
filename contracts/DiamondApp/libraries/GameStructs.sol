// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import {Zodiac, StoneTypes, BonusValueType, Stats, PlayerAction, Currencies} from "./GameEnums.sol";

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
    int[] STATS;
    Zodiac ZODIAC;
    PlayerAction ACTION_STATE;
    uint USED_STAT_POINTS;
    uint ACTION_START;
    uint ACTION_DEADLINE;
    uint ACTION_DATA1;
    uint ACTION_DATA2;
    uint ACTION_DATA3;
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
    uint LAST_BOSS_ATTACK;
    uint TOTAL_BOSS_DAMAGE;
    uint IDLE_HOURS;
    uint PRAYER_HOURS;
    uint ADVENTURE_HOURS;
    uint TOTAL_DAILIES;
    uint PREMIUM_TIER;
    uint PREMIUM_EXPIRES;
    uint[50] __RESERVED__;
}

struct Quest {
    uint id;
}

struct Offer {
    Currencies SELL_CURRENCY;
    Currencies GET_CURRENCY;
    uint SELL_RATE;
    uint GET_RATE;
}

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

struct WorldBoss {
    uint HP;
    uint GOLD_REWARD_PER_DMG;
    uint PIECE_REWARD_PER_DMG;
    uint BLESSING_REWARD_PER_DMG;
    uint EXP_REWARD_PER_DMG;
    uint DEF;
    uint EXPIRES_AT;
    uint STARTS_AT;
    uint BASE_COOLDOWN;
}

struct WorldBossInventory {
    uint GOLD;
    uint EXP;
    uint PIECE;
    uint BLESSING;
    uint STONE_TICKET;
    uint[50] __RESERVED__;
}

struct Airdrop {
    /// @notice inclusion root
    bytes32 merkleRoot;
    /// @notice state of airdrop, 0: coming soon, 1: active, 2: ended
    uint8 state;
    uint maxClaims;
    uint claims;
}

struct Achievement {
    Currencies REWARD_1;
    Currencies REWARD_2;
    Currencies REWARD_3;
    uint REWARD_AMOUNT_1;
    uint REWARD_AMOUNT_2;
    uint REWARD_AMOUNT_3;
    uint REQUIRED_LEVEL; // NEEDS LEVEL
    uint REQUIRED_SET_BONUS; // NEEDS AN ACTIVE SET BONUS ON CLAIM TIME
    uint REQUIRED_SUCCESSFUL_COMBINE; // DOWN 4 NEEDS TOTAL SUCCESSFUL UPGRADES
    uint REQUIRED_SUCCESSFUL_POLISH;
    uint REQUIRED_SUCCESSFUL_ENCHANT;
    uint REQUIRED_SUCCESSFUL_UPGRADE;
    uint REQUIRED_SUCCESSFUL_CREATE; // TOTAL STONE CREATIONS
    uint REQUIRED_MERCHANT_TRADES; // TOTAL MERCHANT DEALS
    uint REQUIRED_WORLD_BOSS_DAMAGE; // TOTAL WORLD BOSS DAMAGE
    uint REQUIRED_DAILY_LOGIN; // HOW MANY DAYS USER CLAIMED DAILY
    uint REQUIRED_IDLE_HOURS; // SPENT IDLE HOURS
    uint REQUIRED_PRAYER_HOURS; // SPENT PRAYER HOURS
    uint REQUIRED_ADVENTURE_HOURS; // SPEND ADVENTURE HOURS
    uint REQUIRED_EQUIP_RUBY_TIER; // STONE REQUIREMENTS MUST BE PRESENTED ON CLAIM TIME
    uint REQUIRED_EQUIP_AMETHYST_TIER;
    uint REQUIRED_EQUIP_COSMIC_TIER;
    uint REQUIRED_EQUIP_AMBER_TIER;
    uint REQUIRED_EQUIP_SAPPHIRE_TIER;
    uint REQUIRED_EQUIP_EMERALD_TIER;
    uint REQUIRED_EQUIP_DIAMOND_TIER;
    uint REQUIRED_STR; // REQUIRED STATS MEANS TOTAL STATS WITH STONES
    uint REQUIRED_DEX;
    uint REQUIRED_WIS;
    uint REQUIRED_VIT;
    uint REQUIRED_LUK;
    uint REQUIRED_DAMAGE;
    uint REQUIRED_MULTIKILL;
    uint REQUIRED_CHANCE_TO_DOUBLE_CLAIM;
    uint PARAM_1; // MISC PARAMS FOR LATER.
    uint PARAM_2;
    uint PARAM_3;
    bool COMPLETED;
    bool REWARDS_STONE_TICKET; // IF YES, IT WILL GIVE A STONE TICKET
    uint[50] __RESERVED__;
}
