// SPDX-License-Identifier: GPL3.0

pragma solidity ^0.8.23;

import {Modifiers, LibDiamond} from "../libraries/LibAppStorage.sol";
import {Player, Airdrop} from "../libraries/GameStructs.sol";
import {LibRewards} from "../libraries/LibRewards.sol";
import {LibDragonStones} from "../libraries/LibDragonStones.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol"; // OZ: MerkleProof
import {LibMeta} from "../../shared/libraries/LibMeta.sol";

contract AirdropFacet is Modifiers {
    event Claim(address indexed to, uint256[] amounts);
    event AirdropAdded(
        uint airdropId,
        bytes32 merkleRoot,
        uint8 state,
        uint maxClaims
    );
    event AirdropUpdated(
        uint airdropId,
        bytes32 merkleRoot,
        uint8 state,
        uint maxClaims
    );
    event AdminAdded(address indexed account);
    event AdminRemoved(address indexed account);

    modifier onlyAirdropAdmin() {
        require(
            s.airdropAdmins[LibMeta.msgSender()],
            "AirdropFacet: only admin"
        );
        _;
    }

    function claimAirdrop(
        address to,
        uint256[] calldata amounts,
        uint256 airdropId,
        bytes32[] calldata proof
    ) external onlyNonEOA {
        if (s.airdrops[airdropId].state != 1) revert("AirdropFacet: paused");
        if (s.airdropsHasClaimed[airdropId][to])
            revert("AirdropFacet: already claimed");
        if (s.airdrops[airdropId].claims >= s.airdrops[airdropId].maxClaims)
            revert("AirdropFacet: max. claims reached");
        // Set address to claimed
        s.airdropsHasClaimed[airdropId][to] = true;
        s.airdrops[airdropId].claims += 1;
        // Verify merkle proof, or revert if not in tree
        bytes32 leaf = keccak256(
            abi.encodePacked(
                to,
                amounts[0], // gold
                amounts[1], // piece
                amounts[2], // blessing
                amounts[3] // stone
            )
        );
        bool isValidLeaf = MerkleProof.verify(
            proof,
            s.airdrops[airdropId].merkleRoot,
            leaf
        );
        if (!isValidLeaf) revert("AirdropFacet: not in list or altered leaf");

        if (amounts[0] > 0) giveGold(to, amounts[0]);
        if (amounts[1] > 0) givePiece(to, amounts[1]);
        if (amounts[2] > 0) giveBlessing(to, amounts[2]);
        if (amounts[3] > 0) giveStone(to);
        // Emit claim event
        emit Claim(to, amounts);
    }

    function hasClaimedAirdrop(
        uint airdropId,
        address _address
    ) public view returns (bool) {
        return s.airdropsHasClaimed[airdropId][_address];
    }

    function getAirdrop(uint id) public view returns (Airdrop memory) {
        return s.airdrops[id];
    }

    function giveGold(address player, uint amount) internal {
        LibRewards.mintGold(player, amount);
    }

    function givePiece(address player, uint amount) internal {
        LibRewards.mintPiece(player, amount);
    }

    function giveBlessing(address player, uint amount) internal {
        LibRewards.mintBlessing(player, amount);
    }

    function giveStone(address player) internal {
        LibDragonStones.mintStone(player);
    }

    function getAllAirdrops() external view returns (Airdrop[] memory) {
        uint count = s.airdropCount;
        Airdrop[] memory result = new Airdrop[](count);
        for (uint i = 0; i < result.length; i++) {
            result[i] = s.airdrops[i];
        }
        return result;
    }

    /// ============ Owner Functions ============
    function addAirdrop(
        bytes32 _merkleRoot,
        uint8 _state,
        uint _maxClaims
    ) external onlyDiamondOwner {
        Airdrop storage airdrop = s.airdrops[s.airdropCount++];
        airdrop.merkleRoot = _merkleRoot;
        airdrop.state = _state;
        airdrop.maxClaims = _maxClaims;
        airdrop.claims = 0;
        emit AirdropAdded(
            s.airdropCount - 1,
            airdrop.merkleRoot,
            airdrop.state,
            airdrop.maxClaims
        );
    }

    function setAirdropState(
        uint airdropId,
        uint8 _state
    ) external onlyDiamondOwner {
        require(
            airdropId < s.airdropCount,
            "AirdropFacet: airdropId outside of bounds"
        );
        s.airdrops[airdropId].state = _state;
        emit AirdropUpdated(
            airdropId,
            s.airdrops[airdropId].merkleRoot,
            s.airdrops[airdropId].state,
            s.airdrops[airdropId].maxClaims
        );
    }

    function updateAirdrop(
        uint airdropId,
        bytes32 _merkleRoot,
        uint8 _state,
        uint _maxClaims
    ) external {
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        address sender = LibMeta.msgSender();
        require(
            sender == ds.contractOwner || s.airdropAdmins[sender],
            "Only admin can call this function"
        );

        require(
            airdropId < s.airdropCount,
            "AirdropFacet: airdropId outside of bounds"
        );
        s.airdrops[airdropId].merkleRoot = _merkleRoot;
        s.airdrops[airdropId].state = _state;
        s.airdrops[airdropId].maxClaims = _maxClaims;
        emit AirdropUpdated(
            airdropId,
            s.airdrops[airdropId].merkleRoot,
            s.airdrops[airdropId].state,
            s.airdrops[airdropId].maxClaims
        );
    }

    function setAirdropAdmin(
        address _admin,
        bool _value
    ) external onlyDiamondOwner {
        s.airdropAdmins[_admin] = _value;
    }

    function isAirdropAdmin(address admin) external view returns (bool) {}
}
