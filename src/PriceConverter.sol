// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol"; 

/**
 * @title PriceConverter
 * @notice Library for converting ETH amounts to USD using Chainlink Price Feeds
 * @dev Provides functions to get ETH price and convert ETH amounts to USD
 */
library PriceConverter {
    /**
     * @notice Gets the latest ETH price from Chainlink Price Feed
     * @param priceFeed The Chainlink Price Feed contract
     * @return The current ETH price in USD with 8 decimal places
     */
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        // Sepolia ETH / USD Address
        // https://docs.chain.link/data-feeds/price-feeds/addresses

        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // ETH/USD rate in 18 digit
        return uint256(answer * 10000000000);
    }

    /**
     * @notice Converts an ETH amount to USD
     * @param ethAmount The amount of ETH to convert
     * @param priceFeed The Chainlink Price Feed contract
     * @return The USD value of the ETH amount
     */
    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // the actual ETH/USD conversion rate, after adjusting the extra 0s.
        return ethAmountInUsd;
    }
}