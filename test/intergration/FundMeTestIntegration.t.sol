// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

/**
 * @title InteractionsTest
 * @notice This contract contains integration tests for the FundMe contract
 * @dev Integration tests differ from unit tests in that they:
 *      1. Test the interaction between different parts of the system
 *      2. Use the actual deployment and interaction scripts
 *      3. Test the full flow from funding to withdrawal
 *      4. Verify the contract's behavior in a more realistic scenario
 */
contract InteractionsTest is Test {
    FundMe fundMe;

    // Test user setup
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    /**
     * @notice Sets up the test environment before each test
     * @dev This function:
     *      1. Deploys a new FundMe contract
     *      2. Gives the test user initial balance
     */
    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    /**
     * @notice Tests the complete flow of funding and withdrawing
     * @dev This test:
     *      1. Uses the FundFundMe script to fund the contract
     *      2. Uses the WithdrawFundMe script to withdraw funds
     *      3. Verifies the contract balance is zero after withdrawal
     * @dev This is an integration test because it:
     *      1. Uses the actual deployment scripts
     *      2. Tests the interaction between multiple contracts
     *      3. Tests the full flow from funding to withdrawal
     */
    function testUserCanFundInteractions() public {
        // Fund the contract using the FundFundMe script
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        // Withdraw funds using the WithdrawFundMe script
        vm.prank(fundMe.getOwner());
        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        // Verify the contract balance is zero after withdrawal
        assert(address(fundMe).balance == 0);
    }
}