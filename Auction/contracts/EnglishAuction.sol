// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract EnglishAuction {
   
    IERC721 public nft;
    IERC20 public token;
    uint public nftId;

    address payable public seller;
    uint public endAt;
    uint public startAt;

    uint private constant DURATION = 10 minutes;
    bool public started;
    bool public ended;

    uint public currentTime;

    address public highestBidder;
    uint public highestBid;
    uint public startingBid;
    mapping(address => uint) public bids;

    bool public result;

    constructor(address _nft, uint _nftId, uint _startingBid, address _token) {
        nft = IERC721(_nft);
        nftId = _nftId;
        token = IERC20(_token);

        seller = payable(nft.ownerOf(nftId));
        highestBid = _startingBid*10**18;
        startingBid = _startingBid*10**18;
    }

    function getCurrentTime() public {
        currentTime = block.timestamp;
    }

    function start() external {
        require(!started, "started");
        require(msg.sender == seller, "not seller");

        started = true;
        ended = false;

        startAt = block.timestamp;
        endAt = block.timestamp + DURATION;

    }

    function bid(uint _bid) external payable {
        require(started, "not started");
        require(block.timestamp < endAt, "ended");
        require(_bid > highestBid, "value < highest");

        highestBidder = msg.sender;
        bids[highestBidder] = _bid;
        highestBid = _bid;
       
    }

    function end() external payable{
        require(started, "not started");
        require(block.timestamp >= endAt, "not ended");
        require(!ended, "ended");
        require(msg.sender == seller, "not seller");
        ended = true;
        if (highestBidder != address(0)) {
            nft.transferFrom(seller, highestBidder, nftId);
            token.transferFrom(highestBidder, seller, highestBid);
            result = true;
        } else {
            result = false;
        }
        started = false;
        endAt = 0;
        highestBid = 0;
        highestBidder = 0x0000000000000000000000000000000000000000;
    }
}
