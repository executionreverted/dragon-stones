// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {DragonStone, Player, Achievement} from "../libraries/GameStructs.sol";
import {Currencies, Stats, StoneTypes} from "../libraries/GameEnums.sol";
import {LibAchievement} from "../libraries/LibAchievement.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {LibSymbol} from "../libraries/LibSymbol.sol";
import {LibRewards} from "../libraries/LibRewards.sol";

contract AchievementFacet is Modifiers {
    function achievements() external view returns (Achievement[] memory) {
        return LibAchievement.achivements();
    }

    function claimAchievement(
        uint achId
    ) external notPaused onlyNonEOA onlyRegistered {
        address player = LibMeta.msgSender();
        require(
            !s.completedAchievements[player][achId],
            "AchievementFacet: already completed"
        );
        Achievement memory ach = LibAchievement.achievement(achId);
        handleRequirement(player, s.PlayerState[player], ach);
        s.completedAchievements[player][achId] = true;

        // send rewards. todo
        if (ach.REWARD_AMOUNT_1 > 0) {
            LibRewards.giveGold(ach.REWARD_AMOUNT_1);
        }

        if (ach.REWARD_AMOUNT_2 > 0) {
            LibRewards.givePiece(ach.REWARD_AMOUNT_2);
        }

        if (ach.REWARD_AMOUNT_3 > 0) {
            LibRewards.giveBlessing(ach.REWARD_AMOUNT_3);
        }

        if (ach.REWARDS_STONE_TICKET) {
            s.WorldBossInventories[player].STONE_TICKET++;
        }
    }

    function handleRequirement(
        address playerAddres,
        Player memory player,
        Achievement memory ach
    ) internal view {
        if (ach.REQUIRED_DAILY_LOGIN > 0) handleDailyRequirement(player, ach);
        if (ach.REQUIRED_ADVENTURE_HOURS > 0)
            handleAdventureRequirement(player, ach);
        if (ach.REQUIRED_IDLE_HOURS > 0) handleIdleRequirement(player, ach);
        if (ach.REQUIRED_PRAYER_HOURS > 0) handlePrayerRequirement(player, ach);
        if (ach.REQUIRED_WORLD_BOSS_DAMAGE > 0)
            handleWorldBossDmgRequirement(player, ach);
        if (ach.REQUIRED_BOSS_LAST_HIT > 0)
            handleWorldBossKillRequirement(player, ach);
        if (
            ach.REQUIRED_CHANCE_TO_DOUBLE_CLAIM > 0 ||
            ach.REQUIRED_MULTIKILL > 0
        ) handleStatRequirement(playerAddres, ach);
        if (ach.REQUIRED_LEVEL > 0) handleLevelRequirement(player, ach);
        if (ach.REQUIRED_MERCHANT_TRADES > 0)
            handleMerchantRequirement(player, ach);
        if (ach.REQUIRED_SUCCESSFUL_CREATE > 0)
            handleCraftRequirement(player, ach);
        if (ach.REQUIRED_SUCCESSFUL_ENCHANT > 0)
            handleEnchantRequirement(player, ach);
        if (ach.REQUIRED_SUCCESSFUL_POLISH > 0)
            handlePolishRequirement(player, ach);
        if (ach.REQUIRED_SUCCESSFUL_COMBINE > 0)
            handleCombineRequirement(player, ach);
        if (ach.REQUIRED_SUCCESSFUL_UPGRADE > 0)
            handleUpgradeRequirement(player, ach);

        if (
            ach.REQUIRED_EQUIP_RUBY_TIER > 0 ||
            ach.REQUIRED_EQUIP_SAPPHIRE_TIER > 0 ||
            ach.REQUIRED_EQUIP_AMBER_TIER > 0 ||
            ach.REQUIRED_EQUIP_EMERALD_TIER > 0 ||
            ach.REQUIRED_EQUIP_DIAMOND_TIER > 0 ||
            ach.REQUIRED_EQUIP_AMETHYST_TIER > 0 ||
            ach.REQUIRED_EQUIP_COSMIC_TIER > 0
        ) {
            handleEquipRequirement(playerAddres, ach);
        }
    }

    function handleCraftRequirement(
        Player memory player,
        Achievement memory ach
    ) internal pure {
        require(
            player.SUCCESSFUL_CRAFT >= ach.REQUIRED_SUCCESSFUL_CREATE,
            "AchievementFacet: successful enchant requirement"
        );
    }

    function handleCombineRequirement(
        Player memory player,
        Achievement memory ach
    ) internal pure {
        require(
            player.SUCCESSFUL_COMBINE >= ach.REQUIRED_SUCCESSFUL_COMBINE,
            "AchievementFacet: successful enchant requirement"
        );
    }

    function handlePolishRequirement(
        Player memory player,
        Achievement memory ach
    ) internal pure {
        require(
            player.SUCCESSFUL_POLISH >= ach.REQUIRED_SUCCESSFUL_POLISH,
            "AchievementFacet: successful enchant requirement"
        );
    }

    function handleUpgradeRequirement(
        Player memory player,
        Achievement memory ach
    ) internal pure {
        require(
            player.SUCCESSFUL_UPGRADE >= ach.REQUIRED_SUCCESSFUL_UPGRADE,
            "AchievementFacet: successful enchant requirement"
        );
    }

    function handleEnchantRequirement(
        Player memory player,
        Achievement memory ach
    ) internal pure {
        require(
            player.SUCCESSFUL_ENCHANT >= ach.REQUIRED_SUCCESSFUL_ENCHANT,
            "AchievementFacet: successful enchant requirement"
        );
    }

    function handleLevelRequirement(
        Player memory player,
        Achievement memory ach
    ) internal pure {
        require(
            player.LEVEL >= ach.REQUIRED_LEVEL,
            "AchievementFacet: level requirement"
        );
    }

    function handleDailyRequirement(
        Player memory player,
        Achievement memory ach
    ) internal pure {
        require(
            player.TOTAL_DAILIES >= ach.REQUIRED_DAILY_LOGIN,
            "AchievementFacet: daily login requirement"
        );
    }

    function handleAdventureRequirement(
        Player memory player,
        Achievement memory ach
    ) internal pure {
        require(
            player.ADVENTURE_HOURS >= ach.REQUIRED_ADVENTURE_HOURS,
            "AchievementFacet: adventure time requirement"
        );
    }

    function handleIdleRequirement(
        Player memory player,
        Achievement memory ach
    ) internal pure {
        require(
            player.IDLE_HOURS >= ach.REQUIRED_IDLE_HOURS,
            "AchievementFacet: idle time requirement"
        );
    }

    function handlePrayerRequirement(
        Player memory player,
        Achievement memory ach
    ) internal pure {
        require(
            player.PRAYER_HOURS >= ach.REQUIRED_PRAYER_HOURS,
            "AchievementFacet: prayer time requirement"
        );
    }

    function handleEquipRequirement(
        address player,
        Achievement memory ach
    ) internal view {
        DragonStone[] memory stones = LibSymbol.getPage(player, 1);
        DragonStone[] memory stones2 = LibSymbol.getPage(player, 2);
        require(
            stones[uint(StoneTypes.RUBY)].TIER >=
                ach.REQUIRED_EQUIP_RUBY_TIER ||
                stones2[uint(StoneTypes.RUBY)].TIER >=
                ach.REQUIRED_EQUIP_RUBY_TIER,
            "AchievementFacet: ruby requirement"
        );
        require(
            stones[uint(StoneTypes.SAPPHIRE)].TIER >=
                ach.REQUIRED_EQUIP_SAPPHIRE_TIER ||
                stones2[uint(StoneTypes.SAPPHIRE)].TIER >=
                ach.REQUIRED_EQUIP_SAPPHIRE_TIER,
            "AchievementFacet: sapphire requirement"
        );
        require(
            stones[uint(StoneTypes.AMBER)].TIER >=
                ach.REQUIRED_EQUIP_AMBER_TIER ||
                stones2[uint(StoneTypes.AMBER)].TIER >=
                ach.REQUIRED_EQUIP_AMBER_TIER,
            "AchievementFacet: amber requirement"
        );
        require(
            stones[uint(StoneTypes.EMERALD)].TIER >=
                ach.REQUIRED_EQUIP_EMERALD_TIER ||
                stones2[uint(StoneTypes.EMERALD)].TIER >=
                ach.REQUIRED_EQUIP_EMERALD_TIER,
            "AchievementFacet: emerald requirement"
        );
        require(
            stones[uint(StoneTypes.DIAMOND)].TIER >=
                ach.REQUIRED_EQUIP_DIAMOND_TIER ||
                stones2[uint(StoneTypes.DIAMOND)].TIER >=
                ach.REQUIRED_EQUIP_DIAMOND_TIER,
            "AchievementFacet: diamond requirement"
        );
        require(
            stones[uint(StoneTypes.AMETHYST)].TIER >=
                ach.REQUIRED_EQUIP_AMETHYST_TIER ||
                stones2[uint(StoneTypes.AMETHYST)].TIER >=
                ach.REQUIRED_EQUIP_AMETHYST_TIER,
            "AchievementFacet: amethyst requirement"
        );

        require(
            stones[uint(StoneTypes.COSMIC)].TIER >=
                ach.REQUIRED_EQUIP_COSMIC_TIER ||
                stones2[uint(StoneTypes.COSMIC)].TIER >=
                ach.REQUIRED_EQUIP_COSMIC_TIER,
            "AchievementFacet: cosmic requirement"
        );
    }

    function handleStatRequirement(
        address player,
        Achievement memory ach
    ) internal view {
        int[] memory stats = LibSymbol.getPlayerStats(player);
        require(
            uint(stats[uint(Stats.CHANCE_TO_DOUBLE_CLAIM)]) >
                ach.REQUIRED_CHANCE_TO_DOUBLE_CLAIM,
            "AchievementFacet: double claim stat requirement"
        );
        require(
            uint(stats[uint(Stats.MULTIKILL)]) > ach.REQUIRED_MULTIKILL,
            "AchievementFacet: multikill stat requirement"
        );
    }

    function handleMerchantRequirement(
        Player memory player,
        Achievement memory ach
    ) internal pure {
        require(
            player.MERCHANT_DEALS >= ach.REQUIRED_MERCHANT_TRADES,
            "AchievementFacet: deal count requirement"
        );
    }

    function handleWorldBossDmgRequirement(
        Player memory player,
        Achievement memory ach
    ) internal pure {
        require(
            player.WORLD_BOSS_DAMAGE >= ach.REQUIRED_WORLD_BOSS_DAMAGE,
            "AchievementFacet: boss damage requirement"
        );
    }

    function handleWorldBossKillRequirement(
        Player memory player,
        Achievement memory ach
    ) internal pure {
        require(
            player.BOSS_LAST_HIT >= ach.REQUIRED_BOSS_LAST_HIT,
            "AchievementFacet: boss kill count requirement"
        );
    }
}
