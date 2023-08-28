# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

-------------------------------------------------------------------------------------------------------------------


testnet: https://sepolia.infura.io/v3/498e7c5b27bf4d14b590a215fb14cec5

# desgin:

IPoolAddressesProvider = 0x0496275d34753A48320CA58103d5220d394FF77F

dai: 0x68194a729C2450ad26072b3D33ADaCbcef39D574 (Sepolia)

usdc: 0xda9d4f9b69ac6C22e444eD9aF0CfC043b7a7f53f (Sepolia)

# contract address:

    FlashLoan.sol: 0xfDa5681c4946b068e867DB186ea4fD507370b81f

    DEX and FlashLoanArbitrage contract do not be deployed! Please deploy they by Remix!
# Remix

import {FlashLoanSimpleReceiverBase} from "https://github.com/aave/aave-v3-core/blob/master/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol"

import {IPoolAddressesProvider} from "https://github.com/aave/aave-v3-core/blob/master/contracts/interfaces/IPoolAddressesProvider.sol"

import {IERC20} from "https://github.com/aave/aave-v3-core/blob/master/contracts/dependencies/openzeppelin/contracts/IERC20.sol"

1000000000000000000
1000000