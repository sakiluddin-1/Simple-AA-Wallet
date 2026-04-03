// SPDX-License-Identifier: MIt
pragma solidity ^0.8.30;

import "lib/openzepplin-contracts/contracts/utils/cryptography/ECDSA.sol";
import "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";


contract SimpleWallet {
    using ECDSA for bytes32;

    address public owner;
    uint256 nonce;
    IEntryPoint public immutable entryPoint;

    constructor(address _entryPoint, address _owner) {
        owner = _owner;
        entryPoint = IEntryPoint(_entryPoint);
    }
    
    struct SessionKey {
        uint256 expiry;
        uint256 limit;
        uint256 spent;
    }

    mapping(address => SessionKey) public sessionKeys;

    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }
    modifier onlyEntryPoint() {
        require(msg.sender == address(entryPoint), "Not called by entryPoint");
        _;
    }

    function addSessionKeys(address key, uint256 expiry, uint256 limit) external onlyOwner{
        sessionKeys[key] = SessionKey({
            expiry: expiry,
            limit: limit,
            spent: 0
        });
    }

    function vlidateUserOp(bytes32 userOpHash, bytes calldata signature) external returns(bool) {
        address signer = userOpHash.toEthSignedMessageHash().recover(signature);

        if(signer == owner) {
            nonce ++;
            return true;
        }

        SessionKey storage session = sessionKeys[signer];

        require(block.timestamp < session.expiry, "Session has expired");
        require(session.spent <= session.limit, "Limit exceeded");

        session.spent += 1;

        nonce ++;

        return true;
    }

    function execute(address _to, uint256 _value, bytes calldata data) external onlyEntryPoint {
        (bool success, ) = _to.call{value: _value}(data);

        require(success, "Tx failed");
    }

    receive() external payable {}

    fallback() external payable {} 
}