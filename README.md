# FundMe Smart Contract

A decentralized funding platform built with Solidity and Foundry. This project allows users to fund a contract with ETH and withdraw funds (restricted to the contract owner).

## Features

- Fund the contract with ETH (minimum 0.01 ETH)
- Withdraw funds (owner only)
- Price feed integration using Chainlink
- Contract verification on Etherscan
- Comprehensive test coverage
- Deployment scripts for Sepolia testnet

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Make](https://www.gnu.org/software/make/)
- Sepolia ETH (for deployment and testing)
- Etherscan API Key (for contract verification)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/foundry-fund-me.git
cd foundry-fund-me
```

2. Install dependencies:
```bash
forge install
```

3. Create a `.env` file with the following variables:
```env
SEPOLIA_RPC_URL=your_sepolia_rpc_url
ETHERSCAN_API_KEY=your_etherscan_api_key
KEYSTORE_ACCOUNT=your_keystore_account
```

## Usage

### Build the Project
```bash
make build
```

### Deploy to Sepolia
```bash
make deploy-sepolia
```

### Fund the Contract
```bash
make fund-sepolia
```

## Project Structure

```
foundry-fund-me/
├── src/                    # Source contracts
│   └── FundMe.sol         # Main contract
├── test/                   # Test files
│   └── unit/              # Unit tests
├── script/                 # Deployment and interaction scripts
│   ├── DeployFundMe.s.sol # Deployment script
│   └── Interactions.s.sol # Interaction scripts
├── lib/                    # Dependencies
├── out/                    # Compiled artifacts
├── .env                    # Environment variables
├── foundry.toml           # Foundry configuration
└── Makefile               # Build and deployment commands
```

## Testing

Run the test suite:
```bash
forge test
```

## Contract Details

### FundMe Contract
- Minimum funding amount: 0.01 ETH
- Funding amount in Interactions script: 0.05 ETH
- Uses Chainlink price feed for ETH/USD conversion
- Owner can withdraw all funds
