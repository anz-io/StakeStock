# StakeStock Contracts

Foundry-based smart contract project for deploying and managing Morpho Blue markets and MetaMorpho vaults for RWA tokens.

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Git](https://git-scm.com/)

## Setup

1.  **Clone the repository:**
    ```bash
    git clone <repo-url>
    cd T-StakeStock
    ```

2.  **Install dependencies:**
    ```bash
    forge install
    ```

3.  **Configure Environment:**
    Copy `.env.example` to `.env` and fill in the required values:
    ```bash
    cp .env.example .env
    ```
    Required variables:
    - `RPC_URL_SEPOLIA`: Sepolia RPC URL (e.g., from Alchemy/Infura)
    - `PK_ADMIN`: Private key for the admin/deployer account
    - `PK_USER`: Private key for a test user account (for borrowing/supplying)
    - `ETHERSCAN_API_KEY`: For contract verification

## Deployment & Scripts

All commands are consolidated in `script/commands.sh` for easy reference.

### 1. Deploy Infrastructure
Deploys core Morpho Blue contracts (if not using official deployment) and MetaMorpho Factory.
```bash
source .env && forge script script/DeployInfrastructure.s.sol:DeployInfrastructure \
  --rpc-url sepolia \
  --private-key $PK_ADMIN \
  --broadcast \
  --verify \
  -vvvv
```

### 2. Deploy Mocks
Deploys mock RWA tokens (sAAPL, sAMZN, sGOOG), mock USDC, and their oracles. Mints initial USDC to the admin.
```bash
source .env && forge script script/DeployMocks.s.sol:DeployMocks \
  --rpc-url sepolia \
  --private-key $PK_ADMIN \
  --broadcast \
  --verify \
  -vvvv
```

### 3. Enable Standard LLTVs
Enables Morpho-recommended LLTV values on the Morpho Blue contract.
```bash
source .env && forge script script/EnableLLTVs.s.sol:EnableLLTVs \
  --rpc-url sepolia \
  --private-key $PK_ADMIN \
  --broadcast \
  -vv
```

## Interactive Management

These scripts use `vm.prompt` to interactively guide you through operations.

### Create Market
Creates a new market on Morpho Blue. You will need the addresses of the Loan Token, Collateral Token, and Oracle (from "Deploy Mocks" output).
```bash
source .env && forge script script/CreateMarket.s.sol:CreateMarket \
  --rpc-url sepolia \
  --private-key $PK_ADMIN \
  --broadcast \
  -vv
```

### Create Vault
Creates a new MetaMorpho vault.
```bash
source .env && forge script script/CreateVault.s.sol:CreateVault \
  --rpc-url sepolia \
  --private-key $PK_ADMIN \
  --broadcast \
  -vv
```

### Supply Liquidity (Admin)
Supplies mock USDC to a specific market.
```bash
source .env && forge script script/SupplyToMarket.s.sol:SupplyToMarket \
  --rpc-url sepolia \
  --private-key $PK_ADMIN \
  --broadcast \
  -vv
```

### Supply Collateral & Borrow (User)
Simulates a user supplying collateral and borrowing from a market.
```bash
source .env && forge script script/SupplyCollateralAndBorrow.s.sol:SupplyCollateralAndBorrow \
  --rpc-url sepolia \
  --private-key $PK_USER \
  --broadcast \
  -vv
```

## Project Structure

- `src/`: Smart contracts (Mocks, etc.)
- `script/`: Deployment and interaction scripts
    - `DeployInfrastructure.s.sol`: Core contract deployment
    - `DeployMocks.s.sol`: Mock token/oracle deployment
    - `EnableLLTVs.s.sol`: LLTV configuration
    - `CreateMarket.s.sol`: Interactive market creation
    - `CreateVault.s.sol`: Interactive vault creation
    - `SupplyToMarket.s.sol`: Liquidity supply script
    - `SupplyCollateralAndBorrow.s.sol`: Borrowing script
- `lib/`: Dependencies (Morpho Blue, MetaMorpho, OpenZeppelin, etc.)
