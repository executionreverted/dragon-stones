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
    FIRE_RES,
    COLD_RES,
    LIGHTNING_RES,
    NATURE_RES,
    HOLY_RES,
    DARK_RES,
    LOOT_BONUS,
    MULTIKILL,
    CHANCE_TO_DOUBLE_CLAIM,
    __RESERVED__,
    __RESERVED__2,
    __RESERVED__3,
    __RESERVED__4,
    __RESERVED__5,
    __RESERVED__6,
    __RESERVED__7,
    __RESERVED__8,
    __RESERVED__9,
    __RESERVED__10,
    __RESERVED__11,
    __RESERVED__12,
    __RESERVED__13,
    __RESERVED__14,
    __RESERVED__15
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
