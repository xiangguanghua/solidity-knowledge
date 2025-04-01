// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract LogicV1 {
    // note: storage layout must be the same as contract A
    uint256 public num;
    address public sender;
    uint256 public value;

    function setVars(uint256 _num) public payable {
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract Proxy {
    uint256 public num;
    address public sender;
    uint256 public value;

    address public implementation;
    address public admin;

    constructor(address _impl) {
        admin = msg.sender;
        implementation = _impl;
    }

    event DelegateResponse(bool success, bytes data);
    event CallResponse(bool success, bytes data);

    function upgradeTo(address _newImpl) external {
        require(msg.sender == admin, "Not admin");
        implementation = _newImpl;
    }

    function _delegatecall() internal {
        (bool success, bytes memory data) = implementation.delegatecall(msg.data);
        emit DelegateResponse(success, data);
        if (!success) {
            assembly {
                revert(add(data, 32), mload(data))
            }
        }
        require(success, "Delegatecall failed");
    }

    fallback() external payable {
        _delegatecall();
    }

    receive() external payable {
        _delegatecall();
    }
}
