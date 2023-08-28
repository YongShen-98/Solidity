// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


contract DutchAuction {
    uint private constant DURATION = 10 minutes;

    IERC721 public immutable nft;
    IERC20 public immutable token; 
    uint public immutable nftId;

    address payable public immutable seller;
    uint public startingPrice;
    uint public startAt;
    uint public expiresAt;
    uint public immutable discountRate;
    uint public currentTime;

    constructor(uint256 _startingPrice, uint256 _discountRate, address _nft, uint256 _nftid, address _token) {
        startingPrice = _startingPrice*10**18;
        discountRate = _discountRate*10**18;
        nft = IERC721(_nft);
        nftId = _nftid;
        token = IERC20(_token);
        seller = payable(msg.sender);
    }

    function start() public onlyOwner {
        startAt = block.timestamp;
        expiresAt = startAt + DURATION;
    }

    function getCurrentTime() public returns (uint) {
        currentTime = block.timestamp;
        return currentTime;
    }

    function getPrice() public view returns (uint) {
        if (startAt == 0) {
            return startingPrice;
        } else {
            uint timeElapsed = block.timestamp - startAt;
            uint discount = discountRate * timeElapsed;
            return startingPrice - 10*discount;
        }
    }

    function buy() external payable {
        require(block.timestamp < expiresAt, "auction expired");

        uint price = getPrice();
        address _buyer = msg.sender;
        address _seller = nft.ownerOf(nftId);

        nft.transferFrom(_seller, _buyer, nftId);
        token.transferFrom(_buyer, _seller, price);
        startAt = 0;
        expiresAt = 0;
    }

    modifier onlyOwner {
        require(msg.sender == seller, "Only the owner can call this function");
        _;
    } 
}
