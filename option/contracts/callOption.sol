// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
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
