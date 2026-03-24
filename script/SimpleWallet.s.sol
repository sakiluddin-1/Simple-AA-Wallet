//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SimpleWallet.sol";

contract DeploySimpleWallet is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast();

        address owner = vm.addr(deployerPrivateKey);

        SimpleWallet wallet = new SimpleWallet(owner);

        console.log("Contract deployed at: ", address(wallet));
        console.log("Owner: ", owner);

        vm.stopBroadcast();
    }
}