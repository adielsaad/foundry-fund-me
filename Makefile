# Include environment variables from .env file
-include .env

# Parameters:
#   --rpc-url: Sepolia RPC endpoint (from .env)
#   --etherscan-api-key: API key for contract verification
#   --account: Keystore account for deployment
#   --broadcast: Broadcast the transaction to the network
#   --verify: Verify the contract on Etherscan
#   -vvvv: Verbose output for debugging

# Deploy the FundMe contract to Sepolia testnet
deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--account $(KEYSTORE_ACCOUNT) \
		--broadcast \
		--verify \
		-vvvv

# Fund the deployed FundMe contract on Sepolia
# This sends 0.05 ETH to the contract
fund-sepolia:
	forge script script/Interactions.s.sol:FundFundMe \
		--rpc-url $(SEPOLIA_RPC_URL) \
		--etherscan-api-key $(ETHERSCAN_API_KEY) \
		--account $(KEYSTORE_ACCOUNT) \
		--broadcast \
		--verify \
		-vvvv