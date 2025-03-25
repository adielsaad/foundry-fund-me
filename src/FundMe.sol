// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Note: The AggregatorV3Interface might be at a different location than what was in the video!
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";


error FundMe__NotOwner();

/**
 * @title FundMe
 * @notice A decentralized crowdfunding platform that accepts ETH donations
 * @dev This contract allows users to fund with ETH and only the owner can withdraw
 */
contract FundMe {
    using PriceConverter for uint256;

    // State variables
    // 1. State variables are stored on the contract storage
    // 2. State variables are persistent between function calls
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    // Could we make this constant?  /* hint: no! We should make it immutable! */
    address public /* immutable */ i_owner;
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    AggregatorV3Interface private s_priceFeed;

    /**
     * @notice Initializes the contract with a price feed address
     * @param priceFeed The address of the Chainlink price feed contract
     * @dev Sets the owner and price feed address
     */
    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    /**
     * @notice Allows users to fund the contract with ETH
     * @dev Requires a minimum USD value (5 USD)
     * @dev Updates the funders array and contribution amounts
     */
    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");
        // require(PriceConverter.getConversionRate(msg.value) >= MINIMUM_USD, "You need to spend more ETH!");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    /**
     * @notice Returns the version of the Chainlink Price Feed
     * @return The version number of the price feed
     */
    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    /**
     * @notice Modifier to restrict function access to the owner
     * @dev Reverts with FundMe__NotOwner if caller is not the owner
     */
    modifier onlyOwner() {
        // require(msg.sender == owner);
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    /**
     * @notice Allows the owner to withdraw all funds
     * @dev Resets the funders array and contribution amounts
     * @dev Transfers all ETH to the owner
     */
    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        // call
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
    }

    /**
     * @notice Gas-optimized version of the withdraw function
     * @dev Uses a more efficient loop structure
     * @dev Same functionality as withdraw() but with lower gas costs
     */
    function cheaperWithdraw() public onlyOwner {
        address[] memory funders = funders;
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        (bool success,) = i_owner.call{value: address(this).balance}("");
        require(success);
    }

    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \
    //         yes  no
    //         /     \
    //    receive()?  fallback()
    //     /   \
    //   yes   no
    //  /        \
    //receive()  fallback()

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
        return addressToAmountFunded[fundingAddress];
    }

    function getFunders(uint256 index) external view returns (address) {
        return funders[index];
    }

    /**
     * @notice Returns the owner of the contract
     * @return The address of the contract owner
     */
    function getOwner() external view returns (address) {
        return i_owner;
    }
}

// Concepts we didn't cover yet (will cover in later sections)
// 1. Enum
// 2. Events
// 3. Try / Catch
// 4. Function Selector
// 5. abi.encode / decode
// 6. Hash with keccak256
// 7. Yul / Assembly