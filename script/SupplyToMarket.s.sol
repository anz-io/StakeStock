// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {IMorpho, MarketParams, Id} from "morpho-blue/interfaces/IMorpho.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title SupplyToMarket
/// @notice Admin (msg.sender) supplies mock USDC to a specified market.
contract SupplyToMarket is Script {
    function run() external {
        // Load Morpho address from environment
        address morphoAddress = vm.envAddress("SEP_MORPHO_BLUE");

        console.log("=== Supply to Market ===");
        console.log("Morpho:", morphoAddress);
        console.log("Admin (msg.sender):", msg.sender);
        console.log("");

        // Prompt for market ID (bytes32 hex string)
        string memory marketIdStr = vm.prompt("Market ID (bytes32 hex, e.g., 0xabc...):");
        bytes32 marketId = vm.parseBytes32(marketIdStr);
        Id marketIdWrapped = Id.wrap(marketId);

        // Prompt for supply amount (USDC, 6 decimals)
        uint256 supplyAmount = vm.parseUint(vm.prompt("Supply amount (USDC, 6 decimals):"));

        // Retrieve MarketParams
        IMorpho morpho = IMorpho(morphoAddress);
        MarketParams memory marketParams = morpho.idToMarketParams(marketIdWrapped);

        vm.startBroadcast();
        // Approve USDC to Morpho
        IERC20(marketParams.loanToken).approve(morphoAddress, supplyAmount);
        // Supply assets (shares = 0, data empty)
        morpho.supply(marketParams, supplyAmount, 0, msg.sender, "");
        vm.stopBroadcast();

        console.log("Supply executed for market");
        console.logBytes32(marketId);
    }
}
