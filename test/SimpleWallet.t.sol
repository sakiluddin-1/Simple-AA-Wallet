//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SimpleWallet.sol";
import "openzepplin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract SimpleWalletTest is Test {

    SimpleWallet wallet;

    uint256 ownerPrivateKey = 0xA11CE;
    uint256 attackerPrivateKey = 0xB0B;

    address owner;
    address attacker;

    address recipent = address(1);

    function setUp() public {
        owner = vm.addr(ownerPrivateKey);
        attacker = vm.addr(attackerPrivateKey);

        wallet = new SimpleWallet(owner);

        vm.deal(address(wallet), 10 ether);
    }

    function testValidateUserOp_ValidSignature() public {
        bytes32 hash = keccak256("test");
        bytes32 ethSignedHash = ECDSA.toEthSignedMessageHash(hash);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, ethSignedHash);
        bytes memory sig = abi.encodePacked(r, s, v);

        bool result = wallet.validateUserOp(hash, sig);
        assertTrue(result);
    }

    function testValidateUSerOp_InvalidSignature() public {
        bytes32 hash = keccak256("test");
        bytes32 ethSignedHash = ECDSA.toEthSignedMessageHash(hash);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(attackerPrivateKey, ethSignedHash);
        bytes memory sig = abi.encodePacked(r, s, v);

        vm.expectRevert("You are not the owner");
        wallet.validateUserOp(hash, sig);
    }

    function testExecute_FailesIfNotContractCalling() public {
        vm.expectRevert("Only contract can execute");
        wallet.execute(recipent, 1 ether, "0x");

        vm.expectRevert("Only contract can execute");
        wallet.execute(recipent, 1 ether, "");
    }
}
