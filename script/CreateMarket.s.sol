// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {IMorpho, MarketParams} from "morpho-blue/interfaces/IMorpho.sol";

/// @title CreateMarket
/// @notice Interactive script to create a new market on Morpho Blue
contract CreateMarket is Script {
    function run() external {
        // Load Morpho Blue address from environment
        address morphoAddress = vm.envAddress("SEP_MORPHO_BLUE");
        address irmAddress = vm.envAddress("SEP_ADAPTIVE_IRM");

        console.log("=== Create Morpho Blue Market ===");
        console.log("Morpho Blue:", morphoAddress);
        console.log("IRM:", irmAddress);
        console.log("");

        // Get market parameters from user
        console.log("Enter market parameters:");
        address loanToken = vm.parseAddress(vm.prompt("Loan Token Address (e.g., mUSDC):"));
        address collateralToken = vm.parseAddress(vm.prompt("Collateral Token Address (e.g., sAAPL):"));
        address oracle = vm.parseAddress(vm.prompt("Oracle Address:"));

        // LLTV input (choose from predefined options)
        console.log("Select LLTV option (choose one of: 38, 62, 77, 86, 91, 94, 96, 98)");
        uint256 lltvChoice = vm.parseUint(vm.prompt("LLTV option:"));
        uint256 lltv;
        if (lltvChoice == 38 || lltvChoice == 62 || lltvChoice == 91 || lltvChoice == 94 || lltvChoice == 96) {
            // .5 percentages (e.g., 38.5% -> 0.385e18)
            lltv = (lltvChoice * 10 + 5) * 1e15;
        } else {
            // whole percentages (e.g., 77% -> 0.77e18)
            lltv = lltvChoice * 1e16;
        }

        console.log("");
        console.log("=== Market Parameters ===");
        console.log("Loan Token:", loanToken);
        console.log("Collateral Token:", collateralToken);
        console.log("Oracle:", oracle);
        console.log("IRM:", irmAddress);
        console.log("LLTV:", lltvChoice, "%"); // Display the chosen percentage
        console.log("");

        // Confirm
        string memory confirm = vm.prompt("Create this market? (yes/no):");
        require(keccak256(bytes(confirm)) == keccak256(bytes("yes")), "Market creation cancelled");

        // Create market params
        MarketParams memory marketParams = MarketParams({
            loanToken: loanToken, collateralToken: collateralToken, oracle: oracle, irm: irmAddress, lltv: lltv
        });

        vm.startBroadcast();

        IMorpho morpho = IMorpho(morphoAddress);

        // Check if LLTV is enabled
        if (!morpho.isLltvEnabled(lltv)) {
            console.log("WARNING: LLTV not enabled. You need to enable it first (requires owner).");
            console.log("Skipping market creation.");
            vm.stopBroadcast();
            return;
        }

        // Create market
        morpho.createMarket(marketParams);

        console.log("");
        console.log("=== Market Created Successfully! ===");

        vm.stopBroadcast();
    }
}
