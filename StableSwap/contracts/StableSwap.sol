// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StableSwap {
    
    uint private constant N = 3;
    uint private constant A = 1000 * (N ** (N - 1));
    uint private constant SwapFee = 300;              //    300 / 1e6 = 0.03%
    uint private constant LiquidityFee = (SwapFee * N) / (4 * (N - 1));
    uint private constant FeeDenominator = 1e6;

    // MTT  : address : 0xDE4C3Bd6a418343Fb7cC93480A41B64F00F884e0, decimals : 18
    // USDC : address : 0xda9d4f9b69ac6C22e444eD9aF0CfC043b7a7f53f, decimals : 6
    // DAI  : address : 0x68194a729C2450ad26072b3D33ADaCbcef39D574, decimals : 18
    address[N] public tokens = [0xDE4C3Bd6a418343Fb7cC93480A41B64F00F884e0, 
                                0xda9d4f9b69ac6C22e444eD9aF0CfC043b7a7f53f,
                                0x68194a729C2450ad26072b3D33ADaCbcef39D574];
    uint[N] public multipliers = [1, 1e12, 1];
    uint[N] public balances;                           //the balance of tokens in exchange

    //share : 18 decimals
    uint private constant DECIMALS = 18;
    uint public totalSupply;
    mapping(address => uint) public balanceOf;         // the shares of users

    function _mint(address _to, uint _amount) private {
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function _burn(address _from, uint _amount) private {
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    function _xp() private view returns (uint[N] memory xp) {
        for (uint i; i < N; ++i) {
            xp[i] = balances[i] * multipliers[i];
        }
    }

    function _getD(uint[N] memory xp) private pure returns (uint) {
        /*
        Newton's method to compute D
        -----------------------------
        f(D) = ADn^n + D^(n + 1) / (n^n prod(x_i)) - An^n sum(x_i) - D 
        f'(D) = An^n + (n + 1) D^n / (n^n prod(x_i)) - 1

                     (as + np)D_n
        D_(n+1) = -----------------------
                  (a - 1)D_n + (n + 1)p

        a = An^n
        s = sum(x_i)
        p = (D_n)^(n + 1) / (n^n prod(x_i))
        */
        uint a = A * N; // An^n

        uint s; // x_0 + x_1 + ... + x_(n-1)
        for (uint i; i < N; ++i) {
            s += xp[i];
        }

        // Newton's method
        // Initial guess, d <= s
        uint d = s;
        uint d_prev;
        for (uint i; i < 255; ++i) {
            // p = D^(n + 1) / (n^n * x_0 * ... * x_(n-1))
            uint p = d;
            for (uint j; j < N; ++j) {
                p = (p * d) / (N * xp[j]);
            }
            d_prev = d;
            d = ((a * s + N * p) * d) / ((a - 1) * d + (N + 1) * p);

            if (abs(d, d_prev) <= 1) {
                return d;
            }
        }
        revert("D didn't converge");
    }

    /**
     * @notice Calculate the new balance of token j given the new balance of token i
     * @param i Index of token in
     * @param j Index of token out
     * @param x New balance of token i
     * @param xp Current precision-adjusted balances
     */
    function _getY(
        uint i,
        uint j,
        uint x,
        uint[N] memory xp
    ) private pure returns (uint) {
        /*
        Newton's method to compute y
        -----------------------------
        y = x_j

        f(y) = y^2 + y(b - D) - c

                    y_n^2 + c
        y_(n+1) = --------------
                   2y_n + b - D

        where
        s = sum(x_k), k != j
        p = prod(x_k), k != j
        b = s + D / (An^n)
        c = D^(n + 1) / (n^n * p * An^n)
        */
        uint a = A * N;
        uint d = _getD(xp);
        uint s;
        uint c = d;

        uint _x;
        for (uint k; k < N; ++k) {
            if (k == i) {
                _x = x;
            } else if (k == j) {
                continue;
            } else {
                _x = xp[k];
            }

            s += _x;
            c = (c * d) / (N * _x);
        }
        c = (c * d) / (N * a);
        uint b = s + d / a;

        // Newton's method
        uint y_prev;
        // Initial guess, y <= d
        uint y = d;
        for (uint _i; _i < 255; ++_i) {
            y_prev = y;
            y = (y * y + c) / (2 * y + b - d);
            if (abs(y, y_prev) <= 1) {
                return y;
            }
        }
        revert("y didn't converge");
    }

   
    /**
     * @notice Swap dx amount of token i for token j
     * @param i Index of token in
     * @param j Index of token out
     * @param dx Token in amount
     * @param minDy Minimum token out
     */
    function swap(uint i, uint j, uint dx, uint minDy) external returns (uint dy) {
        require(i != j, "i = j");

        IERC20(tokens[i]).transferFrom(msg.sender, address(this), dx);

        // Calculate dy
        uint[N] memory xp = _xp();
        uint x = xp[i] + dx * multipliers[i];

        uint y0 = xp[j];
        uint y1 = _getY(i, j, x, xp);
        // y0 must be >= y1, since x has increased
        // -1 to round down
        dy = (y0 - y1 - 1) / multipliers[j];

        // Subtract fee from dy
        uint fee = (dy * SwapFee) / FeeDenominator;
        dy -= fee;
        require(dy >= minDy, "dy < min");

        balances[i] += dx;
        balances[j] -= dy;

        IERC20(tokens[j]).transfer(msg.sender, dy);
    }

    function addLiquidity(
        uint[N] calldata amounts,
        uint minShares
    ) external returns (uint shares) {
        // calculate current liquidity d0
        uint _totalSupply = totalSupply;
        uint d0;
        uint[N] memory old_xs = _xp();
        if (_totalSupply > 0) {
            d0 = _getD(old_xs);
        }

        // Transfer tokens in
        uint[N] memory new_xs;
        for (uint i; i < N; ++i) {
            uint amount = amounts[i];
            if (amount > 0) {
                IERC20(tokens[i]).transferFrom(msg.sender, address(this), amount);
                new_xs[i] = old_xs[i] + amount * multipliers[i];
            } else {
                new_xs[i] = old_xs[i];
            }
        }

        // Calculate new liquidity d1
        uint d1 = _getD(new_xs);
        require(d1 > d0, "liquidity didn't increase");

        // Reccalcuate D accounting for fee on imbalance
        uint d2;
        if (_totalSupply > 0) {
            for (uint i; i < N; ++i) {
                // TODO: why old_xs[i] * d1 / d0? why not d1 / N?
                uint idealBalance = (old_xs[i] * d1) / d0;
                uint diff = abs(new_xs[i], idealBalance);
                new_xs[i] -= (LiquidityFee * diff) / FeeDenominator;   // (300*N)/1e6*(4*(N-1))
            }

            d2 = _getD(new_xs);
        } else {
            d2 = d1;
        }

        // Update balances
        for (uint i; i < N; ++i) {
            balances[i] += amounts[i];
        }

        // Shares to mint = (d2 - d0) / d0 * total supply
        // d1 >= d2 >= d0
        if (_totalSupply > 0) {
            shares = ((d2 - d0) * _totalSupply) / d0;
        } else {
            shares = d2;
        }
        require(shares >= minShares, "shares < min");
        _mint(msg.sender, shares);
    }

    function removeLiquidity(
        uint shares,
        uint[N] calldata minAmountsOut
    ) external returns (uint[N] memory amountsOut) {
        uint _totalSupply = totalSupply;

        for (uint i; i < N; ++i) {
            uint amountOut = (balances[i] * shares) / _totalSupply;
            require(amountOut >= minAmountsOut[i], "out < min");

            balances[i] -= amountOut;
            amountsOut[i] = amountOut;

            IERC20(tokens[i]).transfer(msg.sender, amountOut);
        }

        _burn(msg.sender, shares);
    }

    function removeLiquidityImbalance(uint[N] calldata amounts,uint maxshares) external {
        uint _totalSupply = totalSupply;
        uint d0;
        uint[N] memory old_xs = _xp();
        uint[N] memory new_xs;
        if (_totalSupply > 0) {
            d0 = _getD(old_xs);
        }
        for (uint i; i < N; ++i){
            new_xs[i] = old_xs[i] - amounts[i];
        }
        uint d1;
        d1 = _getD(new_xs);
        uint ideal_xs;
        for (uint i  = 0; i  < N; ++i){
            ideal_xs = (d1/d0) * old_xs[i];
            uint diff = abs(ideal_xs, new_xs[i]);
            new_xs[i] -= (LiquidityFee * diff) / FeeDenominator;
        }
        uint d2 = _getD(new_xs);
        uint shares = (d0-d2)*_totalSupply/d0;
        require(maxshares > shares,"not enough shares");
        _burn(msg.sender, shares);
        for (uint i = 0; i < N; ++i) {
            IERC20(tokens[i]).transfer(msg.sender, amounts[i]);
        }
    }
    
   function abs(uint x, uint y) internal pure returns (uint) {
        return x >= y ? x - y : y - x;
    } 
}
