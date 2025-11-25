# Deploy Infrastructure
source .env
forge script script/DeployInfrastructure.s.sol:DeployInfrastructure \
  --rpc-url sepolia \
  --private-key $PK_ADMIN \
  --broadcast \
  --verify \
  -vvvv

# Deploy Mocks
source .env
forge script script/DeployMocks.s.sol:DeployMocks \
  --rpc-url sepolia \
  --private-key $PK_ADMIN \
  --broadcast \
  --verify \
  -vvvv

# Enable Standard LLTVs (requires owner)
source .env && forge script script/EnableLLTVs.s.sol:EnableLLTVs \
  --rpc-url sepolia \
  --private-key $PK_ADMIN \
  --broadcast \
  -vv

# Interactive: Create a new market on Morpho Blue
source .env && forge script script/CreateMarket.s.sol:CreateMarket \
  --rpc-url sepolia \
  --private-key $PK_ADMIN \
  --broadcast \
  -vv

# Interactive: Create a new MetaMorpho vault
source .env && forge script script/CreateVault.s.sol:CreateVault \
  --rpc-url sepolia \
  --private-key $PK_ADMIN \
  --broadcast \
  -vv
