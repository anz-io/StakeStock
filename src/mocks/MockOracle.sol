// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IOracle} from "morpho-blue/interfaces/IOracle.sol";

contract MockOracle is IOracle {
    uint256 public override price;

    constructor(uint256 initialPrice) {
        price = initialPrice;
    }

    function setPrice(uint256 newPrice) external {
        price = newPrice;
    }
}
