-include .env
build:; forge build

deploy-sepolia:
	forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $(S_RPC_URL) --private-key $(S_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHER_SCAN_API_KEY) --priority-gas-price 1