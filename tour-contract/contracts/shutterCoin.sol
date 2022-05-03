pragma solidity >=0.4.22 <0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";

contract shutterCoin is ERC20, ERC20Detailed {
    constructor(uint256 initialSupply) ERC20Detailed("Shutter", "SHC", 18) public {
        _mint(msg.sender, initialSupply);
    }
}