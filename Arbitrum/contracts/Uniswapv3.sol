// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

pragma abicoder v2;

import '@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import '@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';
//Contract deployed to: 0xc4821C84022cf0986a7cF3187906bBc3b2eC641f

contract Uniswap {

    ISwapRouter public immutable swapRouter;
    address public firstToken;
    //= 0x6B175474E89094C44Da98b954EedeAC495271d0F; //Dai Stablecoin (DAI)
    address public SecondToken;
    // = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // Wrapped Ether (WETH)
    uint24 public constant feeTier = 3000;

    constructor(ISwapRouter _swapRouter, address _firstToken, address _SecondToken) {
        swapRouter = _swapRouter;
        firstToken = _firstToken;
        SecondToken = _SecondToken;
    }

    function swapFirstForSec(uint256 _amountIn) external returns (uint256 _amountOut){
        TransferHelper.safeTransferFrom(SecondToken, msg.sender, address(this),_amountIn);

        //  to approve router to sepend on behalf 
        TransferHelper.safeApprove(SecondToken, address(swapRouter), _amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: SecondToken,
            tokenOut: firstToken,
            fee: feeTier,
            recipient: msg.sender,
            deadline: block.timestamp,
            amountIn: _amountIn,
            amountOutMinimum: 0,
            sqrtPriceLimitX96: 0
        });

        _amountOut = swapRouter.exactInputSingle(params);
        return _amountOut;
    }
}