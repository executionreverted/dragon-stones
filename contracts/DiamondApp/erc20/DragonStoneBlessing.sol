// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.23;

import "hardhat-deploy/solc_0.8/proxy/Proxied.sol";
import "../../contracts-upgradable/token/oft/v2/OFTV2Upgradable.sol";

contract DragonStoneBlessing is Initializable, OFTV2Upgradable, Proxied {
    address public dragonContract;
    address public newDragonContract;
    uint public validAfter;

    modifier onlyDragonContract() {
        require(msg.sender == getDragonContract());
        _;
    }

    function initialize(
        string memory _name,
        string memory _symbol,
        uint8 _sharedDecimals,
        uint _initialSupply,
        address _lzEndpoint
    ) public initializer {
        __OFTV2Upgradable_init(_name, _symbol, _sharedDecimals, _lzEndpoint);
        _mint(_msgSender(), _initialSupply);
    }

    function setDragonContract(address _dragonContract) external onlyOwner {
        if (dragonContract == address(0)) {
            dragonContract = _dragonContract;
        } else {
            newDragonContract = _dragonContract;
            validAfter = block.timestamp + 2 days;
        }
    }

    function finalizeSetDragonContract() external onlyOwner {
        if (block.timestamp >= validAfter) {
            dragonContract = newDragonContract;
            validAfter = 0;
        } else revert("Too early.");
    }

    function getDragonContract() public view returns (address) {
        if (newDragonContract != address(0) && block.timestamp >= validAfter) {
            return newDragonContract;
        }
        return dragonContract;
    }

    function mintBlessing(address to, uint amount) external onlyDragonContract {
        _mint(to, amount);
    }

    function burnBlessing(address to, uint amount) external onlyDragonContract {
        _burn(to, amount);
    }
}
