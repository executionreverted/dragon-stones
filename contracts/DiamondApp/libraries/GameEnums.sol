// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

enum BonusValueType {
    FLAT,
    PERCENTAGE
}

enum Stats {
    NULL, // 0
    STR, // 1
    WIS, // 2
    VIT, // 3
    DEX, // 4
    LUK, // 5
    HP, // 6
    SP, // 7
    DAMAGE, // 8
    DEF, // 9
    FIRE_RES, // 10
    COLD_RES, //  11
    LIGHTNING_RES, // 12
    NATURE_RES, // 13
    HOLY_RES, // 14
    DARK_RES, // 15
    LOOT_BONUS, // 16
    MULTIKILL, // 17
    CHANCE_TO_DOUBLE_CLAIM, // 18
    ALL_RES, // 19
    FASTER_CYCLES, // 20
    ALL_STATS // 21
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

enum Zodiac {
    AASTERINIAN,
    ASTILABOR,
    BAHAMUT,
    CHRONEPSIS,
    FALAZURE,
    GARYX,
    HLAL,
    IO,
    LENDYS,
    TAMARA,
    TIAMAT
}

enum QuestType {
    EXPLORE,
    SPEND_TIME,
    BURN,
    UPGRADE,
    POLISH,
    COMBINE
}

enum PlayerAction {
    FREE,
    IDLE,
    PRODUCTION,
    PRAYER
}

enum Currencies {
    PIECE,
    BLESSING,
    GOLD
}
