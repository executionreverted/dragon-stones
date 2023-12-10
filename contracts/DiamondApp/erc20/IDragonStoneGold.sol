// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

interface IDragonStoneGold {
    function getDragonContract() external view returns (address);

    function mintGold(address to, uint amount) external;

    function burnGold(address to, uint amount) external;
}
