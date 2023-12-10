// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers} from "../libraries/LibAppStorage.sol";
import {REQUIRED_BLESSINGS_TO_UPGRADE_PER_LEVEL, REQUIRED_PIECE_TO_UPGRADE_PER_LEVEL, MAX_UPGRADE_LEVEL} from "../libraries/GameConstants.sol";
import {CoreDragonStone} from "../libraries/GameStructs.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";
import {IDragonStoneBlessing} from "../erc20/IDragonStoneBlessing.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {LibRandom} from "../libraries/LibRandom.sol";
import {PlayerAction} from "../libraries/GameEnums.sol";

contract UpgradeFacet is Modifiers {
    function upgrade(
        uint tokenId,
        bool useBlessing
    ) external onlyNonEOA onlyRegistered {
        CoreDragonStone memory _mainToken = s.DragonStones[tokenId];
        require(_mainToken.UPGRADE_LEVEL < MAX_UPGRADE_LEVEL, "already max.");
        require(
            s.PlayerState[LibMeta.msgSender()].ACTION_STATE ==
                PlayerAction.FREE,
            "UpgradeFacet: player is busy"
        );
        uint $upgradeChance = upgradeChance(_mainToken.UPGRADE_LEVEL);
        uint roll = LibRandom.d100(block.number + block.timestamp + tokenId);
        IDragonStonePieces(s.pieces).burnPiece(
            LibMeta.msgSender(),
            REQUIRED_PIECE_TO_UPGRADE_PER_LEVEL * (_mainToken.UPGRADE_LEVEL + 1)
        );
        if (useBlessing) {
            IDragonStoneBlessing(s.blessings).burnBlessing(
                LibMeta.msgSender(),
                REQUIRED_BLESSINGS_TO_UPGRADE_PER_LEVEL *
                    (_mainToken.UPGRADE_LEVEL + 1)
            );
        }
        if (roll < $upgradeChance) {
            s.DragonStones[tokenId].UPGRADE_LEVEL++;
            s.PlayerState[LibMeta.msgSender()].SUCCESSFUL_UPGRADE++;
        } else {
            if (_mainToken.UPGRADE_LEVEL > 1 && !useBlessing) {
                s.DragonStones[tokenId].UPGRADE_LEVEL--;
            }
        }
    }

    function upgradeChance(uint nextUpgradeLevel) internal pure returns (uint) {
        require(nextUpgradeLevel < MAX_UPGRADE_LEVEL, "CAN'T UPGRADE ANYMORE");
        uint8[10] memory UPGRADE_CHANCES = [
            75,
            65,
            55,
            45,
            35,
            30,
            25,
            25,
            20,
            15
        ];
        if (nextUpgradeLevel >= 10) return 10;
        return UPGRADE_CHANCES[nextUpgradeLevel];
    }

    function requiredPieces(uint nextTier) external pure returns (uint) {
        return REQUIRED_PIECE_TO_UPGRADE_PER_LEVEL * (nextTier + 1);
    }
}
