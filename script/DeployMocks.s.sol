// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {MockToken} from "../src/mocks/MockToken.sol";
import {MockOracle} from "../src/mocks/MockOracle.sol";

contract DeployMocks is Script {
    function run() external {
        vm.startBroadcast();

        // 1. Deploy Mock Token (RWA Stock)
        string memory name = vm.envOr("TOKEN_NAME", string("StakeStock Apple"));
        string memory symbol = vm.envOr("TOKEN_SYMBOL", string("sAAPL"));
        
        MockToken stock = new MockToken(name, symbol);
        console.log("Mock Stock deployed at:", address(stock));

        // 2. Deploy Mock Oracle
        // Default: 100 * 1e36 (Morpho Blue price scale)
        uint256 defaultPrice = 100e36;
        uint256 initialPrice = vm.envOr("INITIAL_PRICE", defaultPrice);
        
        MockOracle oracle = new MockOracle(initialPrice);
        console.log("Mock Oracle deployed at:", address(oracle));

        vm.stopBroadcast();
    }
}
