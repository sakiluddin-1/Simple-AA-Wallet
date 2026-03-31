// SPDX-License-Identifier: MIt
pragma solidity ^0.8.30;

import "lib/openzepplin-contracts/contracts/utils/cryptography/ECDSA.sol";
import "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";

contract SimpleWallet {
    using ECDSA for bytes32;

    address public owner;
    uint256 public nonce;
    IEntryPoint public entryPoint;

    constructor(address _owner, address _entryPoint) {
        owner = _owner;
        entryPoint = IEntryPoint(_entryPoint);
    }

    modifier onlyEntryPoint() {
        require(msg.sender == address(entryPoint), "Not EntryPoint");
        _;
    }

    function validateUSerOp(bytes32 userOpHash, bytes calldata signature) external onlyEntryPoint returns(bool) {
        address signer = userOpHash.toEthSignedMessageHash().recover(signature);
        require(signer == owner, "You are not the owner");

        nonce ++;

        return true;
    }

    function execute(address _to, uint256 _value, bytes calldata _data) external onlyEntryPoint {
        (bool success, ) = _to.call{value: _value}(_data);
        require(success, "Transaction failed");
    }

    receive() external payable{}
    fallback() external payable{}
}