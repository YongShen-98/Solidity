// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract token20 is ERC20Capped{
    constructor(uint cap, string memory name_, string memory symbol_) 
    ERC20(name_, symbol_) 
    ERC20Capped(cap * (10 ** decimals())) {
        _mint(msg.sender, cap * (10 ** decimals()));       
    }
}