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
ERC7092 deployed:              0xF97a711672b74E3Ca7E70B63afaBB2D8a33D0202

Wrapper deployed:              0x23cEdEd6D36D87C2a2Ac483A77D0bD78C90DDFe7



这个接口定义了一种名为`IERC7092`的智能合约，用于描述债券的基本属性和操作。以下是这个接口包含的所有函数的解释：

1. `isin()`: 返回债券的ISIN（International Securities Identification Number），ISIN是一种全球标准的唯一标识符，用于识别金融工具。

2. `name()`: 返回债券的名称。

3. `symbol()`: 返回债券的符号，通常由发行者的简称和到期日期组合而成，用于在交易市场中标识债券。

4. `decimals()`: 返回债券的小数位数，用于确定如何表示债券的数量。例如，如果小数位数为10，表示债券的数量需要除以10的10次方来表示。

5. `currency()`: 返回用于支付和返还债券本金的代币合约地址，即债券的本币。

6. `currencyOfCoupon()`: 返回用于支付利息的代币合约地址，即债券的利息币种。

7. `denomination()`: 返回债券的面额，即债券的最小发行单位，通常以本币的单位表示。

8. `issueVolume()`: 返回债券的发行总额，通常以债券本币单位表示，表示债券的总债务金额。

9. `couponRate()`: 返回债券的利率，通常以基点（basis points）表示，1基点等于0.01%。

10. `couponType()`: 返回债券的利息类型，可以是零息券、固定利率券、浮动利率券等。

11. `couponFrequency()`: 返回债券的付息频率，即一年内支付利息的次数。

12. `issueDate()`: 返回债券发行日期，以Unix时间戳表示。

13. `maturityDate()`: 返回债券到期日期，即债券的本金还款日期，以Unix时间戳表示。

14. `dayCountBasis()`: 返回计息日计算方式，例如实际/实际、实际/360等。

15. `principalOf(address _account)`: 返回指定账户持有的债券本金数量。

16. `approval(address _owner, address _spender)`: 返回一个账户是否授权另一个账户管理其债券的数量。

17. `approve(address _spender, uint256 _amount)`: 授权另一个账户管理指定数量的债券。

18. `approveAll(address _spender)`: 授权另一个账户管理全部的债券。

19. `decreaseAllowance(address _spender, uint256 _amount)`: 减少账户对另一个账户的债券管理授权。

20. `decreaseAllowanceForAll(address _spender)`: 取消账户对另一个账户的全部债券管理授权。

21. `transfer(address _to, uint256 _amount, bytes calldata _data)`: 将债券转移到指定地址，并附带额外的数据。

22. `transferAll(address _to, bytes calldata _data)`: 将所有债券转移到指定地址，并附带额外的数据。

23. `transferFrom(address _from, address _to, uint256 _amount, bytes calldata _data)`: 从一个账户转移指定数量的债券到另一个账户，前提是已经获得了授权。

24. `transferAllFrom(address _from, address _to, bytes calldata _data)`: 从一个账户转移所有债券到另一个账户，前提是已经获得了授权。

这些函数定义了债券合约的基本属性和交互方式，使得用户可以查询债券的信息，授权他人管理债券，以及进行债券的转移和交易。这些函数允许了债券的标准化操作和管理。



isin:"ABC123",name: "ABC Bond",symbol:"ABCB",currency:"0xYourCurrencyAddress",currencyOfCoupon:"0xYourCouponCurrencyAddress",decimals:18,  denomination: 1,issueVolume: 1000,couponRate: 5,couponType: 1,couponFrequency: 1,issueDate: 1000,maturityDate: (24 * 60 * 60),  dayCountBasis: 1, 