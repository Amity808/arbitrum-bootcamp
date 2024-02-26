// SPDX-License-Identifier: MIT
pragma solidity ^0.6.6;
import "@uniswap/v2-periphery/contracts/UniswapV2Router02.sol";

// 0xc487c71cc84E810a08b0825586ac46EB91F77263
interface IERC20Token {
    function transfer(address, uint256) external returns (bool);

    function approve(address, uint256) external returns (bool);

    function transferFrom(address, address, uint256) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function allowance(address, address) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract UniswapV2Swap {
 address private owner;
 IUniswapV2Router02 private uniswapRouter;

constructor(address _routerAddress) public {
 owner = msg.sender;
 uniswapRouter = IUniswapV2Router02(_routerAddress);
 }
// Implement your swap function here.

function swapTokens(
 address _tokenIn,
 address _tokenOut,
 uint256 _amountIn,
 uint256 _amountOutMin
) external {
 require(msg.sender == owner, "Only the owner can initiate swaps");
 
 require(
 IERC20Token(_tokenIn).transferFrom(msg.sender, address(this), _amountIn),
 "Transfer of tokenIn failed"
 );
// Approve the Uniswap Router to spend the tokenIn on your behalf.
 IERC20Token(_tokenIn).approve(address(uniswapRouter), _amountIn);
address[] memory path = new address[](2);
 path[0] = _tokenIn;
 path[1] = _tokenOut;
// Call the Uniswap V2 swap function.
 uniswapRouter.swapExactTokensForTokens(
 _amountIn,
 _amountOutMin,
 path,
 address(this),
 block.timestamp
 );

}

}