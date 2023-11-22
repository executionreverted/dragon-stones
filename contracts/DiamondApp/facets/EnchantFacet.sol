// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {MAX_STONE_BONUS_COUNT} from "../libraries/GameConstants.sol";
import {CoreBonus, CoreDragonStone, Bonus} from "../libraries/GameStructs.sol";
import {LibDappNFT} from "../libraries/LibDappNFT.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibRandom} from "../libraries/LibRandom.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";
import "hardhat/console.sol";

contract EnchantFacet is Modifiers {
    function enchant(uint tokenId) external onlyNonEOA onlyTokenOwner(tokenId) {
        if (s.DragonStones[tokenId].BONUS_IDS.length == 0) {
            s.DragonStones[tokenId].BONUS_IDS = new uint[](40);
            s.DragonStones[tokenId].BONUS_EFFS = new uint[](40);
        }

        CoreDragonStone memory _mainToken = s.DragonStones[tokenId];
        (bool hasBonusSlot, uint bonusCount) = hasEmptyBonusSlot(
            _mainToken.BONUS_IDS
        );
        require(hasBonusSlot, "no slot left");
        uint roll = 1;
        uint enchantChance = getEnchantChance(bonusCount);
        console.log("Chance to add enchant: ", enchantChance);
        if (roll > enchantChance) {
            console.log("FAILED!", roll);
            return;
        } else {
            console.log("ROLL ", roll);
        }

        uint[] memory availableBonusPool = LibBonuses.getBonusPool(
            _mainToken.STONE_TYPE
        );
        uint chosenBonus = pickBonusIdFromPool(availableBonusPool);
        console.log("chosen: ", chosenBonus);

        // while (bonusExists(_mainToken.BONUS_IDS, chosenBonus)) {
        //     chosenBonus = pickBonusIdFromPool(availableBonusPool);
        // }

        if (bonusExists(_mainToken.BONUS_IDS, chosenBonus)) {
            console.log("bonus exists!!!!!!!!!!", chosenBonus);
            return;
        }

        for (uint i = 0; i < MAX_STONE_BONUS_COUNT; i++) {
            if (_mainToken.BONUS_IDS[i] == 0) {
                console.log("ADDING BONUS: ", chosenBonus);
                s.DragonStones[tokenId].BONUS_IDS[i] = chosenBonus;
                s.DragonStones[tokenId].BONUS_EFFS[i] = rollEfficiency(
                    chosenBonus
                );
                break;
            }
        }
    }

    function hasEmptyBonusSlot(
        uint[] memory bonuses
    ) internal pure returns (bool _hasBonusSlot, uint bonusCount) {
        bool hasBonusSlot;
        for (uint i = 0; i < MAX_STONE_BONUS_COUNT; i++) {
            if (bonuses[i] == 0) {
                hasBonusSlot = true;
            } else {
                bonusCount++;
            }
        }
        _hasBonusSlot = hasBonusSlot;
    }

    function rollEfficiency(uint bonusId) internal view returns (uint) {
        CoreBonus memory _bonus = LibBonuses.getCoreBonus(bonusId);
        uint avg = _bonus.BONUS_MAX_EFF - _bonus.BONUS_MIN_EFF;
        uint roll = LibRandom.dn(block.number + s.enchantSeed + avg, avg);
        return _bonus.BONUS_MIN_EFF + roll;
    }

    function pickBonusIdFromPool(uint[] memory pool) internal returns (uint) {
        s.enchantSeed++;
        uint idx = LibRandom.dn(block.timestamp + s.enchantSeed, pool.length);
        return pool[idx];
    }

    function bonusExists(
        uint[] memory _bonusIds,
        uint newBonus
    ) internal pure returns (bool _exists) {
        for (uint i = 0; i < _bonusIds.length; i++) {
            if (newBonus == _bonusIds[i]) {
                _exists = true;
                break;
            }
        }
    }

    function getEnchantChance(
        uint currentBonusCount
    ) internal pure returns (uint) {
        return 200 / (currentBonusCount + 9);
    }
}
