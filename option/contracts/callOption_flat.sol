// Sources flattened with hardhat v2.17.3 https://hardhat.org

// SPDX-License-Identifier: MIT

// File @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol@v0.6.1

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.0;

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(uint80 _roundId)
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}


// File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.9.3

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}


// File contracts/callOption.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.9;


// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract callOption {
    AggregatorV3Interface internal dataFeed;
    using SafeMath for uint;

    struct option {
        uint strike;                                  //Price in USD (18 decimal places) option allows buyer to purchase tokens at
        uint premium;                                 //Fee in contract token that option writer charges
        uint expiry;                                  //Unix timestamp of expiration time
        uint amount;                                  //Amount of tokens the option contract is for
        bool exercised;                               //Has option been exercised
        //bool canceled;                                //Has option been canceled
        uint id;                                      //Unique ID of option, also array index
        //uint latestCost;                              //Helper to show last updated cost to exercise
        address payable writer;                       //Issuer of option
        address payable buyer;                        //Buyer of option
    }

    option[] public ethopt;

    constructor () {
    dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);                // ETH/USD   
    }
    uint decimals = 8;                                                                           // decimals is 8

    function getLatestData() public view returns (int, uint) {
        (
            /* uint80 roundID */,
            int answer,
            uint startedAt,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return (answer, startedAt);
    }

    //function getPremiumOption (uint strike, uint T, uint tknum) public view returns (uint){

    //    return 1;
    //}

    function writeOption(uint strike, uint T, uint tknum, uint _premium) public payable{
        require(msg.value == tknum, "Incorrect amount of ETH supplied");                       //Transfer ETH to this contract     tknum 那里的单位是wei 就是Value那里的单位 
        uint premium = _premium;                                     // 1 eth = 10**18 wei        premium
        //(, uint startTime) = getLatestData();
        ethopt.push(option(strike, premium, T+block.timestamp, tknum, false, ethopt.length, payable(msg.sender), payable(address(0))));
    }

    function withdraw(uint ID) public payable{
        require(ethopt[ID].expiry + 600 < block.timestamp, "Option is not expired");
        require(ethopt[ID].exercised == false);

        ethopt[ID].writer.transfer(ethopt[ID].amount); 
    }
    
    function buyOption(uint ID) public payable {
        require(msg.value == ethopt[ID].premium, "Incorrect amount of ETH sent for premium");   //Transfer premium payment from buyer
        ethopt[ID].writer.transfer(ethopt[ID].premium);
        ethopt[ID].buyer = payable(msg.sender);
    }

    function calculate(uint ID) public view returns (uint) {
        (int ethPrice, ) = getLatestData();                             //the current price of ETH

        uint excuteVal = ethopt[ID].strike*ethopt[ID].amount;           // price of strike and the number of ETH in previous sign
        uint equivEth = excuteVal.div(uint(ethPrice));                  // 把钱转换成ETH

        return equivEth;
    }

    function getTime() view public returns (uint) {
        return block.timestamp;
    }

    /**
        这个执行是要根据市场价来判断是否执行
     */
    function exercise(uint ID) public payable {
        (int currentPrice, ) = getLatestData();
        if (currentPrice >= int(ethopt[ID].strike)) {
            excute(ID);
        }
    }

    function excute(uint ID) public payable {
        require(ethopt[ID].buyer == msg.sender, "You do not own this option");
        require(!ethopt[ID].exercised, "Option has already been exercised");
        require(ethopt[ID].expiry < block.timestamp, "Option is not yet active");
        //require(ethopt[ID].expiry + 600 > block.timestamp , "Option is expired");               // 到行权时间的时候, 有600秒的时间操作(算了 先不要了)

        //(int ethPrice, ) = getLatestData();    //the current price of ETH

        //uint excuteVal = ethopt[ID].strike*ethopt[ID].amount;           // price of strike and the number of ETH in previous sign                                      amount要除以10**18
        //uint equivEth = excuteVal.div(uint(ethPrice));                  // 把钱转换成ETH      付出 strike(当时定好的行权价格$)*数量/现在1ETH的价格  --> 要付出多少个ETH     要乘以10**18        
        //uint equivEth = excuteVal.div(uint(ethPrice).mul(10**10));
        uint equivEth = calculate(ID);
        require(msg.value >= equivEth, "Incorrect ETH amount sent to excute");   //买家支付与行权价格*数量等值的以太币，行使期权。
        ethopt[ID].writer.transfer(equivEth);                                    //向卖家支付行权费
        payable(msg.sender).transfer(ethopt[ID].amount);                         //向买家支付合约数量的以太币
        ethopt[ID].exercised = true;
    }
}
