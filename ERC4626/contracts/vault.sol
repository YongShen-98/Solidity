// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol";

contract Vault is ERC4626 {
    constructor(IERC20 asset_) ERC20("RiverToken", "RVT") ERC4626(asset_) {}
    function _decimalsOffset() internal view virtual override returns (uint8) {
        return 2; 
    } 
}
