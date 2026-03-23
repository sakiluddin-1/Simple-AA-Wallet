// SPDX-License-Identifier: MIt
pragma solidity ^0.8.20;

contract SimpleWallet {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "You are not the owner");
        _;
    }

    function sendEth(address _recipent,uint256 _value, bytes calldata data) external onlyOwner {
        (bool success, ) = _recipent.call{value: _value}(data);
        require(success);
    }

    receive() external payable{}

    fallback() external payable{}
}