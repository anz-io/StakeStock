source .env
forge script script/DeployInfrastructure.s.sol:DeployInfrastructure \
  --rpc-url sepolia \
  --private-key $PK_ADMIN \
  --broadcast \
  --verify \
  -vvvv

source .env
forge script script/DeployMocks.s.sol:DeployMocks \
  --rpc-url sepolia \
  --private-key $PK_ADMIN \
  --broadcast \
  --verify \
  -vvvv
