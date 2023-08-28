// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SwapCpamm {
    uint public check;

    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint public reserve0;
    uint public reserve1;

    uint public calculateamount;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _token0, address _token1) {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address _to, uint _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function _burn(address _from, uint _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    function _update(uint _reserve0, uint _reserve1) private {
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }

    function swap(address _tokenIn, uint _amountIn) external returns (uint amountOut) {
        require(
            _tokenIn == address(token0) || _tokenIn == address(token1),
            "invalid token"
        );
        require(_amountIn > 0, "amount in = 0");

        bool isToken0 = _tokenIn == address(token0);
        (IERC20 tokenIn, IERC20 tokenOut, uint reserveIn, uint reserveOut) = isToken0
            ? (token0, token1, reserve0, reserve1)
            : (token1, token0, reserve1, reserve0);

        uint amountIn = _amountIn;
        tokenIn.transferFrom(msg.sender, address(this), amountIn);

        uint amountInWithFee = (amountIn * 997) / 1000;
        amountOut = (reserveOut * amountInWithFee) / (reserveIn + amountInWithFee);

        tokenOut.transfer(msg.sender, amountOut);

        _update(token0.balanceOf(address(this)), token1.balanceOf(address(this)));
    }


    function calculateAdd(address _tokenIn_u, uint _amountIn_u) external returns(uint) {
        require(
            _tokenIn_u == address(token0) || _tokenIn_u == address(token1),
            "invalid address"
        );
        require(_amountIn_u > 0, "amount in of u provide = 0");
        bool isToken0 = _tokenIn_u == address(token0);
        (uint reserveIn_u, uint reserve_o) = isToken0
            ? (reserve0, reserve1)
            : (reserve1, reserve0);
    
        //计算 另外一个token应该添加的数量
        uint amountIn_o = (reserve_o*_amountIn_u/reserveIn_u);
        calculateamount = amountIn_o;
        return amountIn_o;
    }

    function funcheck(uint _amount0, uint _amount1) public returns (uint) {
        uint amount0 = _amount0;
        uint amount1 = _amount1;
        uint check1 = _differ(reserve0*10 / reserve1, amount0*10 / amount1);
        uint check2 = _differ(reserve1*10 / reserve0, amount1*10 / amount0);
        check = _max(check1, check2);
        return check;
    }

    function addLiquidity(uint _amount0, uint _amount1) external returns (uint shares) {
        uint amount0 = _amount0;
        uint amount1 = _amount1;
        token0.transferFrom(msg.sender, address(this), amount0);
        token1.transferFrom(msg.sender, address(this), amount1);

       if (reserve0 > 0 || reserve1 >0) {
        check = funcheck(amount0, amount1);
        require(check < 1 ,"x / y != dx / dy");
       }

        if (totalSupply == 0) {
            shares = _sqrt(amount0 * amount1);
        } else {
            shares = _min(
                (amount0 * totalSupply) / reserve0,
                (amount1 * totalSupply) / reserve1
            );
        }
        require(shares > 0, "shares = 0");
        _mint(msg.sender, shares);

        _update(token0.balanceOf(address(this)), token1.balanceOf(address(this)));
    }

    function removeLiquidity(
        uint _shares
    ) external returns (uint amount0, uint amount1) {
       
        uint bal0 = token0.balanceOf(address(this));
        uint bal1 = token1.balanceOf(address(this));

        amount0 = (_shares * bal0) / totalSupply;
        amount1 = (_shares * bal1) / totalSupply;
        require(amount0 > 0 && amount1 > 0, "amount0 or amount1 = 0");

        _burn(msg.sender, _shares);
        _update(bal0 - amount0, bal1 - amount1);

        token0.transfer(msg.sender, amount0);
        token1.transfer(msg.sender, amount1);
    }

    function _sqrt(uint y) private pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }

    function _min(uint x, uint y) private pure returns (uint) {
        return x <= y ? x : y;
    }

    function _differ(uint x, uint y) private pure returns (uint) {
        if (x > y) {
            return (x-y);
        }
        else {
            return (y-x);
        }
    }

    function _max(uint x, uint y) private pure returns(uint) {
        if(x > y){
            return x;
        }else{
            return y;
        }
    }
}

