// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {IMorpho, MarketParams, Id} from "morpho-blue/interfaces/IMorpho.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title SupplyCollateralAndBorrow
/// @notice Interactive script for a user to supply collateral and then borrow USDC from a market.
contract SupplyCollateralAndBorrow is Script {
    function run() external {
        // Load environment variables
        address morphoAddress = vm.envAddress("SEP_MORPHO_BLUE");

        console.log("=== Supply Collateral & Borrow ===");
        console.log("Morpho:", morphoAddress);
        console.log("User (msg.sender):", msg.sender);
        console.log("");

        // Prompt for market id (bytes32 hex string)
        string memory marketIdStr = vm.prompt("Market ID (bytes32 hex, e.g., 0xabc...):");
        bytes32 marketId = vm.parseBytes32(marketIdStr);
        Id marketIdWrapped = Id.wrap(marketId);

        // Prompt for collateral amount (in collateral token decimals)
        uint256 collateralAmount = vm.parseUint(vm.prompt("Collateral amount (token decimals):"));
        // Prompt for borrow amount (USDC, 6 decimals)
        uint256 borrowAmount = vm.parseUint(vm.prompt("Borrow amount (USDC, 6 decimals):"));

        // Retrieve MarketParams from Morpho storage
        IMorpho morpho = IMorpho(morphoAddress);
        MarketParams memory marketParams = morpho.idToMarketParams(marketIdWrapped);

        vm.startBroadcast();
        // Approve collateral token to Morpho
        IERC20(marketParams.collateralToken).approve(morphoAddress, collateralAmount);
        // Supply collateral (shares = 0, data empty)
        morpho.supplyCollateral(marketParams, collateralAmount, msg.sender, "");
        // Borrow USDC (shares = 0, onBehalf = msg.sender, receiver = msg.sender)
        morpho.borrow(marketParams, borrowAmount, 0, msg.sender, msg.sender);
        vm.stopBroadcast();

        console.log("Collateral supplied and borrow executed for market");
        console.logBytes32(marketId);
    }
}
