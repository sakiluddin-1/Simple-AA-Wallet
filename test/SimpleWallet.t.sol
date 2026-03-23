//SPDX-License-Identifier:MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SimpleWallet.sol";

contract SimpleWalletTest is Test {
    SimpleWallet wallet;

    address owner = address(1);
    address user = address(2);


    function setUp() public {
        wallet = new SimpleWallet(owner);
    }

    function testOwner() public {
        assertEq(wallet.owner(), owner);
    }

    function testExecute() public {
        vm.deal(address(wallet), 1 ether);

        vm.prank(owner);
        wallet.sendEth(user, 0.1 ether, "0x");
        assertEq(user.balance, 0.1 ether);
    }
}