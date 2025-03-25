// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

/**
 * @title DeployFundMe
 * @notice Script to deploy the FundMe contract
 * @dev Handles deployment across different networks with appropriate configurations
 */
contract DeployFundMe is Script {
    /**
     * @notice Main function to run the deployment script
     * @return FundMe The deployed FundMe contract
     * @dev Deploys the contract with network-specific configuration
     */
    function run() external returns (FundMe) {
        // Before we deploy the contract, we need to get the price feed address
        // Before startBroadcast -> no gas is used (no transaction is sent)
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
        vm.startBroadcast();
        // After startBroadcast -> gas is used (transaction is sent)   
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}