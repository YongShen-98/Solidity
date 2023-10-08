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

callOption deployed:  0x18C80ef5ee3543197208997F7DA6dBE2BD2e759f

10**18 : 1,000,000,000,000,000,000    1000000000000000000

10**15:  1,000,000,000,000,000        1000000000000000

callOptionAut: 0x630f54b69D3E3Ed09B689Fcb154b155b71069d4B
合约自动执行

逻辑：
    卖方执行writeOption(uint strike, uint T, uint tknum, uint _premium) 把行权价格，行权要等多久（秒），代币数量，期权价格写进去
    卖方可以写好几个
    买方直接根据ID买就可以buyOption(uint ID)
    当行权日到了，并且当前价格低于市场价时，期权自动执行


