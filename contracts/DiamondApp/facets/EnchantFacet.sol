// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {MAX_STONE_BONUS_COUNT} from "../libraries/GameConstants.sol";
import {CoreBonus, CoreDragonStone, Bonus} from "../libraries/GameStructs.sol";
import {StoneTypes} from "../libraries/GameEnums.sol";
import {LibDappNFT} from "../libraries/LibDappNFT.sol";
import {LibBonuses} from "../libraries/LibBonuses.sol";
import {LibRandom} from "../libraries/LibRandom.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";

contract EnchantFacet is Modifiers {
    function enchant(uint tokenId) external onlyNonEOA onlyRegistered onlyTokenOwner(tokenId) {
        if (s.DragonStones[tokenId].BONUS_IDS.length == 0) {
            s.DragonStones[tokenId].BONUS_IDS = new uint[](40);
            s.DragonStones[tokenId].BONUS_EFFS = new uint[](40);
        }
        StoneTypes stoneType = s.DragonStones[tokenId].STONE_TYPE;
        CoreDragonStone memory _mainToken = s.DragonStones[tokenId];
        (bool hasBonusSlot, uint bonusCount) = hasEmptyBonusSlot(
            _mainToken.BONUS_IDS,
            stoneType
        );
        require(hasBonusSlot, "EnchantFacet: no slot left");
        uint roll = LibRandom.d100(s.enchantSeed + block.number + 1337);
        uint enchantChance = getEnchantChance(bonusCount);
        // console.log("CHANCE", enchantChance);
        if (roll > enchantChance) {
            // emit event Fail
            return;
        }
        uint[] memory availableBonusPool = LibBonuses.getBonusPool(
            _mainToken.STONE_TYPE
        );
        uint chosenBonus = pickBonusIdFromPool(availableBonusPool);
        uint eff = rollEfficiency(chosenBonus);
        (bool _bonusExists, uint existIndex) = bonusExists(
            _mainToken.BONUS_IDS,
            chosenBonus
        );
        // while (bonusExists(_mainToken.BONUS_IDS, chosenBonus)) {
        //     chosenBonus = pickBonusIdFromPool(availableBonusPool);
        // }

        if (_bonusExists) {
            // console.log("EXISTSSS");
            // emit event Exists
            if (eff > _mainToken.BONUS_EFFS[existIndex]) {
                replaceEff(tokenId, existIndex, eff);
                s.PlayerState[LibMeta.msgSender()].SUCCESSFUL_ENCHANT++;
                // emit event replaced with better one!
            }
            return;
        }

        uint maxBonusSlot = MAX_STONE_BONUS_COUNT;
        if (StoneTypes.COSMIC == stoneType) maxBonusSlot += 2;
        for (uint i = 0; i < maxBonusSlot; i++) {
            if (_mainToken.BONUS_IDS[i] == 0) {
                applyBonus(tokenId, chosenBonus, eff, i);
                break;
            }
        }
    }

    function replaceEff(uint tokenId, uint existIndex, uint eff) internal {
        // console.log(
        //     "REPLACED ",
        //     s.DragonStones[tokenId].BONUS_EFFS[existIndex],
        //     eff
        // );
        // emit event here
        s.DragonStones[tokenId].BONUS_EFFS[existIndex] = eff;
    }

    function applyBonus(
        uint tokenId,
        uint chosenBonus,
        uint eff,
        uint i
    ) internal {
        s.DragonStones[tokenId].BONUS_IDS[i] = chosenBonus;
        s.DragonStones[tokenId].BONUS_EFFS[i] = eff;
        s.PlayerState[LibMeta.msgSender()].SUCCESSFUL_ENCHANT++;
    }

    function hasEmptyBonusSlot(
        uint[] memory bonuses,
        StoneTypes stoneType
    ) internal pure returns (bool _hasBonusSlot, uint bonusCount) {
        bool hasBonusSlot;
        uint maxBonusSlot = MAX_STONE_BONUS_COUNT;
        if (StoneTypes.COSMIC == stoneType) maxBonusSlot += 2;
        for (uint i = 0; i < maxBonusSlot; i++) {
            if (bonuses[i] == 0) {
                hasBonusSlot = true;
            } else {
                bonusCount++;
            }
        }
        _hasBonusSlot = hasBonusSlot;
    }

    function rollEfficiency(uint bonusId) internal returns (uint) {
        s.enchantSeed++;
        CoreBonus memory _bonus = LibBonuses.getCoreBonus(bonusId);
        uint avg = _bonus.BONUS_MAX_EFF - _bonus.BONUS_MIN_EFF;
        uint roll = LibRandom.dn(
            block.number + s.enchantSeed + avg + 13371337,
            avg
        );
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
    ) internal pure returns (bool _exists, uint idx) {
        for (uint i = 0; i < _bonusIds.length; i++) {
            if (newBonus == _bonusIds[i]) {
                _exists = true;
                idx = i;
                break;
            }
        }
    }

    function getEnchantChance(
        uint currentBonusCount
    ) internal pure returns (uint) {
        return 200 / (currentBonusCount + 3);
    }
}
