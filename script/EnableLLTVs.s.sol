// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {IMorpho} from "morpho-blue/interfaces/IMorpho.sol";

/// @title EnableLLTVs
/// @notice Script to enable standard LLTVs on Morpho Blue
contract EnableLLTVs is Script {
    function run() external {
        address morphoAddress = vm.envAddress("SEP_MORPHO_BLUE");
        IMorpho morpho = IMorpho(morphoAddress);

        console.log("=== Enable Standard LLTVs ===");
        console.log("Morpho Blue:", morphoAddress);
        console.log("");

        // Standard LLTVs (scaled by 1e18)
        // 38.5%, 62.5%, 77.0%, 86.0%, 91.5%, 94.5%, 96.5%, 98.0%
        uint256[] memory lltvs = new uint256[](8);
        lltvs[0] = 0.385e18; // 38.5%
        lltvs[1] = 0.625e18; // 62.5%
        lltvs[2] = 0.77e18; // 77.0%
        lltvs[3] = 0.86e18; // 86.0%
        lltvs[4] = 0.915e18; // 91.5%
        lltvs[5] = 0.945e18; // 94.5%
        lltvs[6] = 0.965e18; // 96.5%
        lltvs[7] = 0.98e18; // 98.0%

        vm.startBroadcast();

        for (uint256 i = 0; i < lltvs.length; i++) {
            uint256 lltv = lltvs[i];

            if (morpho.isLltvEnabled(lltv)) {
                console.log("LLTV already enabled:", lltv);
            } else {
                morpho.enableLltv(lltv);
                console.log("Enabled LLTV:", lltv);
            }
        }

        vm.stopBroadcast();

        console.log("");
        console.log("=== All Standard LLTVs Enabled ===");
    }
}
