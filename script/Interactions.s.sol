// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";
import {console} from "forge-std/console.sol";

/**
 * @title FundFundMe
 * @notice Script to fund the FundMe contract
 * @dev Used for testing and interacting with the FundMe contract
 */
contract FundFundMe is Script {

    uint256 SEND_VALUE = 0.05 ether;

    /**
     * @notice Funds the FundMe contract with ETH
     * @param mostRecentlyDeployed The address of the most recently deployed FundMe contract
     * @dev Uses the FundMe contract's fund function
     */
    function fundFundMe(address mostRecentlyDeployed) public {
        vm.startBroadcast(); // comment this to fund the contract
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        vm.stopBroadcast(); // comment this to fund the contract
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    /**
     * @notice Main function to run the funding script
     * @dev Gets the most recently deployed contract and funds it
     */
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        fundFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}

/**
 * @title WithdrawFundMe
 * @notice Script to withdraw funds from the FundMe contract
 * @dev Used for testing and interacting with the FundMe contract
 */
contract WithdrawFundMe is Script {

    uint256 constant SEND_VALUE = 0.05 ether;

    /**
     * @notice Withdraws all funds from the FundMe contract
     * @param mostRecentlyDeployed The address of the most recently deployed FundMe contract
     * @dev Uses the FundMe contract's withdraw function
     */
    function withdrawFundMe(address mostRecentlyDeployed) public {
        FundMe(payable(mostRecentlyDeployed)).withdraw();
    }

    /**
     * @notice Main function to run the withdrawal script
     * @dev Gets the most recently deployed contract and withdraws from it
     */
    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        withdrawFundMe(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}


