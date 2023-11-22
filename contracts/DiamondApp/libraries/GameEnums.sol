// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

enum BonusValueType {
    FLAT,
    PERCENTAGE
}

enum Stats {
    NULL,
    STR,
    WIS,
    VIT,
    DEX,
    LUK,
    HP,
    SP,
    DAMAGE,
    DEF,
    FIRE_RES,
    COLD_RES,
    LIGHTNING_RES,
    NATURE_RES,
    HOLY_RES,
    DARK_RES,
    LOOT_BONUS,
    MULTIKILL,
    CHANCE_TO_DOUBLE_CLAIM,
    ALL_RES,
    FASTER_CYCLES,
    ALL_STATS
}

enum StoneTypes {
    RUBY, // FIRE
    SAPPHIRE, // COLD
    AMBER, // LIGHTNING
    EMERALD, // NATURE
    DIAMOND, // HOLY
    AMETHYST, // DARK
    COSMIC // GIGA!
}
