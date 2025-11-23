// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import {IMorpho} from "morpho-blue/interfaces/IMorpho.sol";
import {MetaMorphoV1_1Factory} from "metamorpho-v1.1/MetaMorphoV1_1Factory.sol";

contract DeployInfrastructure is Script {
    function run() external {
        vm.startBroadcast();

        // 1. Deploy Morpho Blue using deployCode (to avoid version conflict 0.8.19 vs 0.8.26)
        address morphoAddress = deployCode("Morpho.sol", abi.encode(msg.sender));
        console.log("Morpho Blue deployed at:", morphoAddress);
        IMorpho morpho = IMorpho(morphoAddress);

        // 2. Deploy AdaptiveCurveIrm using deployCode
        address irmAddress = deployCode("AdaptiveCurveIrm.sol", abi.encode(morphoAddress));
        console.log("AdaptiveCurveIrm deployed at:", irmAddress);

        // 3. Enable IRM on Morpho Blue
        morpho.enableIrm(irmAddress);
        console.log("AdaptiveCurveIrm enabled on Morpho Blue");

        // 4. Deploy MetaMorpho Factory (Native 0.8.26)
        MetaMorphoV1_1Factory factory = new MetaMorphoV1_1Factory(morphoAddress);
        console.log("MetaMorphoV1_1Factory deployed at:", address(factory));

        vm.stopBroadcast();
    }
}
