// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {NexusToken} from "../src/NexusToken.sol";

contract NexusDeploy is Script {
    function run() external returns (address) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address treasury = vm.envAddress("TREASURY");

        string memory name = "Nexus Token";
        string memory symbol = "NXS";
        uint256 mintPrice = 833333333333333;
        uint256 maxSupply = 100000000 * 1e18;

        vm.startBroadcast(deployerPrivateKey);
        NexusToken token = new NexusToken(name, symbol, mintPrice, maxSupply, treasury);
        vm.stopBroadcast();

        return address(token);
    }
}
