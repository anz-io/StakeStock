#!/bin/bash

mkdir -p abi

# Extract ABIs from compiled artifacts
jq '.abi' out/Morpho.sol/Morpho.json > abi/Morpho.json
jq '.abi' out/AdaptiveCurveIrm.sol/AdaptiveCurveIrm.json > abi/AdaptiveCurveIrm.json
jq '.abi' out/MetaMorphoV1_1Factory.sol/MetaMorphoV1_1Factory.json > abi/MetaMorphoV1_1Factory.json
jq '.abi' out/MetaMorphoV1_1.sol/MetaMorphoV1_1.json > abi/MetaMorphoV1_1.json

jq '.abi' out/MockToken.sol/MockToken.json > abi/MockToken.json
jq '.abi' out/MockOracle.sol/MockOracle.json > abi/MockOracle.json

echo "✅ ABIs exported to abi/"
