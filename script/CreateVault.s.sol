// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {IMetaMorphoV1_1Factory} from "metamorpho-v1.1/interfaces/IMetaMorphoV1_1Factory.sol";
import {IMetaMorphoV1_1} from "metamorpho-v1.1/interfaces/IMetaMorphoV1_1.sol";

/// @title CreateVault
/// @notice Interactive script to create a new MetaMorpho vault
contract CreateVault is Script {
    function run() external {
        // Load addresses from environment
        address factoryAddress = vm.envAddress("SEP_MORPHO_FACTORY");
        address morphoAddress = vm.envAddress("SEP_MORPHO_BLUE");
        
        console.log("=== Create MetaMorpho Vault ===");
        console.log("Factory:", factoryAddress);
        console.log("Morpho Blue:", morphoAddress);
        console.log("");

        // Get vault parameters from user
        console.log("Enter vault parameters:");
        
        address initialOwner = vm.parseAddress(
            vm.prompt("Initial Owner Address (who will manage the vault):")
        );
        
        string memory timelockInput = vm.prompt(
            "Initial Timelock in seconds (e.g., 86400 for 1 day, 0 for no timelock):"
        );
        uint256 initialTimelock = vm.parseUint(timelockInput);
        
        address asset = vm.parseAddress(
            vm.prompt("Asset Address (e.g., mUSDC - the token users will deposit):")
        );
        
        string memory name = vm.prompt("Vault Name (e.g., 'StakeStock USDC Vault'):");
        string memory symbol = vm.prompt("Vault Symbol (e.g., 'ssUSDC'):");
        
        // Generate a random salt or let user provide one
        string memory saltInput = vm.prompt(
            "Salt (leave empty for random, or provide hex string):"
        );
        bytes32 salt;
        if (bytes(saltInput).length == 0) {
            salt = keccak256(abi.encodePacked(block.timestamp, msg.sender, name));
        } else {
            salt = vm.parseBytes32(saltInput);
        }
        
        console.log("");
        console.log("=== Vault Parameters ===");
        console.log("Owner:", initialOwner);
        console.log("Timelock:", initialTimelock, "seconds");
        console.log("Asset:", asset);
        console.log("Name:", name);
        console.log("Symbol:", symbol);
        console.log("Salt:", vm.toString(salt));
        console.log("");

        // Confirm
        string memory confirm = vm.prompt("Create this vault? (yes/no):");
        require(
            keccak256(bytes(confirm)) == keccak256(bytes("yes")),
            "Vault creation cancelled"
        );

        vm.startBroadcast();

        IMetaMorphoV1_1Factory factory = IMetaMorphoV1_1Factory(factoryAddress);
        
        // Create vault
        IMetaMorphoV1_1 vault = factory.createMetaMorpho(
            initialOwner,
            initialTimelock,
            asset,
            name,
            symbol,
            salt
        );
        
        console.log("");
        console.log("=== Vault Created Successfully! ===");
        console.log("Vault Address:", address(vault));
        console.log("");
        console.log("Next steps:");
        console.log("1. Set curator (optional)");
        console.log("2. Submit market caps");
        console.log("3. Set supply/withdraw queues");
        console.log("4. Set fee recipient (if charging fees)");
        
        vm.stopBroadcast();
    }
}
