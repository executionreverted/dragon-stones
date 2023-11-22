// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

interface IDragonStonePieces {
    function getDragonContract() external view returns (address);

    function mintPiece(address to, uint amount) external;

    function burnPiece(address to, uint amount) external;
}
