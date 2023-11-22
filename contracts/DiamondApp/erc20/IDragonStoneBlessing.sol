// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

interface IDragonStoneBlessing {
    function getDragonContract() external view returns (address);

    function mintBlessing(address to, uint amount) external;

    function burnBlessing(address to, uint amount) external;
}
