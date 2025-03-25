// SPDX-License-Identifier: MIT

// 1. Deploy mocks when we are on a local anvil chain
// 2. Keep track of the contract addresses across different networks
// Sepolia ETH/USD Price Feed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
// Anvil ETH/USD Price Feed: 0x7bF728f162628987828881950721e17882981683 


pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

/**
 * @title HelperConfig
 * @notice Script to manage network configurations and deployments
 * @dev Provides network-specific settings and mock contracts for testing
 */
contract HelperConfig is Script {
    // If we are on a local anvil chain, we deploy mocks
    // Otherwise, grab the existing address from the live network

    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;
    uint256 public constant ANVIL_CHAINID = 31337;

    /**
     * @notice Emitted when the network configuration is updated
     * @param network The name of the network
     * @param priceFeed The address of the price feed
     */
    event HelperConfig__CreatedMockPriceFeed(string network, address priceFeed);

    /**
     * @notice Constructor that sets up the network configuration
     * @dev Determines the network and sets up appropriate configuration
     */
    constructor() {
        if (block.chainid == ANVIL_CHAINID) {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        } else {
            activeNetworkConfig = getSepoliaEthConfig();
        }
    }

    /**
     * @notice Gets or creates the Anvil network configuration
     * @return NetworkConfig The configuration for the Anvil network
     * @dev Deploys a mock price feed if needed
     */
    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();

        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(
            DECIMALS,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        emit HelperConfig__CreatedMockPriceFeed("anvil", address(mockPriceFeed));

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        activeNetworkConfig = anvilConfig;
        return anvilConfig;
    }

    /**
     * @notice Gets the Sepolia network configuration
     * @return NetworkConfig The configuration for the Sepolia network
     * @dev Returns the Sepolia price feed address
     */
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory ethConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ethConfig;
    }  
} 