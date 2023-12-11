// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {WorldBossInventory, WorldBoss, Player, AdventureMap, ActiveStone, CoreBonus, DragonStone, Bonus, CoreDragonStone} from "../libraries/GameStructs.sol";
import {StoneTypes, PlayerAction, Stats, PlayerAction} from "../libraries/GameEnums.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";
import {LibSymbol} from "../libraries/LibSymbol.sol";
import {LibRandom} from "../libraries/LibRandom.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {LibAdventure} from "../libraries/LibAdventure.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";
import {LibRewards} from "../libraries/LibRewards.sol";
import {LibLevel} from "../libraries/LibLevel.sol";

contract BossFacet is Modifiers {
    function attack() external onlyRegistered onlyNonEOA {
        require(s.boss.HP > 0, "BossFacet: boss is dead");
        require(block.timestamp >= s.boss.STARTS_AT, "BossFacet: too soon");
        require(block.timestamp < s.boss.EXPIRES_AT, "BossFacet: escaped");
        address player = LibMeta.msgSender();
        uint cooldown = s.boss.BASE_COOLDOWN;
        require(
            block.timestamp > s.PlayerState[player].LAST_BOSS_ATTACK + cooldown,
            "BossFacet: cooldown"
        );
        int[] memory stats = LibSymbol.getPlayerStats(player);
        uint dmg = uint(stats[uint(Stats.DAMAGE)]);
        if (dmg > s.boss.HP) {
            dmg = s.boss.HP;
            // do some achievement or other stuff on kill
        }
        storeRewards(player, dmg);
        s.boss.HP -= dmg;
    }

    function claimBossRewards() external onlyRegistered onlyNonEOA {
        address player = LibMeta.msgSender();
        WorldBossInventory memory _worldBossInventory = s.WorldBossInventories[
            player
        ];

        if (_worldBossInventory.GOLD > 0) {
            LibRewards.mintGold(player, _worldBossInventory.GOLD);
        }
        if (_worldBossInventory.PIECE > 0) {
            LibRewards.mintPiece(player, _worldBossInventory.PIECE);
        }
        if (_worldBossInventory.BLESSING > 0) {
            LibRewards.mintBlessing(player, _worldBossInventory.BLESSING);
        }

        delete s.WorldBossInventories[player];
    }

    function storeRewards(address player, uint dmg) internal {
        uint goldReward = dmg * s.boss.GOLD_REWARD_PER_DMG;
        uint pieceReward = dmg * s.boss.PIECE_REWARD_PER_DMG;
        uint blessingReward = dmg * s.boss.BLESSING_REWARD_PER_DMG;
        uint expRewards = dmg * s.boss.EXP_REWARD_PER_DMG;

        if (goldReward > 0) {
            s.WorldBossInventories[player].GOLD += goldReward;
        }
        if (pieceReward > 0) {
            s.WorldBossInventories[player].PIECE += goldReward;
        }
        if (blessingReward > 0) {
            s.WorldBossInventories[player].BLESSING += goldReward;
        }
        if (expRewards > 0) {
            LibLevel.giveExp(player, expRewards);
        }
    }

    function boss() external view returns (WorldBoss memory) {
        return s.boss;
    }

    function worldBossInventory(
        address player
    ) external view returns (WorldBossInventory memory) {
        return s.WorldBossInventories[player];
    }

    // admin
    function setBoss(WorldBoss memory _boss) external onlyDiamondOwner {
        s.boss = _boss;
    }
}
