// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


contract EThPriceFeed {

     AggregatorV3Interface public priceFeed; 
    // eth/ usd = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;

    constructor() {
        priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
    }

    function getprice() public   view returns (uint256)  {
        // ABI
        // Address of the 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        (,int result,,,) = priceFeed.latestRoundData();
        // price of eth to usd
        return uint256(result * 1e10); //10 in 18
    }
}