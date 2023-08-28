// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract sell {
    address public owner;

    IERC721 public immutable nft;
    uint256 public immutable nft_id;

    IERC20 public immutable token;

    uint256 public price;

    constructor(address _token, address _nft, uint256 _id, uint256 _price) {
        nft = IERC721(_nft);
        token = IERC20(_token);
        nft_id = _id;
        owner = nft.ownerOf(nft_id);
        price = _price*10**18;
    }

    function buy() public {
        
        require(token.allowance(msg.sender, address(this)) > price, "You need to approve more allowance to this contract !");

        token.transferFrom(msg.sender, owner, price);

        nft.transferFrom(owner, msg.sender, nft_id);
    }
     
    function getPrice() public view returns(uint256) {
        return price;
    }

    function setPrice(uint256 _price) public onlyOwner{
        price = _price;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

}


