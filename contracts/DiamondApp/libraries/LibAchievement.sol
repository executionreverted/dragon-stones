// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {Achievement} from "./GameStructs.sol";
import {Currencies} from "./GameEnums.sol";

library LibAchievement {
    uint constant MAX_ACH_ID = 47;

    function achievements() internal pure returns (Achievement[] memory) {
        Achievement[] memory achs = new Achievement[](MAX_ACH_ID);
        for (uint i = 0; i < MAX_ACH_ID; i++) {
            achs[i] = achievement(i + 1);
        }
        return achs;
    }

    function achievement(
        uint id
    ) internal pure returns (Achievement memory ach) {
        if (id == 1) {
            // Hello World! Reach level 2
            ach.REQUIRED_LEVEL = 2;
            ach.REWARD_AMOUNT_1 = 100e18;
            ach.REWARD_AMOUNT_2 = 25e18;
            ach.REWARD_AMOUNT_3 = 1e18;
        } else if (id == 2) {
            // Hello World! 2 Reach level 5
            ach.REQUIRED_LEVEL = 5;
            ach.REWARD_AMOUNT_1 = 300e18;
            ach.REWARD_AMOUNT_2 = 50e18;
            ach.REWARD_AMOUNT_3 = 3e18;
        } else if (id == 3) {
            // Hello World! 3 Reach level 10
            ach.REQUIRED_LEVEL = 10;
            ach.REWARD_AMOUNT_1 = 500e18;
            ach.REWARD_AMOUNT_2 = 100e18;
            ach.REWARD_AMOUNT_3 = 10e18;
        } else if (id == 4) {
            // Gem Cutter 1 Craft 1 Stones
            ach.REQUIRED_SUCCESSFUL_CREATE = 1;
            ach.REWARD_AMOUNT_1 = 50e18;
            ach.REWARD_AMOUNT_2 = 5e18;
        } else if (id == 5) {
            // Gem Cutter 2 Craft 5 Stones
            ach.REQUIRED_SUCCESSFUL_CREATE = 5;
            ach.REWARD_AMOUNT_1 = 100e18;
            ach.REWARD_AMOUNT_2 = 50e18;
        } else if (id == 6) {
            // Gem Cutter 3 Craft 25 Stones
            ach.REQUIRED_SUCCESSFUL_CREATE = 25;
            ach.REWARD_AMOUNT_1 = 500e18;
            ach.REWARD_AMOUNT_2 = 100e18;
            ach.REWARD_AMOUNT_3 = 2e18;
        } else if (id == 7) {
            // Gem Cutter 3 Craft 50 Stones
            ach.REQUIRED_SUCCESSFUL_CREATE = 50;
            ach.REWARD_AMOUNT_1 = 1000e18;
            ach.REWARD_AMOUNT_2 = 200e18;
            ach.REWARD_AMOUNT_3 = 5e18;
        } else if (id == 8) {
            // Combinator 1 Combine 1 Stones
            ach.REQUIRED_SUCCESSFUL_COMBINE = 1;
            ach.REWARD_AMOUNT_1 = 50e18;
            ach.REWARD_AMOUNT_2 = 5e18;
        } else if (id == 9) {
            // Combinator 2 Craft 5 Stones
            ach.REQUIRED_SUCCESSFUL_COMBINE = 5;
            ach.REWARD_AMOUNT_1 = 100e18;
            ach.REWARD_AMOUNT_2 = 25e18;
            ach.REWARD_AMOUNT_3 = 5e18;
        } else if (id == 10) {
            // Combinator 3 Craft 25 Stones
            ach.REQUIRED_SUCCESSFUL_COMBINE = 25;
            ach.REWARD_AMOUNT_1 = 500e18;
            ach.REWARD_AMOUNT_2 = 100e18;
            ach.REWARD_AMOUNT_3 = 25e18;
        } else if (id == 11) {
            // Shinies 1 Polish 1 Stones
            ach.REQUIRED_SUCCESSFUL_POLISH = 1;
            ach.REWARD_AMOUNT_1 = 100e18;
            ach.REWARD_AMOUNT_2 = 10e18;
        } else if (id == 12) {
            // Shinies 2 Polish 5 Stones
            ach.REQUIRED_SUCCESSFUL_POLISH = 5;
            ach.REWARD_AMOUNT_1 = 300e18;
            ach.REWARD_AMOUNT_2 = 20e18;
            ach.REWARD_AMOUNT_3 = 2e18;
        } else if (id == 13) {
            // Shinies 3 Polish 25 Stones
            ach.REQUIRED_SUCCESSFUL_POLISH = 25;
            ach.REWARD_AMOUNT_1 = 750e18;
            ach.REWARD_AMOUNT_2 = 100e18;
            ach.REWARD_AMOUNT_3 = 5e18;
        } else if (id == 14) {
            // Saintsmith 1 Upgrade 50 Stones +
            ach.REQUIRED_SUCCESSFUL_UPGRADE = 50;
            ach.REWARD_AMOUNT_1 = 300e18;
            ach.REWARD_AMOUNT_2 = 100e18;
        } else if (id == 15) {
            // Saintsmith 2 Upgrade 100 Stones +
            ach.REQUIRED_SUCCESSFUL_UPGRADE = 100;
            ach.REWARD_AMOUNT_1 = 1000e18;
            ach.REWARD_AMOUNT_2 = 250e18;
            ach.REWARD_AMOUNT_3 = 10e18;
        } else if (id == 16) {
            // Saintsmith 3 Upgrade 500 Stones +
            ach.REQUIRED_SUCCESSFUL_UPGRADE = 500;
            ach.REWARD_AMOUNT_1 = 1000e18;
            ach.REWARD_AMOUNT_2 = 250e18;
            ach.REWARD_AMOUNT_3 = 50e18;
        } else if (id == 17) {
            // Idlelooter 1 Idle 72 hours
            ach.REQUIRED_IDLE_HOURS = 24 hours;
            ach.REWARD_AMOUNT_1 = 200e18;
            ach.REWARD_AMOUNT_2 = 50e18;
            ach.REWARD_AMOUNT_3 = 1e18;
        } else if (id == 18) {
            // Idlelooter 2 Idle 100 hours
            ach.REQUIRED_IDLE_HOURS = 100 hours;
            ach.REWARD_AMOUNT_1 = 400e18;
            ach.REWARD_AMOUNT_2 = 100e18;
            ach.REWARD_AMOUNT_3 = 5e18;
        } else if (id == 19) {
            // Idlelooter 3 Idle 200 hours
            ach.REQUIRED_IDLE_HOURS = 200 hours;
            ach.REWARD_AMOUNT_1 = 500e18;
            ach.REWARD_AMOUNT_2 = 150e18;
            ach.REWARD_AMOUNT_3 = 5e18;
        } else if (id == 20) {
            // Idlelooter 4 Idle 360 hours
            ach.REQUIRED_IDLE_HOURS = 360 hours;
            ach.REWARD_AMOUNT_1 = 750e18;
            ach.REWARD_AMOUNT_2 = 200e18;
            ach.REWARD_AMOUNT_3 = 6e18;
        } else if (id == 21) {
            // Idlelooter 5 Idle 720 hours
            ach.REQUIRED_IDLE_HOURS = 720 hours;
            ach.REWARD_AMOUNT_1 = 1000e18;
            ach.REWARD_AMOUNT_2 = 250e18;
            ach.REWARD_AMOUNT_3 = 10e18;
        } else if (id == 22) {
            // Idlelooter 6 Idle 1440 hours
            ach.REQUIRED_IDLE_HOURS = 1440 hours;
            ach.REWARD_AMOUNT_1 = 1500e18;
            ach.REWARD_AMOUNT_2 = 300e18;
            ach.REWARD_AMOUNT_3 = 15e18;
        } else if (id == 23) {
            // Idlelooter 7 Idle 3333 hours
            ach.REQUIRED_IDLE_HOURS = 3333 hours;
            ach.REWARD_AMOUNT_1 = 3333e18;
            ach.REWARD_AMOUNT_2 = 333e18;
            ach.REWARD_AMOUNT_3 = 33e18;
        } else if (id == 24) {
            // Archpriest 1 Prayer 24 hours
            ach.REQUIRED_PRAYER_HOURS = 24 hours;
            ach.REWARD_AMOUNT_1 = 200e18;
            ach.REWARD_AMOUNT_2 = 50e18;
            ach.REWARD_AMOUNT_3 = 1e18;
        } else if (id == 25) {
            // Archpriest 2 Prayer 100 hours
            ach.REQUIRED_PRAYER_HOURS = 100 hours;
            ach.REWARD_AMOUNT_1 = 400e18;
            ach.REWARD_AMOUNT_2 = 100e18;
            ach.REWARD_AMOUNT_3 = 5e18;
        } else if (id == 26) {
            // Archpriest 3 Prayer 200 hours
            ach.REQUIRED_PRAYER_HOURS = 200 hours;
            ach.REWARD_AMOUNT_1 = 500e18;
            ach.REWARD_AMOUNT_2 = 150e18;
            ach.REWARD_AMOUNT_3 = 5e18;
        } else if (id == 27) {
            // Archpriest 4 Prayer 360 hours
            ach.REQUIRED_PRAYER_HOURS = 360 hours;
            ach.REWARD_AMOUNT_1 = 750e18;
            ach.REWARD_AMOUNT_2 = 200e18;
            ach.REWARD_AMOUNT_3 = 6e18;
        } else if (id == 28) {
            // Archpriest 5 Prayer 720 hours
            ach.REQUIRED_PRAYER_HOURS = 720 hours;
            ach.REWARD_AMOUNT_1 = 1000e18;
            ach.REWARD_AMOUNT_2 = 250e18;
            ach.REWARD_AMOUNT_3 = 10e18;
        } else if (id == 29) {
            // Archpriest 6 Prayer 1440 hours
            ach.REQUIRED_PRAYER_HOURS = 1440 hours;
            ach.REWARD_AMOUNT_1 = 1500e18;
            ach.REWARD_AMOUNT_2 = 300e18;
            ach.REWARD_AMOUNT_3 = 15e18;
        } else if (id == 30) {
            // Archpriest 7 Prayer 3333 hours
            ach.REQUIRED_PRAYER_HOURS = 3333 hours;
            ach.REWARD_AMOUNT_1 = 3333e18;
            ach.REWARD_AMOUNT_2 = 333e18;
            ach.REWARD_AMOUNT_3 = 33e18;
        } else if (id == 31) {
            // Adventurer 1 Adventure 24 hours
            ach.REQUIRED_ADVENTURE_HOURS = 24 hours;
            ach.REWARD_AMOUNT_1 = 200e18;
            ach.REWARD_AMOUNT_2 = 50e18;
        } else if (id == 32) {
            // Adventurer 2 Adventure 100 hours
            ach.REQUIRED_ADVENTURE_HOURS = 100 hours;
            ach.REWARD_AMOUNT_1 = 400e18;
            ach.REWARD_AMOUNT_2 = 100e18;
            ach.REWARD_AMOUNT_3 = 5e18;
        } else if (id == 33) {
            // Adventurer 3 Adventure 200 hours
            ach.REQUIRED_ADVENTURE_HOURS = 200 hours;
            ach.REWARD_AMOUNT_1 = 1000e18;
            ach.REWARDS_STONE_TICKET = true;
        } else if (id == 34) {
            // Adventurer 4 Adventure 360 hours
            ach.REQUIRED_ADVENTURE_HOURS = 360 hours;
            ach.REWARD_AMOUNT_1 = 1750e18;
            ach.REWARD_AMOUNT_2 = 200e18;
            ach.REWARD_AMOUNT_3 = 6e18;
            ach.REWARDS_STONE_TICKET = true;
        } else if (id == 35) {
            // Adventurer 5 Adventure 720 hours
            ach.REQUIRED_ADVENTURE_HOURS = 720 hours;
            ach.REWARD_AMOUNT_1 = 3000e18;
            ach.REWARD_AMOUNT_2 = 250e18;
            ach.REWARD_AMOUNT_3 = 10e18;
            ach.REWARDS_STONE_TICKET = true;
        } else if (id == 36) {
            // Adventurer 6 Adventure 1440 hours
            ach.REQUIRED_ADVENTURE_HOURS = 1440 hours;
            ach.REWARD_AMOUNT_1 = 4000e18;
            ach.REWARD_AMOUNT_2 = 300e18;
            ach.REWARD_AMOUNT_3 = 15e18;
            ach.REWARDS_STONE_TICKET = true;
        } else if (id == 37) {
            // Adventurer 7 Adventure 3333 hours
            ach.REQUIRED_ADVENTURE_HOURS = 3333 hours;
            ach.REWARD_AMOUNT_1 = 5000e18;
            ach.REWARD_AMOUNT_2 = 500e18;
            ach.REWARD_AMOUNT_3 = 50e18;
            ach.REWARDS_STONE_TICKET = true;
        } else if (id == 38) {
            // Trader 1 Deals 25
            ach.REQUIRED_MERCHANT_TRADES = 25;
            ach.REWARD_AMOUNT_2 = 50e18;
        } else if (id == 39) {
            // Trader 2 Deals 100
            ach.REQUIRED_MERCHANT_TRADES = 100;
            ach.REWARD_AMOUNT_1 = 200e18;
            ach.REWARD_AMOUNT_2 = 100e18;
            ach.REWARD_AMOUNT_3 = 5e18;
        } else if (id == 40) {
            // Trader 3 Deals 250
            ach.REQUIRED_MERCHANT_TRADES = 250;
            ach.REWARD_AMOUNT_1 = 1000e18;
            ach.REWARD_AMOUNT_3 = 20e18;
            ach.REWARDS_STONE_TICKET = true;
        } else if (id == 41) {
            // Trader 4 Deals 500
            ach.REQUIRED_MERCHANT_TRADES = 500;
            ach.REWARD_AMOUNT_1 = 2000e18;
            ach.REWARD_AMOUNT_3 = 50e18;
            ach.REWARDS_STONE_TICKET = true;
        } else if (id == 42) {
            // Trader 5 Deals 1000
            ach.REQUIRED_MERCHANT_TRADES = 1000;
            ach.REWARD_AMOUNT_1 = 3000e18;
            ach.REWARD_AMOUNT_2 = 250e18;
            ach.REWARD_AMOUNT_3 = 100e18;
            ach.REWARDS_STONE_TICKET = true;
        } else if (id == 43) {
            // Perfectionist 1 Set
            ach.REQUIRED_LEVEL = 2;
            ach.REQUIRED_SET_BONUS = 1;
            ach.REWARD_AMOUNT_2 = 25e18;
        } else if (id == 44) {
            // Perfectionist 2 Set
            ach.REQUIRED_LEVEL = 3;
            ach.REQUIRED_SET_BONUS = 2;
            ach.REWARD_AMOUNT_1 = 250e18;
            ach.REWARD_AMOUNT_2 = 50e18;
        } else if (id == 45) {
            // Perfectionist 3 Set
            ach.REQUIRED_LEVEL = 5;
            ach.REQUIRED_SET_BONUS = 3;
            ach.REWARD_AMOUNT_1 = 1000e18;
            ach.REWARD_AMOUNT_2 = 100e18;
            ach.REWARD_AMOUNT_3 = 20e18;
        } else if (id == 46) {
            // Perfectionist 4 Set
            ach.REQUIRED_LEVEL = 10;
            ach.REQUIRED_SET_BONUS = 4;
            ach.REWARD_AMOUNT_1 = 2000e18;
            ach.REWARD_AMOUNT_2 = 200e18;
            ach.REWARD_AMOUNT_3 = 50e18;
        } else if (id == 47) {
            // Perfectionist 5 Set
            ach.REQUIRED_LEVEL = 15;
            ach.REQUIRED_SET_BONUS = 5;
            ach.REWARD_AMOUNT_1 = 2500e18;
            ach.REWARD_AMOUNT_2 = 250e18;
            ach.REWARD_AMOUNT_3 = 100e18;
            ach.REWARDS_STONE_TICKET = true;
        } else {
            revert("LibAchievement: invalid achievement id");
        }
    }
}
