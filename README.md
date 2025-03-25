# FundMe Smart Contract

A decentralized crowdfunding platform built with Solidity and Foundry. This project allows users to fund the contract with ETH, which can only be withdrawn by the contract owner.

## Features

- Accept ETH donations with a minimum USD value requirement
- Real-time ETH/USD price conversion using Chainlink Price Feeds
- Secure withdrawal mechanism (owner-only)
- Gas-optimized withdrawal function
- Automated testing suite with comprehensive test coverage
- Multi-network deployment support

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/adielsaad/foundry-fund-me.git
cd foundry-fund-me
```

2. Install dependencies:
```bash
forge install
```

## Testing

Run the test suite:
```bash
forge test
```

For verbose output:
```bash
forge test -vv
```

The test suite includes:
- Basic functionality tests
- Gas optimization tests
- Multiple funder scenarios
- Owner-only access tests
- Price feed integration tests

## Deployment

The project supports deployment to multiple networks through the `HelperConfig` contract. To deploy:

1. Set up your environment variables (create a `.env` file):
```env
PRIVATE_KEY=your_private_key
ETHERSCAN_API_KEY=your_etherscan_api_key
```

2. Deploy to a specific network:
```bash
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url <your_rpc_url> --broadcast
```

## Contract Functions

### `fund()`
- Allows users to send ETH to the contract
- Requires a minimum USD value (5 USD)
- Tracks funders and their contribution amounts

### `withdraw()`
- Owner-only function to withdraw all funds
- Resets the funders array and contribution amounts
- Transfers all ETH to the owner

### `cheaperWithdraw()`
- Gas-optimized version of the withdraw function
- More efficient for handling multiple funders
- Same functionality as `withdraw()` but with lower gas costs

### `getVersion()`
- Returns the version of the Chainlink Price Feed being used

## Security Features

- Owner-only withdrawal function
- Minimum USD value requirement for funding
- Immutable owner address
- Chainlink Price Feed integration for accurate ETH/USD conversion
- Gas optimization for better scalability

## Gas Optimization

The contract includes gas optimization features:
- Efficient withdrawal mechanism for multiple funders
- Optimized storage access patterns
- Reduced gas costs for bulk operations

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Foundry](https://book.getfoundry.sh/)
- [Chainlink](https://chain.link/)
- [OpenZeppelin](https://openzeppelin.com/)

