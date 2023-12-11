// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {LibAppStorage, AppStorage} from "./LibAppStorage.sol";
import {LibMeta} from "../../shared/libraries/LibMeta.sol";
import {IDragonStonePieces} from "../erc20/IDragonStonePieces.sol";
import {IDragonStoneBlessing} from "../erc20/IDragonStoneBlessing.sol";
import {IDragonStoneGold} from "../erc20/IDragonStoneGold.sol";

library LibRewards {
    function burnPiece(address player, uint amount) internal {
        AppStorage storage s = LibAppStorage.diamondStorage();
        IDragonStonePieces(s.pieces).burnPiece(player, amount);
    }

    function burnBlessing(address player, uint amount) internal {
        AppStorage storage s = LibAppStorage.diamondStorage();
        IDragonStoneBlessing(s.blessings).burnBlessing(player, amount);
    }

    function burnGold(address player, uint amount) internal {
        AppStorage storage s = LibAppStorage.diamondStorage();
        IDragonStoneGold(s.golds).burnGold(player, amount);
    }

    function mintPiece(address player, uint amount) internal {
        AppStorage storage s = LibAppStorage.diamondStorage();
        IDragonStonePieces(s.pieces).mintPiece(player, amount);
    }

    function mintBlessing(address player, uint amount) internal {
        AppStorage storage s = LibAppStorage.diamondStorage();
        IDragonStoneBlessing(s.blessings).mintBlessing(player, amount);
    }

    function mintGold(address player, uint amount) internal {
        AppStorage storage s = LibAppStorage.diamondStorage();
        IDragonStoneGold(s.golds).mintGold(player, amount);
    }
}
