// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {MockToken} from "../src/mocks/MockToken.sol";
import {MockOracle} from "../src/mocks/MockOracle.sol";

contract DeployMocks is Script {
    // RWA Token definitions
    struct RwaToken {
        string name;
        string symbol;
        uint256 priceInUsdc; // Price in USDC (6 decimals), e.g., 275 = $275
    }

    function run() external {
        // Define RWA tokens
        RwaToken[3] memory rwaTokens = [
            RwaToken({ name: "StakeStock Apple", symbol: "sAAPL", priceInUsdc: 275 }),
            RwaToken({ name: "StakeStock Amazon", symbol: "sAMZN", priceInUsdc: 226 }),
            RwaToken({ name: "StakeStock Google", symbol: "sGOOG", priceInUsdc: 318 })
        ];

        vm.startBroadcast();

        console.log("=== Deploying RWA Tokens and Oracles ===");
        console.log("");

        // Deploy each RWA token and its oracle
        for (uint256 i = 0; i < rwaTokens.length; i++) {
            RwaToken memory rwa = rwaTokens[i];
            
            // Deploy RWA token (18 decimals)
            MockToken token = new MockToken(rwa.name, rwa.symbol, 18);
            console.log(string.concat(rwa.symbol, " deployed at:"), address(token));

            // Calculate oracle price
            // Oracle price format: (collateral value / loan value) * 1e36
            // For 1 sAAPL (18 decimals) = 275 USDC (6 decimals)
            // Price = (275e6 / 1e18) * 1e36 = 275e24
            uint256 oraclePrice = rwa.priceInUsdc * 1e24;
            
            MockOracle oracle = new MockOracle(oraclePrice);
            console.log(string.concat(rwa.symbol, " Oracle deployed at:"), address(oracle));
            console.log(string.concat(rwa.symbol, " Price: $"), rwa.priceInUsdc);
            console.log("");
        }

        // Deploy Mock USDC (6 decimals)
        console.log("=== Deploying Mock USDC ===");
        MockToken mUsdc = new MockToken("Mock USDC", "mUSDC", 6);
        console.log("mUSDC deployed at:", address(mUsdc));

        // Mint 1,000,000 USDC to deployer (6 decimals)
        uint256 mintAmount = 1_000_000 * 1e6;
        mUsdc.mint(msg.sender, mintAmount);
        console.log("Minted 1,000,000 mUSDC to:", msg.sender);

        vm.stopBroadcast();

        console.log("");
        console.log("=== Deployment Summary ===");
        console.log("Total RWA tokens deployed:", rwaTokens.length);
        console.log("Total oracles deployed:", rwaTokens.length);
        console.log("Mock USDC deployed with 1M initial supply");
    }
}
