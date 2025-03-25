// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user"); // make a new address
    uint256 constant SEND_VALUE = 0.1 ether; // constant value to send
    uint256 constant STARTING_BALANCE = 10 ether; // constant starting balance

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }
    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughtEth() public {
        vm.expectRevert(); // expect the fund function to revert
        fundMe.fund(); // call the fund function
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // The next TX will be made by the USER
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testAddsFunderToArrayOfFunders() public {
        // Arrange  
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        // Act
        address funder = fundMe.getFunders(0);
        // Assert
        assertEq(funder, USER);
    }

    // modifier to fund the user
    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _; // continue with the next function
    }
    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        // expect the withdraw function to revert
        vm.expectRevert(); 
        fundMe.withdraw(); 
    }

    /* 
        test the withdraw function with a single funder
    */
    function testWithdrawWithASingleFunder() public funded {
        // Arrange
        uint256 startingContractBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = address(fundMe.getOwner()).balance;

        // Act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // Assert
        uint256 endingContractBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = address(fundMe.getOwner()).balance;
        assertEq(endingContractBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startingContractBalance); // check if the owner balance is the starting balance plus the contract balance
    }

    function testWithdrawFromMultipleFunders() public funded {
        // Arrange  
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1; 
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            // vm.prank new address
            // vm.deal new address with 1 ether
            hoax(address(i), SEND_VALUE); // hoax is a function that creates a new address and funds it with 1 ether
            // fund the fundMe contract
            fundMe.fund{value: SEND_VALUE}();
        }
        // Act
        uint256 startingContractBalance = address(fundMe).balance;
        uint256 startingOwnerBalance = address(fundMe.getOwner()).balance;
        // vm.prank fundMe owner
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank(); // stop the prank to avoid pranked address to be the owner
        // Assert
        uint256 endingContractBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = address(fundMe.getOwner()).balance;
        assertEq(endingContractBalance, 0);
        assertEq(endingOwnerBalance, startingOwnerBalance + startingContractBalance);
    }
}