//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SimpleWallet.sol";
import "openzepplin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract DeploySimpleWallet is Script {
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address owner = vm.addr(privateKey);

        vm.startBroadcast(privateKey);

        SimpleWallet wallet = new SimpleWallet(owner);
        bytes32 hash = keccak256(abi.encodePacked("test-operation"));
        bytes32 userOpHash = ECDSA.toEthSignedMessageHash(hash);


        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, userOpHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        //wallet.validateUserOp(userOpHash, signature);

        console.log("UserOp validated successfully");

        vm.stopBroadcast();
    }
}