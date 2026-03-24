// SPDX-License-Identifier: MIt
pragma solidity ^0.8.20;

import "lib/openzepplin-contracts/contracts/utils/cryptography/ECDSA.sol";

contract SimpleWallet {

    using ECDSA for bytes32;

    address public owner;
    uint256 public nonce;

    constructor(address _owner) {
        owner = _owner;
    }

    function validateUserOp(bytes32 userOpHash, bytes calldata signature) external returns(bool) {
        address signer = userOpHash.toEthSignedMessageHash().recover(signature);

        require(owner == signer, "You are not the owner");

        nonce++;
        return true;
    }

    function execute(address to, uint256 _value, bytes calldata data) external {
        require(msg.sender == address(this), "Only contract can call");

        (bool success, ) = to.call{value : _value}(data);
        require(success, "Tx failed");
    }

    receive() external payable{}

    fallback() external payable{}
}